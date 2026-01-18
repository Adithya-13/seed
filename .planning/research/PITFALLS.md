# Pitfalls Research

**Domain:** iOS RSVP Speed Reading App
**Researched:** 2026-01-18
**Confidence:** MEDIUM

## Critical Pitfalls

### Pitfall 1: Using Timer Instead of CADisplayLink

**What goes wrong:**
Timer/DispatchSourceTimer fires at imprecise intervals (±16ms drift), causing stuttering word display. Users perceive "jerky" RSVP playback even at moderate speeds (250-400 WPM). At 300 WPM, words should appear every 200ms exactly — Timer can drift to 184-216ms, destroying flow.

**Why it happens:**
Timer seems simpler than CADisplayLink. Developers assume "close enough" timing is fine. Don't realize Timer:
- Has no correlation with frame updates (can fire mid-render)
- Drifts earlier/later than requested
- Doesn't fire during UI interaction (scrolling blocks it)
- Runs at ~60Hz resolution max (16.667ms) in main runloop

**How to avoid:**
Use CADisplayLink for word timing, not Timer. CADisplayLink syncs with display refresh (60Hz/120Hz ProMotion), guaranteeing callback right after frame render. Gives full 16ms to prepare next word without drift.

```swift
// WRONG - Timer drifts
Timer.scheduledTimer(withTimeInterval: wordInterval, repeats: true) { _ in
    showNextWord()
}

// RIGHT - CADisplayLink syncs with frames
displayLink = CADisplayLink(target: self, selector: #selector(tick))
displayLink?.add(to: .main, forMode: .common)
```

**Warning signs:**
- Word display feels "off" at higher WPM
- Users report stuttering or inconsistent pace
- Playback pauses during user interaction
- Timing feels different on ProMotion vs standard displays

**Phase to address:**
Phase 1 (RSVP Engine) — core timing architecture must be CADisplayLink from start. Switching later requires engine rewrite.

---

### Pitfall 2: Ignoring Word Length in Display Duration

**What goes wrong:**
Showing all words for same duration (e.g., 200ms at 300 WPM) tanks comprehension. Short words ("a", "is") feel too slow. Long words ("comprehension", "simultaneously") flash by unreadably. Users blame themselves for "not being fast enough" when it's the app's fault.

**Why it happens:**
Constant WPM calculation is simple: `duration = 60000ms / WPM`. Developers don't realize human reading has variable fixation time based on word length — 2-letter words need ~150ms, 10-letter words need ~300ms at same perceived speed.

**How to avoid:**
Implement dynamic word duration based on length + punctuation:

- Short words (1-3 letters): 0.8x base duration
- Medium words (4-8 letters): 1.0x base duration
- Long words (9+ letters): 1.5x base duration
- Punctuation (. ! ?): +3x pause after word
- Commas/semicolons: +1.5x pause after word

Research shows optimal RSVP at ~250 WPM requires dynamic pacing, not constant intervals.

**Warning signs:**
- Users complain long words are "too fast"
- Comprehension drops at moderate speeds (250-350 WPM)
- User testing shows confusion at sentence boundaries
- Developers notice own RSVP experience feels "rushed"

**Phase to address:**
Phase 1 (RSVP Engine) — duration algorithm is core engine behavior. Adding later breaks user expectations from training data.

---

### Pitfall 3: Misaligned Optimal Recognition Point (ORP)

**What goes wrong:**
Highlighting wrong letter position forces eye refixation, adding cognitive load. Common mistake: centering ORP or using first letter for all words. Research shows ORP is slightly left of center — 2nd letter for short words (3-5 chars), near-middle for long words. Misalignment increases blinks (fatigue indicator) and suppresses parafoveal processing.

**Why it happens:**
Developers assume "bold first letter" works for all words or that exact centering is optimal. Don't verify ORP claims from RSVP literature (Spritz patent, academic studies). Ship untested alignment that "looks right."

**How to avoid:**
Implement evidence-based ORP calculation:

- 1-2 letters: highlight position 0 (first letter)
- 3-5 letters: highlight position 1 (second letter)
- 6-9 letters: highlight position 2-3 (slightly left of center)
- 10+ letters: highlight position 3-4 (closer to middle)

Test with actual users at 300+ WPM to verify alignment feels "locked in."

**Warning signs:**
- Users report eye strain or fatigue after 5-10 minutes
- Higher blink rate during RSVP vs normal reading
- Users say words "feel off" but can't explain why
- Eye tracking shows micro-saccades during RSVP

**Phase to address:**
Phase 1 (RSVP Engine) — ORP is core visual anchoring. Wrong from start means all training builds bad muscle memory.

---

### Pitfall 4: No Eye Strain Mitigation

**What goes wrong:**
Users experience digital eye strain after 10-20 minutes continuous RSVP. Symptoms: dry eyes, headaches, blurred vision, difficulty refocusing on distant objects. Research shows 50-66% of digital device users get eye strain; RSVP's fixed focal point is worse than normal reading (no natural eye movement). Users quit app permanently after one bad session.

**Why it happens:**
Developers focus on speed/features, ignore ergonomics. Don't realize RSVP eliminates natural eye movement that rests eye muscles. Miss that continuous focus at same distance (reading) requires 20-20-20 rule: every 20 minutes, look 20 feet away for 20 seconds.

**How to avoid:**
Implement proactive fatigue prevention:

- Auto-pause every 15-20 minutes with break reminder
- Suggest 20-20-20 rule in onboarding
- Support iOS Dark Mode / light background option
- Show session duration timer
- Warn if session >30 minutes without break
- Add "Rest Eyes" button to pause menu

Educate users: speed reading is mental + physical exercise requiring rest.

**Warning signs:**
- User reviews mention headaches or eye pain
- High session abandonment after 15-20 minutes
- Users don't return after first session
- App Store reviews: "made my eyes hurt"

**Phase to address:**
Phase 2 (Polish/UX) — can ship v1 without this, but critical for retention. Add before public App Store launch.

---

### Pitfall 5: Ignoring Accessibility Requirements

**What goes wrong:**
App rejected by App Store for failing accessibility compliance. Common failures:
- No Dynamic Type support (required to scale text 200%+ for vision-impaired users)
- VoiceOver reads RSVP words as gibberish (rapid word changes)
- Minimum font size <11pt (Apple requirement)
- Controls don't adapt to larger accessibility fonts

iOS apps MUST support Dynamic Type or face rejection. RSVP is already difficult for low-vision users; breaking accessibility = App Store rejection + legal risk.

**Why it happens:**
Developers test on their devices with default settings. Don't enable Dynamic Type or VoiceOver during development. Assume RSVP visual presentation is "inherently inaccessible" so skip accessibility work. Discover rejection only at App Store review (weeks lost).

**How to avoid:**
Build accessibility from start:

- Use `UIFontMetrics` for scalable fonts
- Set `adjustsFontForContentSizeCategory = true`
- Test with Settings > Accessibility > Larger Text at 200%+
- Add VoiceOver labels for controls (play/pause/speed)
- Consider "VoiceOver Mode" that reads sentence chunks, not individual words
- Minimum font 11pt at default Dynamic Type size
- Allow text to reflow; set `numberOfLines = 0` on text elements

Test on device with accessibility settings BEFORE submitting.

**Warning signs:**
- App Store review requests accessibility fixes
- UI breaks with Larger Text enabled
- Controls overlap or get cut off with bigger fonts
- VoiceOver testing never performed

**Phase to address:**
Phase 1 (RSVP Engine) — Dynamic Type support must be in font rendering from start. Phase 2 (Polish) — VoiceOver polish before App Store submission.

---

### Pitfall 6: Naive Text Parsing Breaks RSVP Flow

**What goes wrong:**
Text parsing treats "don't", "it's", "e.g." as separate tokens, breaking RSVP rhythm. Hyphenated words split incorrectly ("state-of-the-art" becomes 4 words). URLs/emails shown word-by-word ("https", ":", "//", "example"...) are unreadable. Quotes/parentheticals disrupt visual anchoring alignment.

Users hit these edge cases in real content (articles with URLs, technical docs with abbreviations), perceive app as "broken."

**Why it happens:**
Developers use simple `text.split(" ")` for tokenization. Don't test with real-world content (web articles, PDFs with formatting). Miss that English has complex tokenization rules: contractions, hyphenation, punctuation, abbreviations.

**How to avoid:**
Implement smart tokenization:

- Contractions stay whole: "don't" → 1 word, not ["don", "t"]
- Abbreviations: "e.g." → 1 word (common: e.g., i.e., etc., Dr., Mr.)
- URLs/emails: show entire URL as single "word" with smaller font
- Hyphenated compounds: "state-of-the-art" → show with internal hyphens visible
- Em dashes: treat as sentence pause (—)
- Quotes: keep with word ("hello" not [", hello, "])

Test with actual web article imports, PDF extraction output.

**Warning signs:**
- User reports "weird pauses" or "broken words"
- URLs from web imports display as gibberish
- Contractions feel stuttery during playback
- Testing only uses clean, manual text input

**Phase to address:**
Phase 1 (RSVP Engine) — tokenization is foundational. Phase 2 (Import Sources) — catch edge cases from PDF/web scraping.

---

### Pitfall 7: No Comprehension = Speed Reading Theater

**What goes wrong:**
App trains users to "read" at 600+ WPM with 20% comprehension. Users feel fast, measure WPM gains, but retain nothing. Research conclusively shows: RSVP comprehension falls as speed increases, worse for paragraphs vs sentences. At 600 WPM, users see words but don't process meaning.

Users eventually realize they remember nothing, blame speed reading as "scam," uninstall app, leave negative reviews.

**Why it happens:**
Developers optimize for vanity metric (WPM) not actual outcome (comprehension). Don't include comprehension checks or guidance on optimal speeds. Market "3x reading speed!" without asterisk that comprehension tanks at 3x.

**How to avoid:**
Design for comprehension, not just speed:

- Default to 250-300 WPM (research-backed optimal for RSVP)
- Cap speed at 500 WPM with warning: "comprehension may suffer"
- Include optional comprehension quiz after session
- Onboarding: "Speed reading = finding your optimal speed, not maximum speed"
- Show comprehension % alongside WPM in stats
- Recommend progressive training: 300→350→400 WPM over weeks

Be honest about tradeoffs. Position as "reading efficiency" not "reading magic."

**Warning signs:**
- Marketing emphasizes speed without comprehension mention
- No comprehension testing feature
- Users reach 800+ WPM (physically possible, mentally useless)
- Reviews mention "went fast but remember nothing"

**Phase to address:**
Phase 2 (Stats/Feedback) — add comprehension quiz. Phase 1 (Onboarding) — set expectations correctly from start.

---

### Pitfall 8: Background Mode Audio Conflicts

**What goes wrong:**
RSVP playback pauses/stops when user switches apps or locks screen. If adding background audio (music while reading), iOS audio session conflicts with other apps (Spotify, podcasts). App needs audio background mode for TTS, but this breaks user's existing audio.

For pure-visual RSVP (no TTS), background mode doesn't make sense — reading requires looking at screen.

**Why it happens:**
Developers add background modes without understanding use case. Copy-paste "audio" background mode for timers/TTS without testing conflicts. Don't realize iOS audio session management is complex (ducking, mixing, interruption).

**How to avoid:**
For v1 (visual-only RSVP): DON'T enable background modes. RSVP requires active viewing; background playback is nonsensical.

For future TTS feature:
- Use audio session category `playback` with `.mixWithOthers` option
- Handle audio interruptions (calls, other apps)
- Provide "pause when interrupted" setting
- Test with Spotify, Apple Music, podcast apps running

Use local notifications to alert when session paused (not background execution).

**Warning signs:**
- Users report RSVP conflicts with their music
- Background mode requested in Info.plist without clear use case
- Timer continues in background (wasting battery, progressing unseen)
- Audio session setup is copy-pasted, not understood

**Phase to address:**
Phase 1 (RSVP Engine) — explicitly NO background modes for visual-only RSVP. Future TTS phase — proper audio session management.

---

## Technical Debt Patterns

| Shortcut | Immediate Benefit | Long-term Cost | When Acceptable |
|----------|-------------------|----------------|-----------------|
| Timer instead of CADisplayLink | Simpler code, familiar API | Stuttering playback, poor UX | Never for RSVP timing |
| Constant word duration | Easy WPM calculation | Poor comprehension, user frustration | MVP prototype only (pre-release) |
| Simple `.split(" ")` tokenization | Ships faster | Broken contractions, URLs, edge cases | Internal testing only |
| No Dynamic Type support | Fewer layout issues | App Store rejection | Never (required for iOS) |
| Skipping ORP research | "First letter" assumption works | Suboptimal eye fixation, fatigue | Never (core UX differentiator) |
| No fatigue warnings | Less complexity | Eye strain, bad reviews, churn | Never (retention killer) |
| Over-promising speed gains | Better marketing | User disappointment when comprehension suffers | Never (erodes trust) |

## Integration Gotchas

| Integration | Common Mistake | Correct Approach |
|-------------|----------------|------------------|
| PDF import | Use any PDF library without testing layout preservation | Use PDFKit, verify text extraction doesn't split words incorrectly (columns, headers) |
| Web scraping | Grab all text including nav/ads | Use readability algorithms (Mozilla Readability port) to extract article content only |
| URL scheme import | Parse URLs manually with regex | Use `URLComponents` + validate scheme (http/https) |
| Share Extension | Accept all text types | Limit to text, PDF, URL — gracefully reject images, videos |
| iCloud sync (future) | Sync raw text content | Privacy risk — if adding sync, only sync stats/settings, not user content |

## Performance Traps

| Trap | Symptoms | Prevention | When It Breaks |
|------|----------|------------|----------------|
| Rendering full text in hidden views | Layout calculation lags at session start | Lazy load; only render visible word + next 2 | Texts >10k words |
| Recalculating ORP every frame | Dropped frames at 60fps | Pre-compute ORP positions for all words at session start, cache array | 120Hz ProMotion devices |
| String slicing per word | String copying overhead | Pre-split text into word array on import | Texts >50k words |
| Heavy attribution per word (bold) | SwiftUI re-renders entire AttributedString | Use `Text` with `.bold()` modifier on substring, not attributed string rebuild | Every frame at 300+ WPM |
| PDF parsing on main thread | UI freeze during import | Parse PDF on background queue, show progress indicator | PDFs >50 pages |

## Security Mistakes

| Mistake | Risk | Prevention |
|---------|------|------------|
| Opening arbitrary URLs from text | Phishing via imported content with malicious links | Validate URL schemes (allow http/https only), show alert before opening external URLs |
| Executing web scraping without timeout | Hanging on slow/malicious servers | Set URLSession timeout (10-15s), handle failures gracefully |
| Storing imported text unencrypted | Privacy leak if device compromised | Use iOS Data Protection (FileManager with `.completeFileProtection`) for local storage |
| Loading PDFs without size limits | Memory exhaustion attack | Reject PDFs >50MB, limit to reasonable page count (<500) |
| Web import without content-type validation | App crashes on binary data | Verify `Content-Type: text/*` before attempting text extraction |

## UX Pitfalls

| Pitfall | User Impact | Better Approach |
|---------|-------------|-----------------|
| Starting demo at 500+ WPM | Overwhelming, users think "this is impossible" | Onboarding demo at 250 WPM (comfortable), show that speed is adjustable |
| No progress indicator | Anxiety ("how much longer?"), premature quitting | Show word count progress bar: "234 / 1,450 words (16%)" |
| Instant full-speed playback | Jarring, no orientation time | 3-2-1 countdown before starting RSVP, gives user moment to focus |
| No "oops" recovery | User blinks/distracted, loses place, must restart entire session | Add "back 10 words" button (rewind) for quick recovery |
| Speed adjustment during playback | Disrupts flow, users overfiddle with settings | Only allow speed change when paused OR make adjustment smooth (gradual transition) |
| Hiding controls during playback | User can't pause, locked into session | Show minimal pause button overlay (tap screen to pause) |
| Completion screen = dead end | Session ends, user doesn't know what to do | Show stats + "Read Another" CTA |

## "Looks Done But Isn't" Checklist

- [ ] **RSVP Timing:** Often missing CADisplayLink frame sync — verify with 120Hz ProMotion device
- [ ] **Dynamic Duration:** Often missing word length adaptation — verify long words get more time
- [ ] **Accessibility:** Often missing Dynamic Type support — verify UI at 200% text size
- [ ] **Tokenization:** Often missing contraction handling — verify "don't" displays as single word
- [ ] **ORP Alignment:** Often using first letter for all words — verify position varies by word length
- [ ] **Fatigue Prevention:** Often missing break reminders — verify 20-minute auto-pause
- [ ] **Punctuation Pauses:** Often missing sentence boundaries — verify period = longer pause
- [ ] **PDF Import:** Often breaking on columnar layouts — verify multi-column article extracts correctly
- [ ] **VoiceOver:** Often unreadable by screen readers — verify controls have accessibility labels
- [ ] **Progress Tracking:** Often missing "current word / total" — verify user knows session length
- [ ] **Error States:** Often no fallback for parse failures — verify graceful handling of malformed input
- [ ] **Comprehension Validation:** Often no way to verify understanding — verify quiz or self-check exists

## Recovery Strategies

| Pitfall | Recovery Cost | Recovery Steps |
|---------|---------------|----------------|
| Timer instead of CADisplayLink | MEDIUM | Refactor timing to CADisplayLink, test across device refresh rates (60/120Hz), QA for smoothness |
| No Dynamic Type | MEDIUM | Adopt UIFontMetrics, test all text sizes, fix layout constraints, re-submit to App Store |
| Broken tokenization | LOW | Add regex rules for contractions/abbreviations, build test suite with edge cases, re-test imports |
| Missing fatigue warnings | LOW | Add session timer + auto-pause logic, update onboarding with 20-20-20 rule |
| Poor ORP alignment | LOW-MEDIUM | Update ORP calculation, re-test with users, update onboarding if muscle memory needs reset |
| No comprehension check | LOW | Add optional quiz feature, integrate into completion flow |
| Speed overpromising | HIGH (reputation) | Update marketing copy, add comprehension warnings in-app, publish "effective speed reading" guide |
| Accessibility rejection | HIGH (time) | Implement Dynamic Type, VoiceOver labels, re-submit (2-week review delay) |

## Pitfall-to-Phase Mapping

| Pitfall | Prevention Phase | Verification |
|---------|------------------|--------------|
| Timer (not CADisplayLink) | Phase 1: RSVP Engine | Smooth playback at 300 WPM on ProMotion device, no frame drops |
| Constant word duration | Phase 1: RSVP Engine | Long words (10+ chars) display 1.5x longer than short words (3 chars) |
| Wrong ORP alignment | Phase 1: RSVP Engine | Position 1 for 4-letter words, position 3 for 10-letter words |
| Naive tokenization | Phase 1: RSVP Engine + Phase 2: Import | "don't" = 1 word, not 2; URLs display as single element |
| No eye strain prevention | Phase 2: UX Polish | Auto-pause at 20 minutes, break reminder shown |
| Missing accessibility | Phase 1: RSVP Engine (Dynamic Type) + Phase 2: UX Polish (VoiceOver) | UI works at 200% text size, VoiceOver reads all controls |
| Comprehension ignored | Phase 2: Stats & Feedback | Comprehension quiz available, onboarding sets expectations |
| Background mode conflicts | Phase 1: RSVP Engine | No background modes in Info.plist for visual-only RSVP |
| PDF parsing perf | Phase 2: Import Sources | 100-page PDF parses in <3s on background thread |
| Speed overpromising | Phase 1: Onboarding | Marketing/onboarding mentions comprehension, caps speed at 500 WPM with warning |

## Sources

### Primary (HIGH confidence)
- [Modern Speed-Reading Apps Do Not Foster Reading Comprehension - PubMed](https://pubmed.ncbi.nlm.nih.gov/29461715/) - Comprehension degradation research
- [CADisplayLink | Apple Developer Documentation](https://developer.apple.com/documentation/quartzcore/cadisplaylink) - Official iOS timing API
- [Technical Note TN2169: High Precision Timers in iOS](https://developer.apple.com/library/archive/technotes/tn2169/_index.html) - Timer precision limitations
- [Larger Text evaluation criteria - App Store Connect](https://developer.apple.com/help/app-store-connect/manage-app-accessibility/larger-text-evaluation-criteria/) - Dynamic Type requirements

### Secondary (MEDIUM confidence)
- [NSTimer vs CADisplayLink - Medium](https://medium.com/flawless-app-stories/nstimer-vs-cadisplaylink-cc6aa8509115) - Timer comparison (verified with Apple docs)
- [How to Avoid Eye Strain While Speed Reading - Learning Genius](https://learninggenius.com/how-to-avoid-eye-strain-and-fatigue-while-speed-reading/) - Fatigue prevention (verified 20-20-20 rule)
- [iOS Accessibility: VoiceOver, Dynamic Type - Reintech](https://reintech.io/blog/ios-accessibility-voiceover-dynamic-type-assistivetouch) - Accessibility implementation (verified with Apple docs)
- [Effects of RSVP Display Design - International Journal of Design](https://www.ijdesign.org/index.php/IJDesign/article/view/36/8) - Display optimization research

### Tertiary (LOW confidence - needs validation)
- [RSVP Speed Reading - Librera](https://librera.mobi/faq/rsvp-speed-reading-rapid-serial-visual-presentation/) - RSVP implementation patterns
- [One does not Simply RSVP - CHI 2020](https://dl.acm.org/doi/10.1145/3313831.3376766) - Mental workload research (paywalled, couldn't verify full findings)
- [Speed Reading App Reviews - Speed Reading Lounge](https://www.speedreadinglounge.com/speed-reading-apps) - User complaints (aggregated from reviews)

---
*Pitfalls research for: iOS RSVP Speed Reading App*
*Researched: 2026-01-18*
