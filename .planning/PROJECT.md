# Seed - RSVP Speed Reading Trainer

## What This Is

iOS app that trains users to read faster using RSVP (Rapid Serial Visual Presentation) method. Displays text word-by-word with visual anchoring in a distraction-free interface. Users save texts from multiple sources (paste, URL, PDF) to a persistent library and launch focused reading sessions with adjustable speeds.

## Core Value

Smooth, distraction-free RSVP playback that actually helps users read faster through focused, single-word presentation with visual anchoring.

## Current Milestone: v2.0 Focused Library

**Goal:** Complete UX redesign from analytics-heavy to focused library-based flow with simplified session experience and improved anchor visualization.

**Target features:**
- Saved Text Library with SwiftData persistence (title, word count, last read)
- Bottom Sheet Session Flow with 3 input modes (text/link/PDF), WPM selector
- New Anchor Visualization: vertical line aligned to anchor char (25-30% width) + colored anchor char only
- Simplified Session Screen: clean RSVP display with play/pause + progress slider only
- Completion Toast: simple "Session complete" message, return to library
- Code Reorganization: Screens/ and Components/ folder structure

**Removing from v1:**
- Onboarding flow (interactive demo)
- Tab navigation (Input/Reading/History tabs)
- Comprehension quiz feature
- History dashboard with WPM charts
- Session tracking and analytics
- @AppStorage session persistence

## Requirements

### Validated

- ✓ 60fps RSVP engine with smart anchoring (1-3 letters) and dynamic timing — v1.0
- ✓ Multi-source input: paste, URL article extraction, PDF text extraction — v1.0
- ✓ Interactive onboarding with live RSVP demo — v1.0 (removing in v2.0)
- ✓ Eye-friendly color palette and focus mode — v1.0
- ✓ Session tracking with completion stats (time, WPM, word count) — v1.0 (removing in v2.0)
- ✓ History dashboard with WPM trend charts — v1.0 (removing in v2.0)
- ✓ Optional comprehension quiz after reading — v1.0 (removing in v2.0)
- ✓ Apple HIG compliance with native iOS patterns — v1.0

### Active

- [ ] SwiftData persistence for saved texts (replace @AppStorage)
- [ ] Saved Text Library screen with empty/populated states
- [ ] Bottom sheet session setup flow
- [ ] 3 input modes: text paste, link extraction, PDF upload
- [ ] New anchor visualization: vertical line + colored anchor char
- [ ] Simplified session screen: RSVP display + play/pause + progress slider
- [ ] Completion toast notification
- [ ] Code reorganization: Screens/ and Components/ folders

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
- **Persistence**: SwiftData for saved texts — replace @AppStorage approach
- **Architecture**: Clean architecture with Screens/ and Components/ separation
- **Design**: Apple HIG compliance — native iOS patterns and conventions
- **Performance**: Smooth word display at configurable WPM — timing precision critical for RSVP
- **Anchor line**: 25-30% of character width — fixed visual reference point
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
*Last updated: 2026-01-19 after v2.0 milestone start*
