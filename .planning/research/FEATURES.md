# Feature Research

**Domain:** iOS RSVP Speed Reading Trainer
**Researched:** 2026-01-18
**Confidence:** MEDIUM

## Feature Landscape

### Table Stakes (Users Expect These)

Features users assume exist. Missing these = product feels incomplete.

| Feature | Why Expected | Complexity | Notes |
|---------|--------------|------------|-------|
| RSVP word-by-word display | Core mechanic of RSVP apps | LOW | Single word at fixed position, minimize eye movement |
| Adjustable WPM speed | Users need control over reading pace | LOW | Real-time speed adjustment (100-1000+ WPM range) |
| ORP/focal point highlighting | Standard RSVP optimization | LOW | Red/bold highlight at optimal recognition point |
| Paste text input | Most basic content source | LOW | Plain text paste from clipboard |
| Play/pause/seek controls | Basic playback controls expected | LOW | Standard media-style controls |
| Font size adjustment | Accessibility and preference | LOW | Multiple size options |
| Light/dark theme | Standard iOS expectation | LOW | Match system or manual toggle |
| Reading progress indicator | Users need to know where they are | LOW | Progress bar or percentage |
| Text history | Users want to revisit recent texts | MEDIUM | Save recently read texts, resume capability |
| Multiple file format support | Need to read from various sources | MEDIUM | PDF, ePub, TXT at minimum; DOC/RTF nice-to-have |

### Differentiators (Competitive Advantage)

Features that set the product apart. Not required, but valuable.

| Feature | Value Proposition | Complexity | Notes |
|---------|-------------------|------------|-------|
| Smart speed adjustment | Reduces fatigue, improves comprehension | MEDIUM | Auto-slow at punctuation, complex words, sentence ends |
| URL/web article import | Seamless reading from web | MEDIUM | Article extraction, remove clutter/ads |
| Chunk reading (multi-word) | Alternative to single-word, reduces cognitive load | LOW | Display 2-3 words at time vs single word |
| Comprehension check | Addresses main RSVP criticism | MEDIUM | Post-reading quiz to verify understanding |
| Focus mode integration | Aligns with "distraction-free" positioning | LOW | Fullscreen, hide all UI except text |
| Reading statistics/analytics | Gamification and progress motivation | MEDIUM | WPM over time, words/articles read, time spent |
| Offline-first architecture | Read anywhere without network | MEDIUM | All imported content stored locally |
| PDF annotation export | Preserve insights from reading | HIGH | Mark important sections during RSVP, export later |
| Smart anchoring (first letter bold) | ORP enhancement mentioned in project context | LOW | Better focal point than standard ORP |

### Anti-Features (Commonly Requested, Often Problematic)

Features that seem good but create problems.

| Feature | Why Requested | Why Problematic | Alternative |
|---------|---------------|-----------------|-------------|
| Social/sharing features | "Share progress with friends" | Feature bloat, privacy concerns, maintenance overhead | Keep focused on solo reading experience |
| Built-in library/store | "Browse books in app" | Content licensing complexity, storage bloat | Focus on import from external sources |
| Multiple reading modes (traditional scroll) | "Flexibility for users" | Dilutes core value prop, maintenance burden | Commit to RSVP-only, do one thing well |
| TTS/audio narration | "Listen while reading" | Conflicts with RSVP visual focus, complexity | Separate TTS apps exist, don't duplicate |
| AI summarization | "AI is trendy" | Expensive API calls, unreliable quality, scope creep | Users import pre-summarized content if needed |
| Gamification badges/streaks | "Increase engagement" | Creates obligation vs enjoyment, notification spam | Simple stats dashboard sufficient |
| Cloud sync | "Access everywhere" | Backend infrastructure, privacy, cost | iCloud sync simpler for iOS-only app |
| Web highlighting technique | "Like Outread's dual mode" | Complexity, strays from RSVP core | Pure RSVP is simpler, more focused |

## Feature Dependencies

```
[Reading History]
    └──requires──> [Text Import] (any source)

[Reading Statistics]
    └──requires──> [Session Tracking]
                       └──requires──> [Play/Pause Controls]

[Comprehension Check]
    └──requires──> [Text Parsing] (extract key points)
    └──requires──> [Reading History] (link quiz to content)

[Smart Speed Adjustment]
    └──requires──> [Text Parsing] (detect punctuation, word complexity)

[Resume Reading]
    └──requires──> [Reading History]
    └──requires──> [Progress Tracking]

[PDF Import] ──enhances──> [URL Import] (complementary sources)

[Offline Mode] ──enhances──> [All Import Features] (store content locally)

[Multiple Reading Modes] ──conflicts──> [Focus on RSVP] (dilutes value prop)
[Traditional Scrolling] ──conflicts──> [RSVP Training] (defeats purpose)
```

### Dependency Notes

- **Smart Speed Adjustment requires Text Parsing:** Need to analyze text structure (sentences, punctuation, word length/complexity) to intelligently slow down
- **Comprehension Check requires Text Parsing:** Must extract key concepts to generate relevant questions
- **Reading History enables Resume Reading:** Can't resume without storing progress state
- **Offline Mode enhances Import Features:** All import methods (paste, URL, PDF) benefit from local storage for offline access
- **Traditional Scrolling conflicts with RSVP Training:** Offering traditional reading mode undermines core RSVP training value proposition

## MVP Definition

### Launch With (v1)

Minimum viable product — what's needed to validate the concept.

- [x] RSVP word-by-word display with ORP highlighting — Core mechanic
- [x] Adjustable WPM speed (real-time) — User control essential
- [x] Paste text input — Simplest content source
- [x] Play/pause/seek controls — Basic playback
- [x] Font size adjustment — Accessibility baseline
- [x] Light/dark theme — iOS standard
- [x] Progress indicator — User orientation
- [x] Smart anchoring (bold first letters) — Differentiator from project context
- [x] Focus mode (fullscreen) — "Distraction-free" from project description

### Add After Validation (v1.x)

Features to add once core is working.

- [ ] URL/web article import — Major convenience, add when paste is proven
- [ ] PDF import — Mentioned in project context, add after URL
- [ ] Reading history — When users want to revisit content
- [ ] Smart speed adjustment — Once baseline RSVP works, optimize it
- [ ] Chunk reading (2-3 words) — Alternative mode after single-word validated
- [ ] Reading statistics — After usage patterns established
- [ ] Comprehension checks — Address criticism once reading experience solid

### Future Consideration (v2+)

Features to defer until product-market fit is established.

- [ ] Advanced file formats (ePub, DOC, RTF) — Add when demand proven
- [ ] Annotation/highlighting export — Complex, need user feedback first
- [ ] Integration with read-it-later services (Pocket, Instapaper) — Competitive feature, defer
- [ ] Multi-language support — Defer until English market validated
- [ ] iPad/Mac optimization — Start iPhone-focused

## Feature Prioritization Matrix

| Feature | User Value | Implementation Cost | Priority |
|---------|------------|---------------------|----------|
| RSVP word display with ORP | HIGH | LOW | P1 |
| Adjustable WPM | HIGH | LOW | P1 |
| Paste text input | HIGH | LOW | P1 |
| Play/pause/seek | HIGH | LOW | P1 |
| Smart anchoring (bold first letter) | MEDIUM | LOW | P1 |
| Focus mode | MEDIUM | LOW | P1 |
| Font size/theme | MEDIUM | LOW | P1 |
| URL import | HIGH | MEDIUM | P2 |
| PDF import | HIGH | MEDIUM | P2 |
| Smart speed adjustment | MEDIUM | MEDIUM | P2 |
| Reading history | MEDIUM | MEDIUM | P2 |
| Chunk reading | MEDIUM | LOW | P2 |
| Reading statistics | LOW | MEDIUM | P2 |
| Comprehension check | MEDIUM | MEDIUM | P2 |
| Advanced file formats | LOW | MEDIUM | P3 |
| Annotation export | LOW | HIGH | P3 |
| Service integrations | LOW | MEDIUM | P3 |

**Priority key:**
- P1: Must have for launch
- P2: Should have, add when possible
- P3: Nice to have, future consideration

## Competitor Feature Analysis

| Feature | Spritz/ReadQuick | Outread | Spreeder | Our Approach |
|---------|------------------|---------|----------|--------------|
| RSVP display | ✓ Single word, ORP red highlight | ✓ RSVP + highlighting guide | ✓ RSVP | Single word with smart anchoring (bold first letters) |
| Speed control | ✓ Up to 1000-1100 WPM | ✓ Adjustable WPM + chunk length | ✓ Variable speed | Real-time WPM with smart auto-adjustment |
| Content import | Spritz: web scan; ReadQuick: Pocket/Instapaper | Pocket/Instapaper integration | Paste, clipboard, file upload | Paste (v1), URL + PDF (v1.x) |
| File formats | ReadQuick: articles/web | ePub, PDF, DOC, RTF, TXT | Multiple formats | Start minimal (paste), add PDF/ePub later |
| Progress tracking | ReadQuick: statistics, estimated time | Reading stats, device sync | Detailed reports, analytics | Simple stats (v1.x), no sync overhead |
| Training/exercises | Minimal | 4 memory exercises (peripheral vision, chunking, etc) | N/A | Focus on reading, skip training exercises |
| Reading modes | RSVP only | RSVP + highlighting guide + traditional | RSVP only | RSVP only (chunk option later) |
| Comprehension | Lacking (research shows impaired comprehension) | Not mentioned | N/A | Post-reading quiz (v1.x) to address weakness |
| Platform | Spritz: Android; ReadQuick: iOS | iOS/iPadOS/macOS native | Web + mobile | iOS-first, iPhone focus |

## Sources

### Primary (HIGH confidence)
- [20 Best Speed Reading Apps 2026 - Speed Reading Lounge](https://www.speedreadinglounge.com/speed-reading-apps)
- [Best Speed Reading Apps - The Top 9 of 2026](https://www.speedreadingtechniques.org/best-speed-reading-apps)
- [How to Speed Read on iPhone (17 Best Apps) - Iris Reading](https://irisreading.com/how-to-speed-read-on-iphone-17-best-apps/)

### Secondary (MEDIUM confidence)
- [Speed Reading Apps: 10 Best Free and Paid Tools - Brighterly](https://brighterly.com/blog/speed-reading-apps/)
- [Outread — Speed Reading App for iPhone, iPad & Mac](https://outreadapp.com/)
- [Reedy. Intelligent reader](https://reedy-reader.com/)
- [Spreeder - Speed Reading App & Software](https://www.spreeder.com/)

### Tertiary (LOW confidence - research findings)
- [Modern Speed-Reading Apps Do Not Foster Reading Comprehension - PubMed](https://pubmed.ncbi.nlm.nih.gov/29461715/)
- [Rapid serial visual presentation in reading: The case of Spritz - ScienceDirect](https://www.sciencedirect.com/science/article/abs/pii/S0747563214007663)
- [3 Speed Reading Techniques Examined: Do They Actually Work?](https://collegeinfogeek.com/speed-reading-techniques-examined/)
- [How to avoid feature bloat - airfocus](https://airfocus.com/blog/how-to-avoid-feature-bloat/)

---
*Feature research for: iOS RSVP Speed Reading Trainer*
*Researched: 2026-01-18*
