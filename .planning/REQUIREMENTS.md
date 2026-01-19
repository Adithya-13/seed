# Requirements: Seed v2.0

**Defined:** 2026-01-19
**Core Value:** Smooth, distraction-free RSVP playback with visual anchoring

## v2.0 Requirements

Complete UX redesign from analytics-heavy to focused library-based flow.

### Library & Persistence

- [ ] **LIB-01**: User can save texts to SwiftData library (content, title, word count, source type)
- [ ] **LIB-02**: User can view library list showing title, word count, source badge (text/pdf/link icon)
- [ ] **LIB-03**: User can delete saved texts (swipe to delete)
- [ ] **LIB-04**: User sees empty state with 3 input mode buttons when library empty
- [ ] **LIB-05**: User can search/filter library from bottom nav search tab

### Navigation

- [ ] **NAV-01**: User sees bottom navigation bar with 3 tabs (home, library, search)
- [ ] **NAV-02**: Library screen is default when texts saved
- [ ] **NAV-03**: Empty state screen shown when no texts saved

### Session Setup

- [ ] **SESS-01**: User taps input mode to open bottom sheet modal
- [ ] **SESS-02**: Bottom sheet shows "Start Session from [text/link/pdf]" header
- [ ] **SESS-03**: User can paste text in text input mode
- [ ] **SESS-04**: User can enter URL for link extraction in link mode
- [ ] **SESS-05**: User can upload PDF for text extraction in PDF mode
- [ ] **SESS-06**: User sees WPM selector with 5 preset speed buttons
- [ ] **SESS-07**: User can adjust WPM with +/- controls
- [ ] **SESS-08**: App remembers last used WPM as default
- [ ] **SESS-09**: User taps large "start" button to begin session

### RSVP Display

- [ ] **RSVP-01**: User sees vertical orange anchor line through character (25-30% width)
- [ ] **RSVP-02**: Anchor character displayed in orange color
- [ ] **RSVP-03**: Session header shows "{word count} word - {wpm} wpm" + X close button
- [ ] **RSVP-04**: User sees large circular play/pause button
- [ ] **RSVP-05**: User sees progress slider showing current word number (e.g., "130")
- [ ] **RSVP-06**: User can seek to any position via progress slider
- [ ] **RSVP-07**: v1 RSVP engine maintained (60fps CADisplayLink, dynamic timing, smart anchoring)

### Session Completion

- [ ] **COMP-01**: User sees "Session complete" toast on finish
- [ ] **COMP-02**: New texts auto-saved to library after first read
- [ ] **COMP-03**: User returns to library after completion

### Code Structure

- [ ] **CODE-01**: Codebase organized with Screens/ folder
- [ ] **CODE-02**: Codebase organized with Components/ folder
- [ ] **CODE-03**: Clean separation of concerns (views, models, services)

## v2.0 Removed (from v1)

Features explicitly removed in v2.0 redesign:

| Feature | Reason |
|---------|--------|
| Onboarding flow with interactive demo | Simplify first-run, focus on library |
| Tab navigation (Input/Reading/History) | Replaced by bottom nav + library-first |
| Comprehension quiz | Remove analytics/testing complexity |
| History dashboard with WPM charts | Remove analytics focus |
| Session tracking and stats | Remove analytics complexity |
| @AppStorage session persistence | Migrate to SwiftData |

## Out of Scope

| Feature | Reason |
|---------|--------|
| User accounts/login | Keep local, no sync complexity |
| Social features | No sharing, leaderboards |
| Built-in content library | Content licensing complexity |
| Traditional scrolling mode | Dilutes RSVP core value |
| TTS/audio narration | Conflicts with visual focus |
| AI summarization | API costs, unreliable |
| Gamification (badges, streaks) | Creates obligation vs enjoyment |
| Real-time WPM adjustment during session | Keep controls simple |
| Quick restart after completion | Defer to future iteration |

## Traceability

Which phases cover which requirements. Updated by create-roadmap.

| Requirement | Phase | Status |
|-------------|-------|--------|
| LIB-01 | TBD | Pending |
| LIB-02 | TBD | Pending |
| LIB-03 | TBD | Pending |
| LIB-04 | TBD | Pending |
| LIB-05 | TBD | Pending |
| NAV-01 | TBD | Pending |
| NAV-02 | TBD | Pending |
| NAV-03 | TBD | Pending |
| SESS-01 | TBD | Pending |
| SESS-02 | TBD | Pending |
| SESS-03 | TBD | Pending |
| SESS-04 | TBD | Pending |
| SESS-05 | TBD | Pending |
| SESS-06 | TBD | Pending |
| SESS-07 | TBD | Pending |
| SESS-08 | TBD | Pending |
| SESS-09 | TBD | Pending |
| RSVP-01 | TBD | Pending |
| RSVP-02 | TBD | Pending |
| RSVP-03 | TBD | Pending |
| RSVP-04 | TBD | Pending |
| RSVP-05 | TBD | Pending |
| RSVP-06 | TBD | Pending |
| RSVP-07 | TBD | Pending |
| COMP-01 | TBD | Pending |
| COMP-02 | TBD | Pending |
| COMP-03 | TBD | Pending |
| CODE-01 | TBD | Pending |
| CODE-02 | TBD | Pending |
| CODE-03 | TBD | Pending |

**Coverage:**
- v2.0 requirements: 27 total
- Mapped to phases: 0 (pending roadmap creation)
- Unmapped: 27 ⚠️

---
*Requirements defined: 2026-01-19*
*Last updated: 2026-01-19 after lofi mockup review*
