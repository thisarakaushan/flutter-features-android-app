# Offline Feature App

## 1. Offline-First Architecture

#### Why offline-first apps?
Apps often lose internet connectivity, but they should still function. Offline-first ensures usability without an active connection.
- Local-first data model: The source of truth is on-device (SQLite/Isar/Hive/Realm/etc.). Network just syncs.
- Operation queue: All writes become small, durable “ops” (create/update/delete). When online, a worker replays them.
- Deterministic conflict handling: You must choose a single strategy per entity type (e.g., last-write-wins by field, vector clocks, or CRDT for collaborative text).
- Progressive media: Files (images/audio/video/PDF) are downloaded in chunks with resume support and stored locally; metadata is indexed locally.
- Explicit UX: Offline banner, stale/last-synced timestamps, “queued” status for edits, and per-item retry.

### Core Principle

#### Start in the Data Layer
- Offline-first repository requires two data sources:
    1. Local Data Source (eg. SQL DB)
    2. Network Data Source

- Repository syncs local data with network data.
- Use separate models for local and network data, and expose a common domain model to the app.

#### Reading Data (Offline-first)
- Use observable APIs so, UI updates as data changes.
- External layers should always read from local data source for consistency.

#### Writing Data (Offline-first)
- Use asynchronous APIs (e.g., suspend functions in Kotlin) to avoid blocking UI.
- Writing pattern:
    1. Write locally first (if business logic allows).
    2. Queue write for the network.
    3. Wait for connectivity → perform network write.
    4. Handle conflicts (e.g., last-write-wins).

- Retrying failed operations:
    - Retry if valid, else discard.
    - Persist successful results.

#### Synchronization
1. Pull-based sync: Fetch data when screens are visited.
- Pros: Simple, no unnecessary data fetch.
- Cons: Heavy data use on screen revisit, poor for relational data.

2. Push-based sync: Local DB mirrors network DB; uses server notifications.
- Pros: Great for long offline periods, minimal data usage after initial sync.
- Cons: Complex (versioning, conflicts, concurrency), requires backend support.


#### Conflict Resolution
- Common approach: ```Last Write Wins (LWW)```.
- Example scenario:
    - Device A and B offline → both make changes → sync later → last sync overwrites previous changes.

### Auth & Security Offline
- The app can read local data when offline if the user was signed in before.
- Protect local data at rest (OS keychain + DB/file encryption).
- Rules are server-side only; client must not assume authorization without a successful sync.

## Firestore/Realtime Database

### What works offline
- Built-in cache & write queue: You can read recently queried docs/collections offline; writes queue until online.
- Basic conflict handling: Server resolves with last-write-wins at document field level (effectively), but no custom conflict hooks on-device.
- Decent for read-mostly apps where users browse previously loaded content and make simple edits.

### Where Firebase is limiting
- No real local-first schema control: You don’t design a full local DB and sync protocol; you get a cache of what you’ve fetched.
- Query limitations offline: Complex queries work only if all needed docs are already in cache; otherwise results are incomplete.
- Security rules aren’t local: Rules run on server; offline reads are from cache without re-checking rules. You must design UI to avoid exposing data the user shouldn’t see if they later lose access.
- Auth tokens & first sign-in: First login requires network. Token refresh requires periodic connectivity; long offline periods can cause edge cases.
- Server timestamps/Functions: ```FieldValue.serverTimestamp()``` is resolved only after sync. Any server-generated fields and Cloud Functions don’t run offline.
- Presence, counters, fan-out writes: Anything relying on real-time presence or server fan-out won’t behave offline.
- Storage (files) isn’t cached automatically: Firebase Storage needs explicit download + local save; resumable downloads must be implemented (SDK helps, but you manage local file lifecycle).

Conclusion: Great for “good-enough” offline reads and queuing simple writes, but not a full offline-first platform when you need reliable complex queries, custom conflict logic, guaranteed media management, or a real local source of truth.

## Viable Architecture patterns

### 1. Firebase-centric with enhancements (Partial offline)
When to choose: Read-heavy app, modest offline editing
- Keep Firestore as backend.
- Turn on persistence; design screens to never rely on uncached queries offline.
- Add local indexes for critical lists (e.g., pin essential collections locally on first run).
- Implement a local media store (download, resume, LRU eviction).

Pros: Simple, minimal backend work, quick.
Cons: Still “partial” offline, complex queries offline are fragile, conflict policies limited.

### 2. Local-first DB + Custom Sync to Firebase (or Supabase/Hasura)
When to choose: You need true offline-first with reliable queries, complex views, and explicit conflict rules.
- Use Isar/Drift/Realm locally as source of truth.
- Build a sync service:
    - Pull: /sync?since=ts endpoints (or Cloud Functions/HTTPS) returning changed entities + tombstones.
    - Push: batched ops with client op ids, idempotency, and server reconciliation.
- Define conflict policy per model; record version/updatedAt per field or entity.
- Keep Firebase Storage only for blobs; store signed URLs or storage paths in your local DB.

If you want reliable, end-to-end offline (including lists, search, and media) and to avoid Firebase’s partial behavior, choose:
    - Option 2: Local-first DB (Isar or Drift) + Custom Sync to Firestore/Functions + Explicit Media Manager.


## Best Approach for LMS with Firebase Backend

### Firebase + Local Database + Custom Sync → ✅ Best Choice

#### Why?
- You keep Firebase for backend (Auth, Firestore, Storage).
- You add a local database (Isar, Drift, or Hive in Flutter) as the single source of truth for:
    - Modules (text, PDFs)
    - Quiz questions
    - Assignments
    - User progress
- Videos & PDFs downloaded locally with a media manager (resumable downloads, eviction rules, “Manage Downloads” UI).
- Implement offline-first sync engine:
    - Reads always from local DB → updates when network is available.
    - Writes (quiz answers, notes, assignment submissions) go into op-queue → sync later.
- Handle conflicts with last-write-wins or field-level merge.

#### Here’s the recommended stack:
1. Authentication
- Firebase Auth
- Cache user session locally (Keychain/Keystore).

2. Data
- Firestore = backend database.
- Local DB = Isar or Drift for offline cache + source of truth.
- Sync engine:
    - Pull-based: On navigation (when opening a module).
    - Push-based: Initial full sync + server notifications (optional).
    - Sync runs in background (WorkManager / BGTaskScheduler).

3. Media
- Videos stored in Firebase Storage.
- Download manager:
    - Chunked, resumable downloads.
    - Indexed in local DB with state (downloading, completed).
    - LRU eviction policy.

4. Quiz & Assignment
- Store questions and submissions locally.
- Submissions queued in op-queue.
- Retry on network availability.

5. Chatbot
- Cache previous messages.
- Queue user messages when offline → send later.
- Show fallback text if AI cannot respond offline.

### 1. Firebase built-in offline → ❌ Not Enough

#### Why?
- Firestore cache works for simple text data but not for large media (videos, PDFs).
- Quizzes/assignments require guaranteed sync and conflict handling.
- Cannot manage downloaded media efficiently (no LRU eviction or resumable downloads).
- Complex queries (e.g., “modules by category”, “completed progress”) won’t fully work offline.