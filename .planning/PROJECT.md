# Seed - RSVP Speed Reading Trainer

## What This Is

iOS app that trains users to read faster using RSVP (Rapid Serial Visual Presentation) method. Displays text word-by-word with smart anchoring (bold first letters) in a distraction-free interface. Users import text from multiple sources (paste, URL, PDF) and train at adjustable speeds.

## Core Value

Smooth, distraction-free RSVP playback that actually helps users read faster through focused, single-word presentation with visual anchoring.

## Requirements

### Validated

(None yet — ship to validate)

### Active

- [ ] Interactive onboarding that demos RSVP vs normal reading
- [ ] Multiple text input sources: paste, URL/web import, PDF extraction
- [ ] RSVP engine with smart anchoring (1 letter for short words, 2-3 for longer)
- [ ] Playback controls: start/pause, restart, speed adjustment (WPM), progress indicator
- [ ] Default 300 WPM reading speed
- [ ] Completion stats: time taken, WPM, word count
- [ ] Eye-friendly color palette for reading comfort
- [ ] Clean, minimal UI following Apple HIG

### Out of Scope

- User accounts/login — keep it local, no sync complexity
- Reading history/saved sessions — focus on single-session experience first
- Themes/customization — standardize UX before adding personalization
- Social features — no sharing, leaderboards, or social comparison

## Context

**RSVP Method:**
- Rapid Serial Visual Presentation: displays text one word at a time in same screen position
- Eliminates eye movement (saccades) which slows traditional reading
- Visual anchoring (bolding first letters) helps brain lock onto each word faster
- Removes peripheral distractions that break reading flow

**Target Audience:**
- Shipping to App Store for public users
- Anyone wanting to improve reading speed and focus
- Primary use: reading articles, PDFs, web content faster

**Existing Code:**
- Swift project with ContentView.swift and seedApp.swift
- Will follow clean architecture pattern (data, domain, presentation)

## Constraints

- **Platform**: iOS (SwiftUI) — native, modern Apple development
- **Architecture**: Clean architecture (data, domain, presentation) — user has reference implementation
- **Design**: Apple HIG compliance — native iOS patterns and conventions
- **Performance**: Smooth word display at configurable WPM — timing precision critical for RSVP
- **Accessibility**: Eye-friendly colors — reading comfort over aesthetics

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| SwiftUI over UIKit | Modern declarative UI, better for rapid development | — Pending |
| Smart anchoring (1-3 letters) | Balance: enough to anchor, not distracting | — Pending |
| 300 WPM default | Comfortable starting point, not too slow or aggressive | — Pending |
| Interactive onboarding | Users need to experience RSVP to understand benefit | — Pending |
| Multiple input sources in v1 | Core value requires easy text import (paste, URL, PDF) | — Pending |
| Stats on completion | Provides feedback loop for improvement tracking | — Pending |
| No persistence in v1 | Simplifies scope, focus on core RSVP experience | — Pending |

---
*Last updated: 2026-01-18 after initialization*
