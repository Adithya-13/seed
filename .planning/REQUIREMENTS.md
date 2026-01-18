# Requirements: Seed - RSVP Speed Reading Trainer

**Defined:** 2026-01-18
**Core Value:** Smooth, distraction-free RSVP playback that actually helps users read faster through focused, single-word presentation with visual anchoring.

## v1 Requirements

Requirements for initial release. Each maps to roadmap phases.

### RSVP Core

- [ ] **RSVP-01**: User can view text displayed word-by-word at fixed screen position
- [ ] **RSVP-02**: User can see ORP focal point highlighting on current word
- [ ] **RSVP-03**: User can see smart anchoring (bold first 1-3 letters based on word length)
- [ ] **RSVP-04**: User can adjust reading speed (WPM) in real-time during playback
- [ ] **RSVP-05**: User can start/pause/resume playback with controls
- [ ] **RSVP-06**: User can seek to specific word position in text
- [ ] **RSVP-07**: User can see reading progress (current word / total words)
- [ ] **RSVP-08**: User experiences smooth playback timing (CADisplayLink precision)
- [ ] **RSVP-09**: User sees dynamic word duration (short words faster, long words slower)
- [ ] **RSVP-10**: User experiences auto-slow at punctuation marks (sentence boundaries)
- [ ] **RSVP-11**: User can enable focus mode (fullscreen, minimal UI distractions)

### Text Input

- [ ] **INPUT-01**: User can paste text from clipboard into reader
- [ ] **INPUT-02**: User can import article from URL (web article extraction)
- [ ] **INPUT-03**: User can import text from PDF file (text extraction)
- [ ] **INPUT-04**: User can select input source from multiple options

### UI/UX

- [ ] **UX-01**: User can adjust font size for comfortable reading
- [ ] **UX-02**: User can toggle between light and dark themes
- [ ] **UX-03**: User sees interactive onboarding that demos RSVP vs normal reading
- [ ] **UX-04**: User interface follows Apple Human Interface Guidelines (native iOS patterns)
- [ ] **UX-05**: User sees eye-friendly color palette during reading sessions

### Stats & Validation

- [ ] **STATS-01**: User sees completion stats after reading session (time taken, WPM, word count)
- [ ] **STATS-02**: User can view reading statistics dashboard (WPM over time, sessions tracked)
- [ ] **STATS-03**: User can take optional comprehension quiz after reading
- [ ] **STATS-04**: User sees session history with past reading performance

## v2 Requirements

Deferred to future release. Tracked but not in current roadmap.

### Advanced Input

- **INPUT-05**: User can import from read-it-later services (Pocket, Instapaper)
- **INPUT-06**: User can import advanced file formats (ePub, DOC, RTF)

### Advanced Features

- **RSVP-12**: User can switch to chunk reading mode (2-3 words at time)
- **RSVP-13**: User can export annotations/highlights from reading session
- **UX-06**: User sees eye strain prevention (auto-pause every 20 minutes, break reminders)

### Multi-Platform

- **PLATFORM-01**: User can sync reading history via iCloud across devices
- **PLATFORM-02**: User can use app on iPad with optimized layout
- **PLATFORM-03**: User can use app on Mac with native interface

## Out of Scope

Explicitly excluded. Documented to prevent scope creep.

| Feature | Reason |
|---------|--------|
| User accounts/login | PROJECT.md: Keep local, no sync complexity for v1 |
| Social features (sharing, leaderboards) | PROJECT.md: Avoid social comparison, focus on solo experience |
| Built-in content library/store | Content licensing complexity, storage bloat |
| Traditional scrolling reading mode | Dilutes RSVP core value, maintenance burden |
| TTS/audio narration | Conflicts with visual RSVP focus, separate use case |
| AI summarization | API costs, unreliable quality, scope creep |
| Gamification (badges, streaks) | Creates obligation vs enjoyment |
| Multiple reading modes beyond RSVP | Do one thing well, avoid feature bloat |

## Traceability

Which phases cover which requirements. Updated by create-roadmap.

| Requirement | Phase | Status |
|-------------|-------|--------|
| (Pending roadmap creation) | - | - |

**Coverage:**
- v1 requirements: 25 total
- Mapped to phases: 0 (pending roadmap)
- Unmapped: 25 ⚠️

---
*Requirements defined: 2026-01-18*
*Last updated: 2026-01-18 after initial definition*
