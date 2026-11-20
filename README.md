# 🏖️ Sand Adventure – iOS Native (Swift 5.10 + SwiftUI + SpriteKit)

> **Zero Ads • 100% Offline • Child-Friendly • Dual-Native Architecture**  
> Inspired by the classic physics-based sand digging genre (*Sand Balls*).

---

## 🌟 Key Features

- **🎮 Dual-Layer Architecture**:
  - **SwiftUI** for high-contrast, child-friendly cartoon UI (Main Menu, 100 Level Select, Settings, HUD).
  - **SpriteKit 2D Game Engine** (`SKScene` + `SKPhysicsWorld`) for 60+ FPS liquid ball cascade physics and real-time sand terrain carving.
- **🏝️ 100 Unique Levels Across 10 Themed Worlds**:
  1. 🏖️ **Sunny Beach (1–10)**: Tutorial ramps, gentle curves, intro to 2X gates, mini windmills, pinball mushroom.
  2. 🍬 **Candy Dunes (11–20)**: Y-split fork routes, double multiplier gates, teleport portals.
  3. 🌿 **Emerald Meadow (21–30)**: Motorized rotating paddles with alternating directions (+45° / -45°).
  4. 🍧 **Ice Cream Peak (31–40)**: Multi-bumper pinball cascades with high restitution (1.8x).
  5. 🌈 **Rainbow Canyon (41–50)**: Multiplier cascades (2X / 3X) with mega ball swarms (100+ rainbow balls).
  6. 💣 **TNT Quarry (51–60)**: Explosive TNT toy crates with blast craters and celebration star bursts.
  7. 🎡 **Carnival Park (61–70)**: Dual rotating wheels, high-speed chutes, bouncy bumpers.
  8. 🏰 **Sand Castle (71–80)**: Royal castle chambers, secret teleport shortcuts.
  9. 🌌 **Space Portals (81–90)**: Interstellar criss-crossing portal networks.
  10. 👑 **Master Island (91–100)**: Grand multi-stage puzzles combining all interactive mechanics.
- **✨ Interactive Gameplay Elements**:
  - **Multiplier Gates (2X / 3X)**: Clones passing balls with momentum and neon glow.
  - **Portal Pairs (Teleporters)**: Teleports balls from cyan entrance to orange exit with a speed boost.
  - **Bouncy Bumpers**: Pinball mushroom caps that pulse and launch balls outward.
  - **TNT Toy Crates**: Explodes on contact, blows open a large crater in the sand terrain with star burst.
  - **Rotating Windmill Paddles**: Continuous motor speed deflecting balls.
  - **Dormant White Ball Infection**: Contacting colored balls awakens dormant balls with playful pop sounds.
- **🎵 CD-Quality Audio Experience**:
  - 19 high-fidelity audio tracks (44.1kHz 16-bit PCM WAV).
  - Dynamic world-themed background music (`bgm_gameplay_kids.wav`, `bgm_candy_world.wav`, `bgm_jungle_fun.wav`, `bgm_icecream_waltz.wav`).
  - Joyful victory fanfares, friendly truck horn, and kids cheering audio.
- **🛡️ 100% Zero Ads & Child Safe**:
  - No AdMob, Unity Ads, AppLovin, or third-party tracking SDKs.
  - No internet connection required — runs completely offline.
  - No in-app purchases or account requirements.

---

## 🛠️ Tech Stack & Requirements

- **Language**: Swift 5.10+
- **Minimum iOS Version**: iOS 17.0+
- **Supported Devices**: iPhone & iPad (Portrait)
- **UI Framework**: SwiftUI
- **Game & Physics Engine**: SpriteKit (`SKScene`, `SKPhysicsWorld`, `SKCropNode`)
- **IDE**: Xcode 15.3+ / Xcode 16+
- **Package Management**: Xcode Project (`SandAdventure.xcodeproj`) & Swift Package Manager (`Package.swift`)

---

## 🚀 Getting Started on macOS

### 1. Clone the repository
```bash
git clone https://github.com/minhlai1123/sandball-ios.git
cd sandball-ios
```

### 2. Open in Xcode
Simply double-click:
```
SandAdventure.xcodeproj
```
or run from terminal:
```bash
xed .
```

### 3. Build & Run
- Select any iOS Simulator (e.g. **iPhone 15 Pro** / **iPhone 16**) or your connected iPhone/iPad.
- Press **`Cmd + R`** (or click the **▶ Play** button in Xcode).
- The app will compile and launch immediately!

### 4. Run Unit Tests
- Press **`Cmd + U`** in Xcode to execute `SandAdventureTests`.
- All 100 level files integrity tests and physics tests will execute and pass.

---

## 📁 Project Structure

```
.
├── SandAdventure.xcodeproj/
│   ├── project.pbxproj                       # Xcode project file linking all sources & assets
│   ├── project.xcworkspace/contents.xcworkspacedata
│   └── xcshareddata/xcschemes/SandAdventure.xcscheme  # Shared build & run scheme
├── Package.swift                             # Swift Package Manager manifest
├── SandAdventure/
│   ├── App/
│   │   ├── SandAdventureApp.swift            # SwiftUI App entry point
│   │   └── ContentView.swift                 # Root navigation coordinator
│   ├── UI/
│   │   ├── MainMenuView.swift                # Kawaii cartoon mascot main menu
│   │   ├── LevelSelectView.swift             # 100 level select with 10 world tabs
│   │   ├── GameView.swift                    # SpriteView SwiftUI integration
│   │   ├── GameHUDView.swift                 # In-game HUD & victory celebration dialog
│   │   └── SettingsView.swift                # Audio toggles & kid-safety guarantee
│   ├── Gameplay/
│   │   ├── GameScene.swift                   # SpriteKit 2D Scene with interactive mechanics
│   │   ├── SceneManager.swift                # Game state management
│   │   └── AudioManager.swift                # AVAudioPlayer audio manager
│   ├── Physics/
│   │   ├── CollisionCategories.swift         # Physics category bitmasks
│   │   ├── SpatialGrid.swift                 # Spatial partitioning grid
│   │   └── BallNode.swift                    # Kawaii animated cartoon ball nodes
│   ├── Terrain/
│   │   ├── SandTerrainNode.swift             # Real-time sand terrain carving node
│   │   └── CapsuleCarver.swift               # Smooth capsule carving algorithm
│   ├── Data/
│   │   ├── LevelModel.swift                  # JSON data models & decoders
│   │   ├── LevelRepository.swift             # Level repository loader
│   │   ├── ProgressManager.swift             # Local device persistence
│   │   └── WorldTheme.swift                  # 10 World color palettes & audio themes
│   ├── Resources/
│   │   ├── Info.plist                        # App configuration & permissions
│   │   ├── Levels/                           # 100 level definitions (level_1.json to level_100.json)
│   │   └── Audio/                            # 19 CD-quality WAV sound effects & music tracks
│   └── Tests/
│       ├── LevelParsingTests.swift           # Automated parsing tests for all 100 levels
│       └── PhysicsFoundationTests.swift      # Physics & math unit tests
└── README.md
```

---

## 📜 License
Developed as a dual-native educational & casual gaming project. Free for personal and educational use. Zero tracking, zero ads.
