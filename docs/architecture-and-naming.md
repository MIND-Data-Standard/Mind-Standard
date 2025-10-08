# MIND Schema Architecture and Naming Conventions

Purpose: Provide clear conventions so tooling and future scripts implement new schemas consistently and unambiguously.

Core layers
- primitive: Smallest reusable numeric/data atoms (was: defs). Examples: coordinate, vector3, quaternion, timestamp.
- type: Compositions built from primitives. Examples: pose, velocity, transform, metadataRef.
- sample: Time-series record shapes for storage/streaming (row-level). Examples: joint.sample, bone.sample, trackedObject.sample, hand.sample.
- meta: Non-time-series static or slowly-changing information (session, devices, participants, skeletons, joints, bones, software, etc.).

Canonical $id layout
- Primitive: https://mind-schema.org/schemas/primitive/{name}.json
- Type:      https://mind-schema.org/schemas/type/{name}.json
- Sample:    https://mind-schema.org/schemas/sample/{name}.json
- Meta:      https://mind-schema.org/schemas/meta/{name}.json

Migration and compatibility
- Existing files under `schema/defs/*.def.json` and `schema/samples/*.sample.json` remain the source of truth.
- Non-breaking wrappers in `schema/primitives/*.primitive.json` and `schema/types/*.type.json` expose the new canonical $id while $ref’ing the existing defs. This keeps all $ref working both ways.
- Over time, definitions may be moved/renamed behind these wrappers without breaking external consumers.

Naming rules
- Files: snakeParts.suffix.json where suffix is one of: primitive.json, type.json, sample.json, meta.json
- Titles: camelCase short names: coordinate, vector3, quaternion, pose, velocity, transform.
- Keep units and coordinate frame semantics explicit in descriptions.

Vectorization (x-ai) guidance
- For primitives and types, include an optional `x-ai` object to guide ML usage:
  - dims: integer dimensionality (e.g., 3 for vector3, 4 for quaternion)
  - dtype: e.g., float32, float64, int32
  - order: flattening order using dot-paths (e.g., ["position.x", "position.y", ...])
  - unit/units: SI or semantic unit(s)
  - range: [min, max] if bounded; otherwise omit
  - quantization: optional hints (e.g., 16-bit fixed point) for storage/codec
  - embeddingHint: short string: "angle-axis", "unit-quaternion", "euclidean-position"
- These hints are advisory, not normative, and can be ignored by strict validators.

Binary/storage (x-storage) guidance
- Optionally include `x-storage` to inform codecs and binary layouts:
  - encoding: e.g., base64, raw, little-endian-f32
  - stride: bytes per element (if applicable)
  - layout: e.g., interleaved, planar
  - contentType: application/octet-stream, application/json
- Like `x-ai`, this is advisory metadata for tooling; schemas remain JSON-first.

Sample records and SQL alignment
- sample.def.json: defines the shape of a single time-series record (row-level contract).
- sample.json: a collection of records (arrays or NDJSON); useful for tests and fixtures.
- Required fields typically include: timestamp, streamId/session linkage, and payload of types/primitives.
- Collections of samples are JSON arrays or newline-delimited JSON for ingest.

Meta records
- Describe static experiment/session/device/software/topology details.
- Prefer stable identifiers (UUID/URI) and reference from samples via metadataRef.

Resolver guidance
- Use a schema resolver that maps canonical IDs to local files for offline validation (e.g., Ajv addSchema).
- Keep canonical $id stable; avoid changing once published.

Examples of new wrappers
- schema/primitives/vector3.primitive.json → $ref: ../defs/vector3.def.json (adds x-ai hints)
- schema/types/pose.type.json            → $ref: ../defs/pose.def.json (adds x-ai hints)
- schema/sample/joint.json               → $ref: ../samples/joint.sample.json (canonical sample ID)

Examples and naming
- Examples live under `examples/` and mirror the folder structure of `schema/`.
- Example filenames must be identical to the schema filename they exemplify, with `.example.json` appended.
  - Examples:
    - `schema/meta/device.meta.json` → `examples/meta/device.meta.example.json`
    - `schema/sample/hand.json` → `examples/sample/hand.example.json`
    - `schema/defs/event.def.json` → `examples/defs/event.def.example.json`
    - `schema/primitives/vector3.primitive.json` → `examples/primitives/vector3.primitive.example.json`
    - `schema/types/pose.type.json` → `examples/types/pose.type.example.json`
- For collections of samples, use `examples/samples/{name}.collection.json` or NDJSON files.

Notes on samples
- We treat `schema/samples/*.sample.json` as the existing record-level schema definitions.
- New canonical sample IDs live under `schema/sample/*.json` as thin wrappers referencing those existing schemas.
- Data collections (arrays or NDJSON of records) should live under `examples/samples/*.example.json` and must not carry a `$schema` of a single-record contract; instead, collections can be validated by `items: { $ref: <record schema> }` in helper scripts.
