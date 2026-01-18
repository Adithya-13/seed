# Architecture Research

**Domain:** iOS RSVP speed reading app
**Researched:** 2026-01-18
**Confidence:** MEDIUM

## Standard Architecture

### System Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
├─────────────────────────────────────────────────────────────┤
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐    │
│  │  Reader  │  │  Input   │  │ Settings │  │  Stats   │    │
│  │   View   │  │   View   │  │   View   │  │   View   │    │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘    │
│       │             │             │             │           │
│  ┌────┴─────┐  ┌────┴─────┐  ┌────┴─────┐  ┌────┴─────┐    │
│  │  Reader  │  │  Input   │  │ Settings │  │  Stats   │    │
│  │ ViewModel│  │ ViewModel│  │ ViewModel│  │ ViewModel│    │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘    │
│       │             │             │             │           │
├───────┴─────────────┴─────────────┴─────────────┴───────────┤
│                      DOMAIN LAYER                            │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────┐    │
│  │               AppState (Observable)                 │    │
│  │  - readingSession: ReadingSession?                  │    │
│  │  - userSettings: UserSettings                       │    │
│  │  - completionStats: [SessionStats]                  │    │
│  └──────────────────────┬──────────────────────────────┘    │
│                         │                                    │
│  ┌──────────┐  ┌────────┴──────┐  ┌──────────────┐          │
│  │   Text   │  │     RSVP      │  │  Playback    │          │
│  │ Parser   │  │   Display     │  │   Control    │          │
│  │ UseCase  │  │   UseCase     │  │   UseCase    │          │
│  └────┬─────┘  └───────┬───────┘  └──────┬───────┘          │
│       │                │                 │                  │
├───────┴────────────────┴─────────────────┴──────────────────┤
│                       DATA LAYER                             │
├─────────────────────────────────────────────────────────────┤
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐    │
│  │   Text   │  │   Web    │  │   PDF    │  │ Settings │    │
│  │  Repo    │  │  Fetcher │  │  Extractor│ │   Repo   │    │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘    │
└─────────────────────────────────────────────────────────────┘
```

### Component Responsibilities

| Component | Responsibility | Typical Implementation |
|-----------|----------------|------------------------|
| **Views** | UI display, user interaction | SwiftUI views with minimal state (@State for local UI) |
| **ViewModels** | Presentation logic, state observation | @Observable classes coordinating UseCases |
| **AppState** | Single source of truth | @Observable object holding session, settings, stats |
| **UseCases** | Business logic encapsulation | Stateless classes operating on AppState |
| **Repositories** | Data access abstraction | Protocols with concrete implementations per source |
| **Display Timer** | Precise RSVP timing | CADisplayLink for 60/120fps sync |
| **Text Parser** | Word tokenization | NLTokenizer for language-aware parsing |

## Recommended Project Structure

```
Seed/
├── App/
│   ├── SeedApp.swift              # App entry, dependency injection
│   └── AppState.swift              # Observable global state
├── Presentation/
│   ├── Reader/
│   │   ├── ReaderView.swift       # RSVP display UI
│   │   ├── ReaderViewModel.swift  # Playback coordination
│   │   └── Components/
│   │       ├── WordDisplay.swift  # Single word rendering with anchor
│   │       └── PlaybackControls.swift  # Start/pause/speed UI
│   ├── Input/
│   │   ├── InputView.swift        # Source selection UI
│   │   ├── InputViewModel.swift   # Input coordination
│   │   └── Sources/
│   │       ├── PasteInput.swift   # Text paste UI
│   │       ├── URLInput.swift     # Web URL UI
│   │       └── PDFPicker.swift    # PDF selection UI
│   ├── Settings/
│   │   ├── SettingsView.swift     # Preferences UI
│   │   └── SettingsViewModel.swift
│   └── Stats/
│       ├── StatsView.swift        # Completion metrics UI
│       └── StatsViewModel.swift
├── Domain/
│   ├── Models/
│   │   ├── ReadingSession.swift   # Active session state
│   │   ├── UserSettings.swift     # WPM, display prefs
│   │   ├── SessionStats.swift     # Completion data
│   │   └── ParsedText.swift       # Words with metadata
│   ├── UseCases/
│   │   ├── TextParserUseCase.swift    # Tokenization logic
│   │   ├── RSVPDisplayUseCase.swift   # Word progression logic
│   │   ├── PlaybackControlUseCase.swift  # State transitions
│   │   └── StatsAggregationUseCase.swift  # Metrics calculation
│   └── Repositories/
│       ├── TextRepositoryProtocol.swift
│       ├── SettingsRepositoryProtocol.swift
│       └── StatsRepositoryProtocol.swift
└── Data/
    ├── Repositories/
    │   ├── TextRepository.swift       # Coordinates sources
    │   ├── SettingsRepository.swift   # UserDefaults wrapper
    │   └── StatsRepository.swift      # SwiftData persistence
    ├── Sources/
    │   ├── WebFetcher.swift           # URLSession for web content
    │   ├── PDFExtractor.swift         # PDFKit text extraction
    │   └── TextParser.swift           # NLTokenizer wrapper
    └── Timers/
        └── DisplayTimer.swift         # CADisplayLink wrapper
```

### Structure Rationale

- **App/:** Single source of truth (AppState) + dependency setup. Views get dependencies via @Environment.
- **Presentation/:** Feature modules (Reader, Input, Settings, Stats) with View + ViewModel. ViewModels trigger UseCases, observe AppState changes.
- **Domain/:** Platform-agnostic business logic. Models = data structures, UseCases = operations, Repository protocols = data contracts.
- **Data/:** Concrete implementations. Repositories coordinate sources/persistence, Sources handle I/O, Timers wrap performance-critical native APIs.

## Architectural Patterns

### Pattern 1: Clean Architecture with MVVM

**What:** Three-layer separation (Presentation/Domain/Data) with MVVM in presentation layer. Domain owns models and business logic, Data implements I/O.

**When to use:** Always for SwiftUI apps in 2025. Standard pattern with strong ecosystem support.

**Trade-offs:**
- **Pro:** Testable (mock repositories), maintainable (clear boundaries), scalable (feature modules).
- **Con:** More files than MVC, requires discipline to maintain boundaries.

**Example:**
```swift
// Domain layer - UseCase
class RSVPDisplayUseCase {
    func startReading(text: ParsedText, wpm: Int, in state: AppState) {
        let msPerWord = 60_000 / wpm
        state.readingSession = ReadingSession(
            text: text,
            currentIndex: 0,
            intervalMs: msPerWord
        )
    }
}

// Presentation layer - ViewModel
@Observable
class ReaderViewModel {
    let displayUseCase: RSVPDisplayUseCase
    let appState: AppState

    func startReading() {
        guard let parsed = appState.parsedText else { return }
        displayUseCase.startReading(
            text: parsed,
            wpm: appState.userSettings.wpm,
            in: appState
        )
    }
}

// View
struct ReaderView: View {
    @Environment(AppState.self) private var appState
    @State private var viewModel: ReaderViewModel

    var body: some View {
        WordDisplay(word: appState.readingSession?.currentWord)
            .onAppear { viewModel.startReading() }
    }
}
```

### Pattern 2: CADisplayLink for Precise Timing

**What:** Display-synchronized timer instead of Timer/DispatchSource. Fires right after screen refresh (16.6ms for 60fps, 8.3ms for 120fps).

**When to use:** RSVP word display, animations requiring smoothness. Critical for visual presentation apps.

**Trade-offs:**
- **Pro:** Maximum time for next frame render (up to 16ms vs 3-16ms with Timer), eliminates tearing/stuttering, tied to device refresh rate.
- **Con:** Runs continuously (battery impact), requires manual stop/start, main thread only.

**Example:**
```swift
// Data layer - Timer wrapper
class DisplayTimer {
    private var displayLink: CADisplayLink?
    private var callback: (() -> Void)?

    func start(fps: Int, callback: @escaping () -> Void) {
        self.callback = callback
        displayLink = CADisplayLink(target: self, selector: #selector(tick))
        displayLink?.preferredFramesPerSecond = fps
        displayLink?.add(to: .main, forMode: .default)
    }

    @objc private func tick() {
        callback?()
    }

    func stop() {
        displayLink?.invalidate()
        displayLink = nil
    }
}

// Domain layer - UseCase using timer
class RSVPDisplayUseCase {
    let timer = DisplayTimer()

    func startPlayback(session: ReadingSession, state: AppState) {
        let wordsPerFrame = session.intervalMs < 16 ? 1 : 60_000 / (session.wpm * 60)
        timer.start(fps: 60) {
            guard session.currentIndex < session.text.words.count else {
                self.stopPlayback(state: state)
                return
            }
            session.currentIndex += 1
            state.objectWillChange.send()
        }
    }
}
```

### Pattern 3: NLTokenizer for Text Parsing

**What:** Apple's Natural Language framework for word tokenization. Handles multiple languages, punctuation, special cases automatically.

**When to use:** Any text-to-words operation. Don't split on spaces manually.

**Trade-offs:**
- **Pro:** Multi-language support (Chinese/Japanese no spaces), handles contractions correctly, respects linguistic boundaries.
- **Con:** Apple-only (but that's the platform), requires iOS 12+ (non-issue in 2025).

**Example:**
```swift
// Data layer - Parser
class TextParser {
    func parseIntoWords(_ text: String) -> [String] {
        let tokenizer = NLTokenizer(unit: .word)
        tokenizer.string = text

        var words: [String] = []
        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { range, _ in
            words.append(String(text[range]))
            return true
        }
        return words
    }
}

// Domain layer - UseCase
class TextParserUseCase {
    let parser: TextParser

    func parse(_ rawText: String) -> ParsedText {
        let words = parser.parseIntoWords(rawText)
        return ParsedText(
            words: words,
            totalCount: words.count,
            estimatedMinutes: words.count / 200 // avg reading speed
        )
    }
}
```

## Data Flow

### Request Flow

```
[User taps "Start"]
    ↓
ReaderView → ReaderViewModel.startReading()
    ↓
RSVPDisplayUseCase.startReading(text, wpm, appState)
    ↓
DisplayTimer.start(fps: 60) → tick every 16ms
    ↓
Update AppState.readingSession.currentIndex
    ↓
AppState.objectWillChange.send() → SwiftUI re-renders
    ↓
ReaderView updates WordDisplay with new word
```

### State Management

```
[AppState @Observable]
    ↓ (injected via @Environment)
[ViewModels] ←→ [UseCases] → [Mutate AppState]
    ↓                              ↓
[Views observe]              [Repositories persist]
```

### Key Data Flows

1. **Text input flow:** User selects source → InputViewModel → TextRepository (WebFetcher/PDFExtractor/Paste) → TextParserUseCase → AppState.parsedText
2. **RSVP playback flow:** User taps start → ReaderViewModel → RSVPDisplayUseCase → DisplayTimer ticks → AppState.readingSession.currentIndex++ → ReaderView updates
3. **Settings persistence flow:** User changes WPM → SettingsViewModel → AppState.userSettings.wpm → SettingsRepository → UserDefaults
4. **Stats recording flow:** Session completes → StatsAggregationUseCase → AppState.completionStats.append() → StatsRepository → SwiftData persistence

## Scaling Considerations

| Scale | Architecture Adjustments |
|-------|--------------------------|
| 0-10k words | Current architecture sufficient. All in-memory processing. |
| 10k-100k words | Chunk text parsing (stream tokenization). Consider background thread for parsing. |
| 100k+ words (books) | Lazy loading (parse on-demand). Paginate stats queries. Add progress persistence. |

### Scaling Priorities

1. **First bottleneck:** Text parsing large documents blocks UI. **Fix:** Move parsing to background thread with progress updates.
2. **Second bottleneck:** Stats list grows large (100+ sessions). **Fix:** SwiftData pagination, archive old sessions.

## Anti-Patterns

### Anti-Pattern 1: Using Timer/DispatchSourceTimer for RSVP

**What people do:** Use `Timer.scheduledTimer` or `DispatchQueue.main.asyncAfter` for word updates.

**Why it's wrong:** Timer has 3-16ms precision vs CADisplayLink's 16ms guaranteed. Correlation with frame updates is random. Causes micro-stuttering and inconsistent word display timing.

**Do this instead:** Use CADisplayLink tied to screen refresh. Calculate word index from frame count for precise timing.

### Anti-Pattern 2: Manual String Splitting on Spaces

**What people do:** `text.split(separator: " ")` to tokenize words.

**Why it's wrong:** Breaks on languages without spaces (Chinese/Japanese). Doesn't handle punctuation ("don't" vs "don", "'t"). Misses linguistic boundaries.

**Do this instead:** Use NLTokenizer with .word unit. Handles all languages and edge cases correctly.

### Anti-Pattern 3: ViewModels Holding Business Logic

**What people do:** Put RSVP timing calculations, parsing logic, stats aggregation in ViewModels.

**Why it's wrong:** Locks logic to presentation layer. Can't test without UI. Can't reuse across views.

**Do this instead:** Extract to UseCases in Domain layer. ViewModels coordinate UseCases, hold no logic.

### Anti-Pattern 4: Direct Repository Calls from Views

**What people do:** Views directly call `TextRepository.fetch()` in `onAppear`.

**Why it's wrong:** Tight coupling, no business logic separation, hard to test views.

**Do this instead:** Views trigger ViewModel methods → ViewModel calls UseCase → UseCase calls Repository. Views only observe AppState changes.

## Integration Points

### External Services

| Service | Integration Pattern | Notes |
|---------|---------------------|-------|
| Web content | URLSession in WebFetcher | Use `String(contentsOf:)` or URLSession.dataTask for HTML fetching. Parse with SwiftSoup if needed. |
| PDF files | PDFKit in PDFExtractor | Use `PDFDocument(url:)`, iterate pages, extract `.string` property. Native iOS, no dependencies. |
| Settings | UserDefaults in SettingsRepository | Use @AppStorage in SwiftUI for automatic sync, or manual UserDefaults.standard. |
| Stats persistence | SwiftData in StatsRepository | Use @Model for SessionStats, ModelContext for queries. Auto iCloud sync available. |

### Internal Boundaries

| Boundary | Communication | Notes |
|----------|---------------|-------|
| View ↔ ViewModel | @Observable observation | Views inject AppState via @Environment, ViewModels mutate AppState |
| ViewModel ↔ UseCase | Direct method calls | ViewModels own UseCases (injected), call stateless methods |
| UseCase ↔ Repository | Protocol abstraction | UseCases depend on protocols, Data layer implements concretely |
| DisplayTimer ↔ UseCase | Callback closure | Timer fires callback, UseCase mutates AppState in callback |

## Build Order Implications

**Phase structure suggestion based on dependencies:**

1. **Foundation (Data models + AppState):** Domain models, AppState setup. No dependencies.
2. **Text input sources:** WebFetcher, PDFExtractor, TextParser, Paste. Independent implementations.
3. **Core RSVP engine:** DisplayTimer, RSVPDisplayUseCase, ReaderView. Depends on models.
4. **Playback controls:** PlaybackControlUseCase, controls UI. Depends on RSVP engine.
5. **Settings:** SettingsRepository, SettingsView. Can parallelize with controls.
6. **Stats tracking:** StatsAggregationUseCase, StatsRepository, StatsView. Depends on session completion.

**Critical path:** Models → Text parsing → RSVP display → Playback controls
**Parallelizable:** Settings, Stats UI (after core RSVP works)

## Sources

### Primary (HIGH confidence)
- [Apple CADisplayLink Documentation](https://developer.apple.com/documentation/quartzcore/cadisplaylink) - Official display timer API
- [Apple NLTokenizer Documentation](https://developer.apple.com/documentation/naturallanguage/nltokenizer) - Official tokenization API
- [Alexey Naumov: Clean Architecture for SwiftUI](https://nalexn.github.io/clean-architecture-swiftui) - Authoritative architecture guide with code examples

### Secondary (MEDIUM confidence)
- [Modern iOS Architecture Patterns 2025](https://medium.com/@sharmapraveen91/modern-ios-architecture-patterns-and-best-practices-5320e2d9d1aa) - Current patterns overview
- [The Ultimate Guide to Modern iOS Architecture in 2025](https://medium.com/@csmax/the-ultimate-guide-to-modern-ios-architecture-in-2025-9f0d5fdc892f) - 2025 architecture trends
- [2025's Best SwiftUI Architecture: MVVM + Clean + Feature Modules](https://medium.com/@minalkewat/2025s-best-swiftui-architecture-mvvm-clean-feature-modules-3a369a22858c) - Feature module patterns
- [iOS Timer Tutorial - Kodeco](https://www.kodeco.com/113835-ios-timer-tutorial) - CADisplayLink vs Timer comparison
- [CADisplayLink and its applications](https://medium.com/@dmitryivanov_54099/cadisplaylink-and-its-applications-bfafb760d738) - Timing precision details
- [How to extract text from PDF using PDFKit](https://www.hackingwithswift.com/example-code/libraries/how-to-extract-text-from-a-pdf-using-pdfkit) - Native PDF parsing
- [Tokenizing Natural Language Text](https://developer.apple.com/documentation/foundation/nslinguistictagger/tokenizing_natural_language_text) - Apple tokenization guide
- [SwiftUI Data Persistence in 2025](https://dev.to/swift_pal/swiftui-data-persistence-in-2025-swiftdata-core-data-appstorage-scenestorage-explained-with-5g2c) - Modern persistence patterns

### Tertiary (LOW confidence)
- [Speed Reading Apps overview](https://www.speedreadinglounge.com/speed-reading-apps) - Feature landscape, not architecture
- [Outread app](https://outreadapp.com/) - Commercial RSVP app, no implementation details
- [Swift Web Scraping Tutorial 2025](https://www.zenrows.com/blog/swift-web-scraping) - Web fetching approaches

---
*Architecture research for: iOS RSVP speed reading app*
*Researched: 2026-01-18*
