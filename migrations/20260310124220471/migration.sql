BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "normalized_metrics" (
    "id" bigserial PRIMARY KEY,
    "playerId" bigint NOT NULL,
    "metricKey" text NOT NULL,
    "rawValue" double precision,
    "normalizedValue" double precision,
    "unit" text,
    "computedAt" timestamp without time zone NOT NULL,
    "confidence" double precision NOT NULL,
    "sourceKeys" json,
    "details" text
);

-- Indexes
CREATE INDEX "normalized_metrics_idx" ON "normalized_metrics" USING btree ("playerId", "metricKey");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "player_aliases" (
    "id" bigserial PRIMARY KEY,
    "playerId" bigint NOT NULL,
    "alias" text NOT NULL,
    "sourceId" bigint,
    "linkedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "player_aliases_idx" ON "player_aliases" USING btree ("playerId", "alias");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "players" (
    "id" bigserial PRIMARY KEY,
    "playerId" text NOT NULL,
    "displayName" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "lastSeen" timestamp without time zone,
    "metadata" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "player_idx" ON "players" USING btree ("playerId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "raw_events" (
    "id" bigserial PRIMARY KEY,
    "eventUuid" text NOT NULL,
    "playerId" bigint NOT NULL,
    "sourceId" bigint NOT NULL,
    "eventType" text NOT NULL,
    "payload" text NOT NULL,
    "receivedAt" timestamp without time zone NOT NULL,
    "processed" boolean NOT NULL,
    "processingError" text
);

-- Indexes
CREATE INDEX "raw_events_idx" ON "raw_events" USING btree ("playerId", "sourceId", "processingError");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "score_history" (
    "id" bigserial PRIMARY KEY,
    "playerId" bigint NOT NULL,
    "scoreType" text NOT NULL,
    "scoreValue" double precision NOT NULL,
    "computedAt" timestamp without time zone NOT NULL,
    "components" json NOT NULL
);

-- Indexes
CREATE INDEX "score_history_idx" ON "score_history" USING btree ("playerId", "scoreType", "computedAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "scores" (
    "id" bigserial PRIMARY KEY,
    "playerId" bigint NOT NULL,
    "scoreType" text NOT NULL,
    "scoreValue" double precision NOT NULL,
    "components" json NOT NULL,
    "rawComponents" text,
    "computedAt" timestamp without time zone NOT NULL,
    "confidence" double precision NOT NULL,
    "explanation" text
);

-- Indexes
CREATE INDEX "score_idx" ON "scores" USING btree ("playerId", "scoreType");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "sources" (
    "id" bigserial PRIMARY KEY,
    "sourceKey" text NOT NULL,
    "type" text NOT NULL,
    "trustLevel" double precision NOT NULL,
    "config" text,
    "lastSync" timestamp without time zone,
    "enabled" boolean NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "sources_idx" ON "sources" USING btree ("sourceKey");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "normalized_metrics"
    ADD CONSTRAINT "normalized_metrics_fk_0"
    FOREIGN KEY("playerId")
    REFERENCES "players"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "player_aliases"
    ADD CONSTRAINT "player_aliases_fk_0"
    FOREIGN KEY("playerId")
    REFERENCES "players"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "player_aliases"
    ADD CONSTRAINT "player_aliases_fk_1"
    FOREIGN KEY("sourceId")
    REFERENCES "sources"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "raw_events"
    ADD CONSTRAINT "raw_events_fk_0"
    FOREIGN KEY("playerId")
    REFERENCES "players"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "raw_events"
    ADD CONSTRAINT "raw_events_fk_1"
    FOREIGN KEY("sourceId")
    REFERENCES "sources"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "score_history"
    ADD CONSTRAINT "score_history_fk_0"
    FOREIGN KEY("playerId")
    REFERENCES "players"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "scores"
    ADD CONSTRAINT "scores_fk_0"
    FOREIGN KEY("playerId")
    REFERENCES "players"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR evefrontier_club
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('evefrontier_club', '20260310124220471', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260310124220471', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260129180959368', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129180959368', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260213194423028', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260213194423028', "timestamp" = now();

--
-- MIGRATION VERSION FOR evefrontier_index
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('evefrontier_index', '20260310123003084', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260310123003084', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260129181112269', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181112269', "timestamp" = now();


COMMIT;
