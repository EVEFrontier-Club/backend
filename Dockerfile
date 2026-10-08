# syntax=docker/dockerfile:1

# ---------- Build stage ----------
FROM dart:3.10 AS build

WORKDIR /app

# Copy dependency manifests first for layer caching.
# pubspec.lock is deliberately NOT copied: it is gitignored, so it is absent from a
# clean checkout / CI build context and `COPY` would fail on the missing source. The
# image therefore resolves the latest versions allowed by pubspec.yaml at build time.
COPY pubspec.yaml ./
RUN dart pub get

# Copy source and compile
COPY . .
RUN dart compile exe bin/main.dart -o bin/server

# ---------- Runtime stage ----------
FROM debian:bookworm-slim AS runtime

# Install curl for healthcheck
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN groupadd --gid 1001 appgroup \
    && useradd --uid 1001 --gid appgroup --shell /usr/sbin/nologin appuser

WORKDIR /app

# Copy compiled binary
COPY --from=build /app/bin/server ./server

# Copy configs (passwords.yaml is gitignored and must be mounted at runtime)
COPY config/production.yaml ./config/production.yaml
COPY config/generator.yaml ./config/generator.yaml

# Copy migrations
COPY migrations ./migrations

# Copy generated protocol.yaml (needed for endpoint log filter)
COPY lib/src/generated/protocol.yaml ./lib/src/generated/protocol.yaml

# Set ownership
RUN chown -R appuser:appgroup /app

# Environment variables
ENV runmode=production \
    serverid=default \
    logging=normal \
    role=monolith

# Expose ports: api, insights, web
EXPOSE 8080 8081 8082

# Healthcheck
# /readyz is served by the main API server on 8080 (8081 = insights, 8082 = web).
# Start period covers first-boot database migrations, which run before the server
# begins listening; 30s is generous enough for a cold Postgres on a small host.
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
    CMD curl -f http://localhost:8080/readyz || exit 1

# Switch to non-root user
USER appuser

# Entrypoint and default command
ENTRYPOINT ["./server"]
CMD ["--mode=production", "--server-id=default", "--logging=normal", "--role=monolith", "--apply-migrations"]
