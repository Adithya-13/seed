# Project Research Summary

**Project:** Seed - RSVP Speed Reading Trainer
**Domain:** iOS speed reading app (RSVP method)
**Researched:** 2026-01-18
**Confidence:** MEDIUM-HIGH

## Executive Summary

iOS speed reading apps are well-established in 2025, with clear technical patterns and known pitfalls. Research reveals **zero external dependencies needed** — native iOS frameworks (SwiftUI, PDFKit, URLSession) provide all required functionality. The critical technical finding: **CADisplayLink timing is non-negotiable** for smooth RSVP playback; Timer-based implementations fail at the core value prop (smooth, distraction-free display).

Feature landscape shows RSVP word display + adjustable WPM + playback controls are table stakes. **Smart anchoring (bold first letters) is a genuine differentiator** — most competitors use red ORP highlighting only. However, research surfaces a critical risk: **RSVP impairs comprehension at high speeds** (600+ WPM = 20% comprehension). Addressing this defensively (default 300 WPM, comprehension checks, honest onboarding) separates quality implementations from "speed reading theater."

Key mitigation: Build for **comprehension over vanity metrics**, implement **precise timing from day one** (CADisplayLink + dynamic word duration), and **prevent eye strain** (20-minute auto-pause). Architecture follows standard Clean Architecture + MVVM with @Observable (iOS 17+). Phase structure clear: Foundation → RSVP Engine → Input Sources → Polish.

## Key Findings

### Recommended Stack

Native iOS development requires zero external dependencies for v1. Swift 6.2 + SwiftUI (@Observable) + iOS 17+ deployment target enables clean concurrency model and eliminates ObservableObject boilerplate. Critical for RSVP: `Task.sleep(nanoseconds:)` provides sub-millisecond timing precision, CADisplayLink syncs with display refresh (60/120Hz ProMotion), NLTokenizer handles multi-language word parsing correctly.

**Core technologies:**
- **Swift 6.2**: Strict concurrency, async/await native, approved for modern iOS (2025 App Store requirement)
- **SwiftUI (iOS 17+)**: @Observable macro simplifies state management, declarative UI, precise Duration type for timing
- **CADisplayLink**: Display-synchronized timing (eliminates Timer's ±16ms drift), essential for smooth RSVP playback
- **PDFKit (native)**: Built-in text extraction, zero dependencies, handles PDF parsing without third-party libs
- **NLTokenizer**: Language-aware word tokenization (handles contractions, multi-language correctly)

**Avoid:**
- Combine framework (replaced by @Observable iOS 17+)
- Third-party PDF libraries (PDFKit sufficient)
- Timer/DispatchSourceTimer for RSVP (precision too low, causes stuttering)
- CocoaPods/Carthage (SPM is 2025 standard)

### Expected Features

**Must have (table stakes):**
- RSVP word-by-word display with ORP/focal point — core mechanic users expect
- Adjustable WPM speed (100-1000+ range) — user control essential
- Play/pause/seek controls — standard playback expectations
- Font size + light/dark theme — iOS accessibility baseline
- Progress indicator — users need orientation ("234 / 1,450 words")
- Paste text input — simplest content source, must work from day one

**Should have (competitive):**
- Smart anchoring (bold first letters) — **differentiator** vs red ORP highlighting, aligns with PROJECT.md
- URL/web article import — major convenience, add after paste proven
- PDF import — mentioned in PROJECT.md requirements
- Smart speed adjustment — auto-slow at punctuation/long words improves comprehension
- Comprehension checks — addresses RSVP's main criticism (comprehension degradation)
- Reading statistics — progress motivation, WPM tracking over time

**Defer (v2+):**
- Advanced file formats (ePub, DOC, RTF) — add when demand proven
- Reading history/saved sessions — PROJECT.md explicitly defers persistence for v1
- Social features — PROJECT.md out of scope
- Integration with read-it-later services (Pocket, Instapaper) — complexity, defer

### Architecture Approach

Clean Architecture (3-layer: Presentation/Domain/Data) + MVVM is 2025 iOS standard. Single AppState (@Observable) holds session/settings/stats as source of truth. ViewModels coordinate UseCases, which operate on AppState. Repositories abstract data I/O (text sources, settings persistence).

**Major components:**
1. **RSVP Display Engine** — CADisplayLink for frame-sync timing, dynamic word duration (short words 0.8x, long words 1.5x, punctuation +3x pause)
2. **Text Parser** — NLTokenizer handles contractions ("don't" = 1 word), multi-language, smart tokenization for URLs/abbreviations
3. **Input Sources** — TextRepository coordinates WebFetcher (URLSession), PDFExtractor (PDFKit), PasteInput (clipboard)
4. **Playback Controller** — State machine for start/pause/seek, coordinates timer lifecycle
5. **Settings & Stats** — UserDefaults for preferences, SwiftData for session history (if adding persistence later)

**Critical pattern:** CADisplayLink wrapper in Data layer, RSVPDisplayUseCase in Domain layer calculates word index from frame count. Views observe AppState changes (SwiftUI auto-updates). No business logic in ViewModels (coordinate only).

### Critical Pitfalls

1. **Timer instead of CADisplayLink** — Timer drifts ±16ms, causes stuttering at 300 WPM. CADisplayLink syncs with display refresh (60/120Hz), guarantees smooth playback. **Prevention:** Use CADisplayLink from Phase 1, not Timer.

2. **Constant word duration** — Showing all words for same duration tanks comprehension. Short words feel slow, long words flash by. **Prevention:** Dynamic duration (0.8x-1.5x base) + punctuation pauses (3x after period).

3. **Wrong ORP alignment** — Bolding first letter for all words causes eye refixation fatigue. ORP varies: 2nd letter for short words, near-middle for long words. **Prevention:** Evidence-based ORP calculation by word length.

4. **No eye strain prevention** — 10-20 minutes continuous RSVP causes headaches, blurred vision. Fixed focal point worse than normal reading. **Prevention:** Auto-pause every 20 minutes, 20-20-20 rule reminder, session duration timer.

5. **Missing accessibility** — App Store rejects for no Dynamic Type support (required iOS feature). VoiceOver reads rapid word changes as gibberish. **Prevention:** UIFontMetrics for scalable fonts, test at 200% text size, VoiceOver labels for controls.

6. **Naive tokenization** — `text.split(" ")` breaks contractions ("don't" → 2 words), URLs (gibberish), hyphenated compounds. **Prevention:** NLTokenizer for smart parsing, test with real web/PDF content.

7. **Comprehension ignored** — Users "read" 600+ WPM with 20% comprehension, quit when realizing they retain nothing. **Prevention:** Default 300 WPM, cap at 500 WPM with warning, comprehension quiz optional, honest onboarding.

8. **Background mode conflicts** — Visual RSVP doesn't work in background (requires viewing screen). Adding audio modes conflicts with user's music. **Prevention:** No background modes for visual-only RSVP.

## Implications for Roadmap

Based on research, suggested phase structure:

### Phase 1: Foundation + RSVP Engine
**Rationale:** Core timing architecture must be correct from start. CADisplayLink, dynamic word duration, ORP alignment are non-negotiable foundation — switching later requires engine rewrite.

**Delivers:**
- Domain models (ReadingSession, UserSettings, ParsedText)
- AppState setup (@Observable)
- RSVP Display Engine (CADisplayLink timing, dynamic word duration)
- Text Parser (NLTokenizer wrapper, handles contractions)
- Basic Reader UI (word display with smart anchoring, playback controls)
- Paste text input (simplest source)

**Addresses:**
- Table stakes RSVP display (FEATURES.md)
- Smart anchoring differentiator (PROJECT.md requirement)
- Prevents Pitfall 1 (Timer), Pitfall 2 (constant duration), Pitfall 3 (wrong ORP)

**Avoids:**
- Timer-based implementation (Pitfall 1 — recovery cost MEDIUM)
- Broken tokenization (Pitfall 6 — hits edge cases immediately)

**Uses:**
- Swift 6.2 async/await (STACK.md — Task.sleep for timing)
- CADisplayLink (ARCHITECTURE.md — frame-sync timing)
- NLTokenizer (ARCHITECTURE.md — smart tokenization)

### Phase 2: Text Input Sources
**Rationale:** Core engine proven, now add content import variety. PDF and URL import are independent implementations — can parallelize. Build order: URL → PDF (PDF extraction more complex).

**Delivers:**
- Web fetcher (URLSession + article extraction)
- PDF extractor (PDFKit text parsing, background thread)
- Input source selection UI

**Addresses:**
- Multiple text input sources (PROJECT.md requirement: paste, URL, PDF)
- PDF import (FEATURES.md table stakes)
- URL/web import (FEATURES.md differentiator)

**Avoids:**
- PDF parsing on main thread (PITFALLS.md performance trap — UI freeze >50 pages)
- Naive web scraping (grab all text including nav/ads — use readability algorithm)

**Uses:**
- URLSession async/await (STACK.md — no Alamofire needed)
- PDFKit (STACK.md — native framework, zero dependencies)

### Phase 3: UX Polish + Accessibility
**Rationale:** Core functionality works, now ensure App Store compliance and retention. Dynamic Type required for submission, eye strain prevention critical for retention.

**Delivers:**
- Dynamic Type support (UIFontMetrics, test at 200% text size)
- VoiceOver labels for controls
- Fatigue prevention (20-minute auto-pause, break reminders)
- Onboarding with RSVP demo + expectations setting
- Settings UI (WPM, font size, theme)

**Addresses:**
- Eye-friendly color palette (PROJECT.md requirement)
- Apple HIG compliance (PROJECT.md constraint)
- Interactive onboarding (PROJECT.md requirement)

**Avoids:**
- App Store rejection (Pitfall 5 — Dynamic Type mandatory)
- Eye strain churn (Pitfall 4 — users quit after headache session)
- Speed overpromising (Pitfall 7 — reputation damage)

**Uses:**
- SwiftUI @Observable (STACK.md — state management)
- UserDefaults (ARCHITECTURE.md — settings persistence)

### Phase 4: Stats + Comprehension Validation
**Rationale:** Core product shipped, now add retention features. Comprehension check addresses RSVP's main criticism defensively.

**Delivers:**
- Completion stats (time, WPM, word count — PROJECT.md requirement)
- Optional comprehension quiz (addresses research finding)
- Reading statistics dashboard (WPM over time, words read)
- Smart speed adjustment (auto-slow at punctuation/long words)

**Addresses:**
- Completion stats (PROJECT.md requirement)
- Comprehension degradation (FEATURES.md — research-backed defensive feature)
- Smart speed adjustment (FEATURES.md differentiator)

**Avoids:**
- Comprehension ignored (Pitfall 7 — users quit when realizing they retain nothing)

**Uses:**
- SwiftData (STACK.md — if adding persistence, simpler than CoreData)

### Phase Ordering Rationale

- **Phase 1 first:** Timing precision is existential risk. Wrong timing = failed core value prop ("smooth, distraction-free playback"). CADisplayLink, dynamic duration, ORP must be correct before user testing creates bad muscle memory.
- **Phase 2 before 3:** Input sources are product-complete features (URL/PDF import). UX polish is refinement. Better to validate import methods work before polishing UI.
- **Phase 3 before App Store:** Dynamic Type is mandatory for approval. Eye strain prevention critical for public retention (avoid "made my eyes hurt" reviews).
- **Phase 4 post-launch:** Stats/comprehension are retention features, not launch-blocking. Can ship v1 without quiz, add based on user feedback.

**Dependencies:**
- Phase 2 depends on Phase 1 (needs RSVP Engine to display imported text)
- Phase 3 can parallelize with Phase 2 (UI polish independent of import sources)
- Phase 4 depends on Phase 1 (needs session completion to record stats)

### Research Flags for Phases

**Phases likely needing deeper research:**
- **Phase 2 (URL Import):** Article extraction algorithms (Mozilla Readability port, parsing strategies) — sparse iOS-specific docs, may need web research
- **Phase 4 (Comprehension Quiz):** Question generation from text (key concept extraction) — implementation UX challenge, research academic RSVP comprehension studies

**Phases with standard patterns (skip /gsd:research-phase):**
- **Phase 1 (RSVP Engine):** CADisplayLink, NLTokenizer well-documented in Apple docs, research complete
- **Phase 3 (Accessibility):** Dynamic Type, VoiceOver patterns standard iOS (Apple HIG + documentation)
- **Phase 4 (Stats):** SwiftData persistence standard pattern, well-documented

## Confidence Assessment

| Area | Confidence | Notes |
|------|------------|-------|
| Stack | HIGH | Verified with Apple Developer docs, Xcode release notes, Swift.org sources. Zero-dependency approach proven. |
| Features | MEDIUM | Based on competitor analysis + WebSearch, not primary user research. Table stakes clear, differentiators inferred. |
| Architecture | MEDIUM | Clean Architecture + MVVM verified as 2025 standard. CADisplayLink/NLTokenizer verified in Apple docs. Build order is logical dependency analysis, not authoritative source. |
| Pitfalls | MEDIUM | Timer precision, comprehension degradation verified with research papers. ORP alignment, eye strain based on secondary sources + implementation examples. |

**Overall confidence:** MEDIUM-HIGH

Research provides strong foundation for roadmap creation. Stack and critical technical decisions (CADisplayLink, NLTokenizer) are HIGH confidence. Feature prioritization and phase structure are MEDIUM (logical but not user-validated).

### Gaps to Address

- **Optimal WPM range validation:** Research suggests 250-300 WPM optimal, competitors claim 1000+ — needs user testing to find practical ceiling
- **Smart anchoring hypothesis:** Bold first letters is PROJECT.md approach, but not verified vs standard red ORP — A/B test in Phase 1
- **ORP position formula:** Sources vary on exact position for 6-9 letter words ("slightly left of center" — needs implementation testing)
- **Comprehension quiz UX:** What format doesn't annoy users? Multiple choice? Self-assessment? Defer to Phase 4, gather feedback
- **ProMotion 120Hz impact:** CADisplayLink at 120fps untested for RSVP — verify on ProMotion device during Phase 1

**How to handle:**
- WPM ceiling: Start with 300 WPM default, cap at 500 WPM with warning (Phase 1). Test higher speeds in beta, adjust based on feedback.
- Smart anchoring: Implement bold-first-letter approach (PROJECT.md), add analytics to track if users adjust default styling (Phase 1). Consider A/B test in future.
- ORP formula: Start with research-based calculation (position 1 for 3-5 chars, position 2-3 for 6-9 chars), iterate based on user testing.
- Comprehension quiz: Research question generation approaches during Phase 4 planning (use /gsd:research-phase). Start simple (self-assessment), add automated quiz if demanded.
- ProMotion: Test CADisplayLink on 120Hz device during Phase 1 development. Research shows it should work, verify smoothness.

## Sources

### Primary (HIGH confidence)
- Apple Developer Documentation (Swift, SwiftUI, CADisplayLink, NLTokenizer, PDFKit) — Official APIs, current versions verified
- Xcode 16.3 Release Notes — Build requirements for 2025 App Store submissions
- App Store Review Guidelines — Accessibility requirements (Dynamic Type mandatory)
- PubMed: "Modern Speed-Reading Apps Do Not Foster Reading Comprehension" — Academic research on RSVP comprehension degradation

### Secondary (MEDIUM confidence, verified with official sources)
- Modern iOS Architecture guides (Medium, 2025) — Clean Architecture + MVVM patterns, cross-verified with Apple WWDC content
- Speed reading app reviews (Speed Reading Lounge, Iris Reading) — Feature landscape, competitor analysis
- Outread, ReadQuick, Spreeder app websites — Competitor features, implementation approaches
- iOS accessibility guides (Reintech, Apple HIG) — Dynamic Type patterns, VoiceOver implementation

### Tertiary (LOW confidence, unverified)
- Academic papers on RSVP (paywalled, couldn't verify full findings) — ORP positioning, mental workload
- GitHub RSVP implementations — Reference code, not authoritative for architecture decisions
- User reviews aggregated from app stores — Complaints about eye strain, comprehension issues (anecdotal)

---
*Research completed: 2026-01-18*
*Ready for roadmap: yes*
