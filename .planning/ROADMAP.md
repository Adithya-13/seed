# Roadmap: Seed - RSVP Speed Reading Trainer

## Overview

v2.0 transforms Seed from analytics-heavy to focused library-based flow. Reorganize v1 code, build SwiftData library with bottom nav, redesign session setup (bottom sheet + 3 input modes), implement new anchor visualization (vertical line + colored char), and wire completion to auto-save texts. Result: streamlined UX that emphasizes saved content library over session tracking.

## Milestones

- ✅ **v1.0 MVP** - Phases 1-4 (shipped 2026-01-19)
- 🚧 **v2.0 Focused Library** - Phases 5-9 (in progress)

## Phases

<details>
<summary>✅ v1.0 MVP (Phases 1-4) - SHIPPED 2026-01-19</summary>

### Phase 1: Foundation
**Goal**: Project setup and RSVP engine foundation
**Status**: Complete (2026-01-19)

### Phase 2: Core RSVP
**Goal**: Complete RSVP playback with anchoring
**Status**: Complete (2026-01-19)

### Phase 3: Input Sources
**Goal**: Multi-source text input (paste, URL, PDF)
**Status**: Complete (2026-01-19)

### Phase 4: Polish
**Goal**: Onboarding, history, quiz, completion flow
**Status**: Complete (2026-01-19)

</details>

### 🚧 v2.0 Focused Library (In Progress)

**Milestone Goal:** UX redesign from analytics-heavy to library-first flow with simplified session experience

#### Phase 5: Code Reorganization
**Goal**: Clean up v1 structure for v2 work
**Depends on**: Nothing (refactor existing)
**Requirements**: CODE-01, CODE-02, CODE-03
**Success Criteria** (what must be TRUE):
  1. All screen files in Screens/ folder
  2. All reusable components in Components/ folder
  3. v1 code builds and runs after reorganization
**Research**: Unlikely (internal refactor)
**Status**: Complete (2026-01-19)

Plans:
- [x] 05-01: Code Reorganization

#### Phase 6: SwiftData Library
**Goal**: Persistent text library with SwiftData
**Depends on**: Phase 5
**Requirements**: LIB-01, LIB-02, LIB-03, LIB-04, LIB-05, NAV-01, NAV-02, NAV-03
**Success Criteria** (what must be TRUE):
  1. User can save text and see it in library list
  2. User sees title, word count, source badge per item
  3. User can delete saved texts (swipe)
  4. User sees empty state when library empty
  5. User can search/filter from bottom nav search tab
  6. Bottom nav shows home/library/search tabs
**Research**: Unlikely (SwiftData standard pattern)
**Plans**: TBD

Plans:
- [ ] 06-01: TBD
- [ ] 06-02: TBD

#### Phase 7: Bottom Sheet Session Flow
**Goal**: New session setup UX with 3 input modes
**Depends on**: Phase 6
**Requirements**: SESS-01, SESS-02, SESS-03, SESS-04, SESS-05, SESS-06, SESS-07, SESS-08, SESS-09
**Success Criteria** (what must be TRUE):
  1. User taps input mode → bottom sheet opens
  2. User can paste text, enter URL, upload PDF in respective modes
  3. User sees WPM selector with presets + +/- controls
  4. App remembers last WPM as default
  5. User taps start → session begins
**Research**: Unlikely (SwiftUI bottom sheet standard)
**Plans**: TBD

Plans:
- [ ] 07-01: TBD
- [ ] 07-02: TBD

#### Phase 8: New Anchor Visualization
**Goal**: Vertical line + colored anchor char display
**Depends on**: Phase 7
**Requirements**: RSVP-01, RSVP-02, RSVP-03, RSVP-04, RSVP-05, RSVP-06, RSVP-07
**Success Criteria** (what must be TRUE):
  1. Orange vertical line appears through anchor char (25-30% width)
  2. Anchor char displayed in orange color
  3. Session header shows word count, WPM, X close
  4. Large circular play/pause button works
  5. Progress slider shows current word number
  6. User can seek via progress slider
  7. v1 RSVP engine (60fps, dynamic timing, smart anchoring) maintained
**Research**: Unlikely (SwiftUI Path + maintain v1 engine)
**Plans**: TBD

Plans:
- [ ] 08-01: TBD

#### Phase 9: Completion Flow
**Goal**: Session completion + library integration
**Depends on**: Phase 8
**Requirements**: COMP-01, COMP-02, COMP-03
**Success Criteria** (what must be TRUE):
  1. "Session complete" toast appears on finish
  2. New texts auto-saved to library after first read
  3. User returns to library after completion
**Research**: Unlikely (wire existing pieces)
**Plans**: TBD

Plans:
- [ ] 09-01: TBD

## Progress

**Execution Order:** 5 → 6 → 7 → 8 → 9

| Phase | Milestone | Plans Complete | Status | Completed |
|-------|-----------|----------------|--------|-----------|
| 1. Foundation | v1.0 | 3/3 | Complete | 2026-01-19 |
| 2. Core RSVP | v1.0 | 3/3 | Complete | 2026-01-19 |
| 3. Input Sources | v1.0 | 3/3 | Complete | 2026-01-19 |
| 4. Polish | v1.0 | 2/2 | Complete | 2026-01-19 |
| 5. Code Reorganization | v2.0 | 1/1 | Complete | 2026-01-19 |
| 6. SwiftData Library | v2.0 | 0/2 | Not started | - |
| 7. Bottom Sheet Session | v2.0 | 0/2 | Not started | - |
| 8. Anchor Visualization | v2.0 | 0/1 | Not started | - |
| 9. Completion Flow | v2.0 | 0/1 | Not started | - |
