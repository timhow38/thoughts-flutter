# Idea Sharing + Real-Time Group Rooms

## 1. Core Features

### Idea Types Users Can Save

- **Text snippets**
- **Links / URLs**
- **Pictures**  
  (Images are hosted externally; only the URLs are saved and shared)

### Local Storage

- Each user's ideas are stored locally on their device (using IndexedDB or similar).
- **Access ideas offline** – no reliance on an online connection for viewing saved ideas.
- **No persistent backend storage** – user ideas are never stored on a server long-term.

### Rooms / Groups

- Users can create “rooms” (aka groups) to share ideas with friends **in real time**.
- Room creation generates a **unique code or URL** (Jackbox.tv-style) for joining.
    - Optional: Rooms may have a **password** for privacy.
- Users join a room by entering the code or using the URL.

### Real-Time Sync

- While in a room, ideas are synchronized **live** across all connected users’ devices.
- A **real-time backend** (e.g., SpacetimeDB or alternative) handles only transient message
  relaying.
    - The backend DOES NOT store user ideas permanently.
    - All ideas remain saved locally for each user.

### Room Lifetime & Archiving

- **Rooms expire/archive after 2 months** of inactivity.
- Upon expiry, the backend deletes all room data; **users keep their local copies** of ideas.
- Only actively used rooms consume backend resources.

---

## 2. Design Goals

- **Privacy-friendly:** Backend stores minimal/no personal data.
- **Cost-efficient:** Backend used only for brief real-time connections.
- **Easy sharing:** Friends can easily join via room codes or links.
- **Offline-first:** Core idea storage and viewing are always available, even without connection.
- **Scalable:** Architecture can support 10,000+ users/month, with efficient backend utilization.

---

## 3. Technology Considerations

- **Realtime Backend:**
    - Primary: [SpacetimeDB](https://spacetimedb.io/) (CRDT-based, offline conflict resolution)
    - Alternatives: Socket.io, Ably, Liveblocks, or similar
- **Local Storage:**  
  Browser IndexedDB, or native app storage (depending on platform)
- **Media Hosting:**  
  Images/large files must be on an external CDN or file store (only URLs are exchanged)

---

## 4. User Flow Example

1. **User opens the app:**  
   Saves and edits ideas, which persist locally.
2. **User creates a new room:**  
   Receives a room code (or URL) + optional password.
3. **User shares room code:**  
   Friends use code to join the room.
4. **Live Sync:**  
   Edits/ideas broadcast instantly to all room participants via the real-time backend.
5. **Session ends:**  
   Each user’s ideas remain in their local app data.
6. **Room expiry:**  
   After 2 months of inactivity, the backend removes the room. Local copies remain.

---

## 5. Cost & Scalability Outlook

- Real-time backend is used **only** for live sessions (no long-term data storage).
- Your TeV balance (~3M) enables ~3,000 active sessions (at ~1,000 TeVs/session).
- Supporting 10K+ users/month is feasible with regular monitoring and possible scaling of backend
  resources.
- **Local storage** and **external CDN media** ensure backend communications stay lightweight and
  scalable.

---

**Core philosophy:**  
_Local-first idea storage, real-time group sharing, privacy-by-design, and affordable scaling for
creative collaboration._
