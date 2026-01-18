# Roadmap: Seed - RSVP Speed Reading Trainer

## Overview

Four-phase journey from core RSVP engine to feature-complete App Store release. Phase 1 establishes smooth timing and display (critical foundation). Phase 2 adds input variety (URL/PDF). Phase 3 polishes UX and ensures App Store compliance. Phase 4 adds retention features (stats, comprehension tracking).

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3, 4): Planned milestone work
- Decimal phases (X.1, X.2): Urgent insertions (marked with INSERTED)

- [ ] **Phase 1: Foundation + RSVP Engine** - Core timing, display engine, smart anchoring
- [ ] **Phase 2: Text Input Sources** - URL and PDF import
- [ ] **Phase 3: UX Polish + Accessibility** - Settings, themes, onboarding, HIG compliance
- [ ] **Phase 4: Stats + Comprehension** - Performance tracking, comprehension validation

## Phase Details

### Phase 1: Foundation + RSVP Engine
**Goal**: Smooth RSVP playback with smart anchoring and basic controls
**Depends on**: Nothing (first phase)
**Requirements**: RSVP-01, RSVP-02, RSVP-03, RSVP-04, RSVP-05, RSVP-06, RSVP-07, RSVP-08, RSVP-09, RSVP-10, INPUT-01
**Success Criteria** (what must be TRUE):
  1. User can paste text and see it displayed word-by-word with smart anchoring (bold first letters)
  2. User can control playback (play/pause/seek) and adjust WPM in real-time
  3. Playback is smooth with dynamic word timing and automatic slowdown at punctuation
  4. User sees reading progress indicator (current word / total words)
**Research**: Unlikely (CADisplayLink, NLTokenizer verified in research SUMMARY.md)
**Plans**: TBD

Plans:
- [ ] TBD (to be defined during planning)

### Phase 2: Text Input Sources
**Goal**: Multiple text import methods (paste, URL, PDF)
**Depends on**: Phase 1
**Requirements**: INPUT-02, INPUT-03, INPUT-04
**Success Criteria** (what must be TRUE):
  1. User can import article from URL with clean text extraction (no nav/ads)
  2. User can import PDF file with text extraction working correctly
  3. User can choose between paste/URL/PDF input methods from UI
**Research**: Likely (URL article extraction algorithms)
**Research topics**: Mozilla Readability port for iOS, web article parsing strategies, URLSession async patterns
**Plans**: TBD

Plans:
- [ ] TBD (to be defined during planning)

### Phase 3: UX Polish + Accessibility
**Goal**: App Store ready with polished UX and accessibility compliance
**Depends on**: Phase 1
**Requirements**: UX-01, UX-02, UX-03, UX-04, UX-05, RSVP-11
**Success Criteria** (what must be TRUE):
  1. User can adjust font size (Dynamic Type support) and toggle light/dark theme
  2. New users see interactive onboarding that demonstrates RSVP vs normal reading
  3. App follows Apple HIG with eye-friendly color palette and native iOS patterns
  4. User can enable focus mode for fullscreen, distraction-free reading
**Research**: Unlikely (Dynamic Type, VoiceOver patterns standard in Apple HIG)
**Plans**: TBD

Plans:
- [ ] TBD (to be defined during planning)

### Phase 4: Stats + Comprehension
**Goal**: Progress tracking and comprehension validation for retention
**Depends on**: Phase 1
**Requirements**: STATS-01, STATS-02, STATS-03, STATS-04
**Success Criteria** (what must be TRUE):
  1. User sees completion stats after each reading session (time, WPM, word count)
  2. User can view reading history dashboard with performance over time
  3. User can optionally take comprehension quiz after reading to validate retention
**Research**: Likely (comprehension quiz implementation, question generation)
**Research topics**: Key concept extraction from text, quiz UX patterns, academic RSVP comprehension studies
**Plans**: TBD

Plans:
- [ ] TBD (to be defined during planning)

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 2 → 3 → 4

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Foundation + RSVP Engine | 0/TBD | Not started | - |
| 2. Text Input Sources | 0/TBD | Not started | - |
| 3. UX Polish + Accessibility | 0/TBD | Not started | - |
| 4. Stats + Comprehension | 0/TBD | Not started | - |
