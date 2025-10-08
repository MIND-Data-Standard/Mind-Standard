# 🧠 MIND Standard – Session Context
**Version:** 2025-10  
**Date:** 2025-10-05  
**Scope:** Schema architecture, design rationale, and next-step roadmap from refactor session  
**Authoring context:** ChatGPT (MIND Architect) collaborative schema session

---

## 🗂️ Overview
This document summarises the **current state and architecture** of the MIND Standard schema repository following a major structural refactor that separated static metadata, reusable type definitions, and dynamic sample data.

It serves as both:
- **Developer documentation** (for contributors extending the standard)
- **Persistent GPT context** (to allow resumption of design sessions)

---

## 📁 Folder Structure

### `/def/` – Reusable Definitions
| File | Purpose |
|------|----------|
| `timestamp.def.json` | Defines timestamps with microsecond and frame index fields |
| `vector3.def.json` | Standard 3D vector for position, direction, or velocity |
| `quaternion.def.json` | 4D quaternion rotation |
| `coordinate.def.json` | Single floating-point coordinate |
| `pose.def.json` | Composite of position + rotation |
| `metadataRef.def.json` | Reusable link type for connecting samples to metadata objects (UUID, URI, or JSON Pointer) |

---

### `/meta/` – Static Metadata
| File | Purpose |
|------|----------|
| `joint.meta.json` | Static joint metadata — region, side, aliases, cross-standard names |
| `bone.meta.json` | Static bone metadata — connects two joints with direction, length, and orientation |
| `skeleton.meta.json` | Full skeleton definition linking joints, bones, and chains |
| `hand.meta.json` | Metadata for tracked hands, including tracking system, vendor, and joint definitions |

---

### `/samples/` – Time-Series Data
| File | Purpose |
|------|----------|
| `trackedObject.sample.json` | Base for all tracked object samples |
| `joint.sample.json` | Per-frame joint pose data referencing `joint.meta.json` |
| `bone.sample.json` | Per-frame bone data referencing `bone.meta.json` |
| `hand.sample.json` | Full hand snapshot combining multiple joint and bone samples |

---

### `/enums/` – Enumerations
| File | Purpose |
|------|----------|
| `body.region.enum.json` | Defines major body regions |
| `body.side.enum.json` | Defines anatomical sides |
| `body.role.enum.json` | Defines functional joint/bone roles |
| `hand.bone.enum.json` | Lists bones within the hand |
| `hand.finger.enum.json` | Lists fingers |
| `hand.joint.enum.json` | Canonical hand joint names aligned with OpenXR |

---

### `/maps/` – Structural Mappings
| File | Purpose |
|------|----------|
| `hand.joint.map.json` | Canonical 26-joint hand definition with aliases for OpenXR, UnityXRHands, WebXR, LeapMotion |
| `hand.skeleton.map.json` | Defines hand skeleton graph (joints, chains, adjacency) |

---

## 🔗 Dependency Graph

| File | Depends On |
|------|-------------|
| `trackedObject.sample.json` | `timestamp.def.json`, `pose.def.json`, `vector3.def.json` |
| `joint.sample.json` | `trackedObject.sample.json`, `metadataRef.def.json` |
| `bone.sample.json` | `trackedObject.sample.json`, `metadataRef.def.json`, `bone.meta.json` |
| `hand.sample.json` | `joint.sample.json`, `bone.sample.json`, `metadataRef.def.json`, `hand.meta.json` |
| `bone.meta.json` | `joint.meta.json`, `vector3.def.json`, `quaternion.def.json` |
| `skeleton.meta.json` | `joint.meta.json`, `bone.meta.json`, `chain.def.json` |
| `hand.meta.json` | `joint.meta.json`, `hand.joint.enum.json` |
| `joint.meta.json` | `body.region.enum.json`, `body.side.enum.json`, `body.role.enum.json` |

---

## ⚙️ Design Principles

### 1. **Meta vs Def vs Sample**
- **Meta** = Static, time-invariant entities (e.g., bone structure, tracking source)
- **Def** = Reusable type building blocks
- **Sample** = Dynamic, per-frame data

### 2. **RestPose Refactor**
- Removed `restPose.def.json`
- Moved positional and directional fields directly into `bone.meta.json` and `joint.meta.json`

### 3. **Metadata Referencing**
- Introduced `metadataRef.def.json` for linking samples → metadata via:
    - UUID
    - URI / file path
    - JSON Pointer (within the same file)

### 4. **Pose Composition**
- All positional and rotational data derive from shared defs:
    - `vector3.def.json`
    - `quaternion.def.json`

### 5. **Hand Alignment**
- Fully aligned with **OpenXR XR_EXT_hand_tracking**
- Includes alias fields for UnityXRHands, WebXR, and LeapMotion

### 6. **Schema Modularity**
- Small composable components enable automated code generation and schema validation

### 7. **Body vs Hand Split**
- Maintained separate namespaces for hand and body tracking to match device capabilities and industry standards

### 8. **Sample ↔ Meta Linkage**
- Every sample references static metadata rather than duplicating structural or anatomical data

---

## 🧩 Integration Notes

### Language Bindings
| Language | Standard |
|-----------|-----------|
| **C#** | `.NET Standard 2.1` using `[StructLayout(LayoutKind.Sequential)]` |
| **Python** | `dataclasses` / `pydantic` following PEP-8 naming conventions |

### Interoperability Targets
- **XR standards:** OpenXR, UnityXRHands, WebXR, LeapMotion
- **Neuroscience data:** BIDS, NWB, OpenMINDS
- **Goal:** Provide a unified, cross-domain schema for behavioural and XR data fusion.

---

## 🧭 Next Steps

1. Consider conditional timestamp omission in nested samples (e.g., within hand samples).
2. Validate that `hand.skeleton.map.json` joint references align with `hand.joint.map.json`.
3. Extend `skeleton.meta.json` for full-body topology.
4. Add `face.meta.json` and associated enumerations.
5. Define `dataset.meta.json` for experiment/session metadata.
6. Generate language bindings automatically from JSON Schema defs.
7. Validate metadataRef resolution (UUID, URI, JSON Pointer).

---

## 🧾 Summary

| Category | Status |
|-----------|---------|
| Schema modularisation | ✅ Completed |
| Metadata referencing | ✅ Implemented |
| Hand alignment with OpenXR | ✅ Complete |
| Body/hand schema separation | ✅ Complete |
| RestPose simplification | ✅ Complete |
| Validation roadmap | 🚧 Pending |
| Documentation and SDK bindings | 🚧 Next milestone |

---

📘 **Usage:**  
Include this file as `/docs/mind.session.context.md` or `/mind.session.context.md` in the root.  
It provides GPT and human developers with all schema context to resume structured schema design seamlessly.
