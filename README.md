# 🎵 SwiftAVPlayer

An iOS media player app built with **AVFoundation**. This app demonstrates how to use Apple's AVFoundation framework to build a fully functional audio/video player with a modern SwiftUI or UIKit-based interface.

## ✨ Features

- [x] Play local or remote media (audio/video)
- [x] Play/Pause
- [x] Seek, Skip, Rewind
- [x] Playback speed control
- [x] Real-time progress tracking
- [ ] Background audio playback
- [ ] Lock screen and Control Center integration (Now Playing Info)
- [ ] Subtitle support (for supported formats)
- [ ] Picture-in-Picture (optional)
- [ ] CocoaPods or SPM Release

### Additional Features
Added so I could try something I’ve never done before.
- [ ] TDD - [Meet Swift Testing (WWDC24)](https://developer.apple.com/videos/play/wwdc2024/10179)
- [ ] Commit Convention

## Technologies Used

- SPM - SnapKit, SwiftLint
- Swift (Swift 6)
- AVFoundation
- Combine (for state bindings)
- Swift Concurrency
- MPNowPlayingInfoCenter
- AVAudioSession


## 🚀 Getting Started

1. Clone the repository:

```bash
https://github.com/hobin-han/SwiftAVPlayer.git
```

2. Open with Xcode:

```
open SwiftAVPlayer.xcodeproj
```

3. Build and run on a real device or simulator.

---

## ✍️ Commit Convention
| Type         | Description                                                                     |
| ------------ | ------------------------------------------------------------------------------- |
| **feat**     | A new feature                                                                   |
| **fix**      | A bug fix                                                                       |
| **docs**     | Documentation changes                                                           |
| **style**    | Code formatting or style fixes (no functional changes)                          |
| **refactor** | Code refactoring (neither a bug fix nor a new feature)                          |
| **test**     | Adding or updating tests                                                        |
| **chore**    | Miscellaneous chores (build scripts, package manager configs, etc.)             |
| **ci**       | Continuous Integration configuration changes                                    |
| **build**    | Changes that affect build system or external dependencies (e.g. SPM, CocoaPods) |
| **perf**     | A code change that improves performance                                         |
