# Seed - RSVP Speed Reading Trainer

## What This Is

iOS app that trains users to read faster using RSVP (Rapid Serial Visual Presentation) method. Displays text word-by-word with smart anchoring (bold first letters) in a distraction-free interface. Users import text from multiple sources (paste, URL, PDF) and train at adjustable speeds with session tracking and progress analytics.

## Core Value

Smooth, distraction-free RSVP playback that actually helps users read faster through focused, single-word presentation with visual anchoring.

## Requirements

### Validated

- ✓ 60fps RSVP engine with smart anchoring (1-3 letters) and dynamic timing — v1.0
- ✓ Multi-source input: paste, URL article extraction, PDF text extraction — v1.0
- ✓ Interactive onboarding with live RSVP demo — v1.0
- ✓ Eye-friendly color palette and focus mode — v1.0
- ✓ Session tracking with completion stats (time, WPM, word count) — v1.0
- ✓ History dashboard with WPM trend charts — v1.0
- ✓ Optional comprehension quiz after reading — v1.0
- ✓ Apple HIG compliance with native iOS patterns — v1.0

### Active

(None - define requirements for next milestone via `/gsd:define-requirements`)

### Out of Scope

- User accounts/login — keep it local, no sync complexity
- Social features — no sharing, leaderboards, or social comparison
- Built-in content library/store — content licensing complexity
- Traditional scrolling reading mode — dilutes RSVP core value
- TTS/audio narration — conflicts with visual RSVP focus
- AI summarization — API costs, unreliable quality
- Gamification (badges, streaks) — creates obligation vs enjoyment

## Context

**Shipped v1.0 (2026-01-19):**
- 2,167 lines of Swift
- 4 phases, 11 plans, 43 tasks
- Tech stack: SwiftUI, CADisplayLink, NLTokenizer, PDFKit, @Observable pattern
- All 24 v1 requirements delivered

**RSVP Method:**
- Rapid Serial Visual Presentation: displays text one word at a time in same screen position
- Eliminates eye movement (saccades) which slows traditional reading
- Visual anchoring (bolding first letters) helps brain lock onto each word faster
- Removes peripheral distractions that break reading flow

**Target Audience:**
- App Store public release
- Anyone wanting to improve reading speed and focus
- Primary use: reading articles, PDFs, web content faster

## Constraints

- **Platform**: iOS (SwiftUI) — native, modern Apple development
- **Architecture**: Clean architecture (data, domain, presentation)
- **Design**: Apple HIG compliance — native iOS patterns and conventions
- **Performance**: Smooth word display at configurable WPM — timing precision critical for RSVP
- **Accessibility**: Eye-friendly colors — reading comfort over aesthetics

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| SwiftUI over UIKit | Modern declarative UI, better for rapid development | ✓ Good |
| @Observable macro for state | Simpler syntax, modern SwiftUI pattern | ✓ Good |
| CADisplayLink for timing | 60fps precision vs Timer | ✓ Good |
| Smart anchoring (1-3 letters) | Balance: enough to anchor, not distracting | ✓ Good |
| Dynamic timing formula | +50% for 8+ chars, +100% for punctuation | ✓ Good |
| AttributedString for anchoring | Bold font weight for anchor letters | ✓ Good |
| Custom HTML stripping | ReadabilityKit archived, regex-based approach | ✓ Good |
| @AppStorage JSON for sessions | Max 50 sessions, prevents UserDefaults bloat | ✓ Good |
| SwiftUI Path for charts | No external library, simple WPM trend | ✓ Good |
| Hardcoded quiz questions | Auto-generation deferred to v2 (requires LLM) | ✓ Good |
| No persistence in v1 | Local @AppStorage only, no iCloud | ✓ Good |
| Interactive onboarding | Users need to experience RSVP to understand benefit | ✓ Good |
| TabView navigation | Input, Reading, History tabs for clean UX | ✓ Good |

---
*Last updated: 2026-01-19 after v1.0 milestone*
