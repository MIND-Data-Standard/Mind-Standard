-- =============================================================
--  MIND Core Relational Schema (v0.1)
--  Defines metadata, execution, and multimodal timeseries tables
--  Derived from LABO software data model
--  © 2025 SilicoLabs. Licensed under CC-BY-4.0
-- =============================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- =============================================================
-- 1. RESEARCHERS AND EXPERIMENT METADATA
-- =============================================================

CREATE TABLE Researcher (
                            researcher_id SERIAL PRIMARY KEY,
                            guid UUID NOT NULL UNIQUE DEFAULT gen_random_uuid(),
                            name TEXT NOT NULL,
                            email TEXT UNIQUE
);

CREATE TABLE Experience (
                            experience_id SERIAL PRIMARY KEY,
                            guid UUID NOT NULL UNIQUE DEFAULT gen_random_uuid(),
                            researcher_id INT NOT NULL REFERENCES Researcher(researcher_id),
                            name TEXT NOT NULL,
                            description TEXT,
                            created_at TIMESTAMP DEFAULT NOW(),
                            updated_at TIMESTAMP DEFAULT NOW(),
                            CONSTRAINT unique_researcher_experience UNIQUE (researcher_id, name)
);

CREATE TABLE SessionType (
                             session_type_id SERIAL PRIMARY KEY,
                             guid UUID NOT NULL UNIQUE DEFAULT gen_random_uuid(),
                             experience_id INT NOT NULL REFERENCES Experience(experience_id),
                             name TEXT NOT NULL,
                             description TEXT
);

CREATE TABLE Run (
                     run_id SERIAL PRIMARY KEY,
                     guid UUID NOT NULL UNIQUE DEFAULT gen_random_uuid(),
                     experience_id INT NOT NULL REFERENCES Experience(experience_id),
                     session_type_id INT REFERENCES SessionType(session_type_id),
                     participant_id TEXT NOT NULL,
                     session_guid UUID NOT NULL UNIQUE DEFAULT gen_random_uuid(),
                     start_time TIMESTAMP NOT NULL,
                     end_time TIMESTAMP,
                     duration_seconds DOUBLE PRECISION GENERATED ALWAYS AS (
                         EXTRACT(EPOCH FROM (end_time - start_time))
                         ) STORED,
                     num_epochs INT,
                     num_devices INT,
                     num_software INT,
                     notes TEXT,
                     created_at TIMESTAMP DEFAULT NOW()
);

-- =============================================================
-- 2. EPOCH DEFINITIONS
-- =============================================================

CREATE TABLE Epoch (
                       epoch_id SERIAL PRIMARY KEY,
                       guid UUID NOT NULL UNIQUE DEFAULT gen_random_uuid(),
                       experience_id INT NOT NULL REFERENCES Experience(experience_id),
                       name TEXT,
                       description TEXT
);

-- =============================================================
-- 3. EXECUTION & SYNCHRONISATION
-- =============================================================

CREATE TABLE ExperienceExecution (
                                     execution_id BIGSERIAL PRIMARY KEY,
                                     run_id INT NOT NULL REFERENCES Run(run_id),
                                     frame_number BIGINT NOT NULL,
                                     timestamp DOUBLE PRECISION NOT NULL,
                                     epoch_guid UUID REFERENCES Epoch(guid),
                                     epoch_number INT NOT NULL,
                                     created_at TIMESTAMP DEFAULT NOW(),
                                     UNIQUE (run_id, frame_number)
);

CREATE INDEX idx_execution_run_frame ON ExperienceExecution(run_id, frame_number);

-- =============================================================
-- 4. EVENT & ACTION LOGS
-- =============================================================

CREATE TABLE EventPoint (
                            event_id BIGSERIAL PRIMARY KEY,
                            run_id INT NOT NULL REFERENCES Run(run_id),
                            frame_number BIGINT NOT NULL,
                            event_number INT NOT NULL,
                            name TEXT,
                            source TEXT,
                            source_type TEXT,
                            timestamp DOUBLE PRECISION,
                            created_at TIMESTAMP DEFAULT NOW(),
                            UNIQUE (run_id, event_number)
);

CREATE TABLE Action (
                        action_id BIGSERIAL PRIMARY KEY,
                        event_id BIGINT NOT NULL REFERENCES EventPoint(event_id) ON DELETE CASCADE,
                        type TEXT NOT NULL,
                        parameters JSONB,
                        created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_event_run_frame ON EventPoint(run_id, frame_number);

-- =============================================================
-- 5. EYE TRACKING
-- =============================================================

CREATE TABLE EyeTracking (
                             eye_id BIGSERIAL PRIMARY KEY,
                             run_id INT NOT NULL REFERENCES Run(run_id),
                             frame_number BIGINT NOT NULL,
                             sample_index INT DEFAULT 0,
                             timestamp DOUBLE PRECISION,
                             eye_pose JSONB, -- See schema/defs/eyePose.def.json
                             created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_eye_run_frame ON EyeTracking(run_id, frame_number);

-- =============================================================
-- 6. FACE TRACKING
-- =============================================================

CREATE TABLE FaceTracking (
                              face_id BIGSERIAL PRIMARY KEY,
                              run_id INT NOT NULL REFERENCES Run(run_id),
                              frame_number BIGINT NOT NULL,
                              timestamp DOUBLE PRECISION,
                              coefficients JSONB, -- See schema/defs/faceCoefficients.def.json
                              created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_face_run_frame ON FaceTracking(run_id, frame_number);

-- =============================================================
-- 7. BODY TRACKING
-- =============================================================

CREATE TABLE BodyTracking (
                              body_id BIGSERIAL PRIMARY KEY,
                              run_id INT NOT NULL REFERENCES Run(run_id),
                              frame_number BIGINT NOT NULL,
                              bone_name TEXT NOT NULL,
                              confidence DOUBLE PRECISION,
                              pose JSONB, -- See schema/defs/pose.def.json
                              created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_body_run_frame ON BodyTracking(run_id, frame_number);

-- =============================================================
-- 8. HAND TRACKING
-- =============================================================

CREATE TABLE HandTracking (
                              hand_id BIGSERIAL PRIMARY KEY,
                              run_id INT NOT NULL REFERENCES Run(run_id),
                              frame_number BIGINT NOT NULL,
                              hand TEXT CHECK (hand IN ('Left','Right')),
                              bone_name TEXT NOT NULL,
                              confidence DOUBLE PRECISION,
                              pose JSONB, -- See schema/defs/pose.def.json
                              created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_hand_run_frame ON HandTracking(run_id, frame_number);

-- =============================================================
-- 9. VARIABLE METADATA AND UPDATES
-- =============================================================

CREATE TABLE VariableMeta (
                              variable_guid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                              name TEXT NOT NULL,
                              description TEXT,
                              scope TEXT CHECK (scope IN ('Global','Local')),
                              value_type TEXT CHECK (value_type IN ('Single','Array')),
                              data_type TEXT,
                              modifier TEXT
);

CREATE TABLE VariableUpdate (
                                update_id BIGSERIAL PRIMARY KEY,
                                run_id INT NOT NULL REFERENCES Run(run_id),
                                variable_guid UUID NOT NULL REFERENCES VariableMeta(variable_guid),
                                frame_number BIGINT,
                                timestamp DOUBLE PRECISION,
                                value TEXT,
                                created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_variable_run_frame ON VariableUpdate(run_id, frame_number);

-- =============================================================
-- 10. OPTIONAL FUTURE EXPANSIONS
-- =============================================================

-- Table: Device (hardware metadata)
CREATE TABLE Device (
                        device_id SERIAL PRIMARY KEY,
                        name TEXT NOT NULL,
                        type TEXT,
                        manufacturer TEXT,
                        serial_number TEXT,
                        software_version TEXT
);

-- Table: Software (runtime metadata)
CREATE TABLE Software (
                          software_id SERIAL PRIMARY KEY,
                          name TEXT NOT NULL,
                          version TEXT,
                          developer TEXT
);

-- Linking devices and software to runs
CREATE TABLE RunDevice (
                           run_id INT NOT NULL REFERENCES Run(run_id),
                           device_id INT NOT NULL REFERENCES Device(device_id),
                           PRIMARY KEY (run_id, device_id)
);

CREATE TABLE RunSoftware (
                             run_id INT NOT NULL REFERENCES Run(run_id),
                             software_id INT NOT NULL REFERENCES Software(software_id),
                             PRIMARY KEY (run_id, software_id)
);

-- =============================================================
-- End of MIND Core Schema
-- =============================================================
