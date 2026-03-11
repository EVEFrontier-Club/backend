# EVE Frontier Club — Backend

This is the backend core of **EVE Frontier Club**, a modular analytics and reputation platform for the EVE Frontier universe. Built with [Serverpod](https://serverpod.dev) and written in Dart, it powers services like **EVE Frontier Index** — a trust-based rating system for players, corporations, and regions.

## 🚀 Modules

The backend is structured as independent, pluggable modules. Each module defines its own database models, services, and endpoints.

- `evefrontier_index`: Credit-score-style trust rating for players based on economic, behavioral, and social metrics.
- `corp_index` _(coming soon)_: Reliability and governance scores for corporations.
- `region_index` _(planned)_: Economic health and risk indicators for regions.

## 🧱 Tech Stack

- **Language**: Dart
- **Framework**: Serverpod
- **Database**: PostgreSQL
- **Deployment**: Docker-ready, modular architecture
- **Frontend**: Jaspr (see separate repo)

## 🛠 Setup

```bash
docker compose up --build --detach
```

Then you can start the Serverpod server.

```bash
dart bin/main.dart
```

When you are finished, you can shut down Serverpod with `Ctrl-C`, then stop Postgres and Redis.

```bash
docker compose stop
```
