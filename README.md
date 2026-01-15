# BrewBar

A native macOS menubar app for managing Homebrew services.

![macOS](https://img.shields.io/badge/macOS-13.0+-blue)
![Swift](https://img.shields.io/badge/Swift-5.9+-orange)
![License](https://img.shields.io/badge/License-MIT-green)

## Features

- **Service Management** - View all Homebrew services at a glance
- **One-Click Controls** - Start, stop, and restart services instantly
- **Bulk Actions** - Start or stop all services at once
- **Auto-Refresh** - Services status updates every 30 seconds
- **Visual Indicators** - Color-coded status (running/stopped/error)
- **Toast Notifications** - Feedback for all actions
- **Launch at Login** - Option to start BrewBar automatically
- **Native macOS** - Built with SwiftUI, feels right at home

## Screenshots

```
┌─────────────────────────────────┐
│ BrewBar              ↻  ▶  ■   │
├─────────────────────────────────┤
│ ● postgresql@17              ▶■↻│
│ ● redis                      ▶■↻│
│ ○ mysql                      ▶■↻│
│ ○ nginx                      ▶■↻│
├─────────────────────────────────┤
│ ⚙                        Quit  │
└─────────────────────────────────┘
```

## Requirements

- macOS 13.0 (Ventura) or later
- [Homebrew](https://brew.sh) installed

## Installation

### Homebrew (Recommended)

```bash
brew install omkarkirpan/tap/brewbar
brewbar
```

### Build from Source

```bash
git clone https://github.com/omkarkirpan/BrewBar.git
cd BrewBar/BrewBar
swift build -c release
.build/release/BrewBar
```

### Download .app Bundle

```bash
git clone https://github.com/omkarkirpan/BrewBar.git
cd BrewBar/BrewBar
./scripts/build-app.sh
```

Then either:
- **Install to Applications:** `cp -r BrewBar.app /Applications/`
- **Run directly:** `open BrewBar.app`

See [macOS Security Notice](#macos-security-notice) if downloading pre-built releases.

## macOS Security Notice

BrewBar is distributed unsigned to keep it free and open-source.

**If downloading the .app directly:**
- macOS will show "Developer cannot be verified"
- Right-click the app → Open → Open (first time only)
- Or: System Settings → Privacy & Security → Open Anyway

**Recommended:** Install via Homebrew or build from source to avoid this entirely

## Usage

1. **Launch** - Open BrewBar from Applications or run directly
2. **Click** - Click the ☕ mug icon in your menubar
3. **Manage** - View services and use the action buttons:
   - ▶ Start service
   - ■ Stop service
   - ↻ Restart service
4. **Settings** - Click the ⚙ gear icon for:
   - Launch at Login toggle
   - About & author info

## CLI Commands

BrewBar supports command-line arguments:

```bash
# Show version
BrewBar --version
BrewBar -v

# Show help
BrewBar --help
BrewBar -h
```

When launched without arguments, BrewBar runs as a menubar application.

**Note:** On first launch, BrewBar automatically enables "Launch at Login". You can disable this in Settings.

## Project Structure

```
BrewBar/
├── Package.swift
├── BrewBar/
│   ├── BrewBarApp.swift         # App entry point
│   ├── Models/
│   │   ├── ServiceStatus.swift  # Service status enum
│   │   └── BrewService.swift    # Service model
│   ├── Services/
│   │   ├── ShellExecutor.swift       # Brew command execution
│   │   ├── BrewOutputParser.swift    # Parse brew output
│   │   ├── BrewServiceManager.swift  # Service state management
│   │   ├── ToastManager.swift        # Notifications
│   │   ├── PollingManager.swift      # Auto-refresh
│   │   └── LaunchAtLoginManager.swift # Login item
│   └── Views/
│       ├── MainPanel.swift      # Main container
│       ├── HeaderView.swift     # Header with actions
│       ├── ServiceListView.swift # Service list
│       ├── ServiceRowView.swift  # Individual service row
│       ├── ToastView.swift      # Toast notifications
│       └── SettingsView.swift   # Settings & About
└── scripts/
    └── build-app.sh             # Build .app bundle
```

## Development

```bash
# Build debug version
swift build

# Run debug version
.build/debug/BrewBar

# Build release .app bundle
./scripts/build-app.sh

# Clean build
swift package clean
```

## Tech Stack

- **Swift 5.9+** - Modern Swift with async/await
- **SwiftUI** - Native macOS UI framework
- **MenuBarExtra** - macOS 13+ menubar API
- **ServiceManagement** - Login item management
- **Actor isolation** - Thread-safe shell execution

## Author

**Omkar Kirpan**
- GitHub: [github.com/omkarkirpan](https://github.com/omkarkirpan)
- Website: [omkarkirpan.com](https://www.omkarkirpan.com)

## License

MIT License - see [LICENSE](LICENSE) file
