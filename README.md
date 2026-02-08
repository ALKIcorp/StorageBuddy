# Storage Buddy

A macOS utility that scans local storage in **read-only** mode and helps you understand what is taking space. Run a fresh scan each time, explore results in a dashboard or tree view, and narrow down files with practical filters.

## Highlights
- Read-only scanning (no deletes, moves, or writes)
- Fresh scans every session (no caching)
- Dashboard summary with largest files and folders
- Tree view with size rollups per folder
- Filters for size, type, date, path includes/excludes, tags, and search
- Cancelable scans with live progress

## How It Works
1. Pick a volume or folder to scan.
2. Storage Buddy enumerates the filesystem, reads metadata, and builds a tree.
3. Results appear in two tabs: **Dashboard** and **Tree**.
4. Filters update the results instantly without rescanning.

## Filters
- **Size (MB):** Min and max size thresholds
- **Types:** File extension (e.g. `jpg`) or UTI (e.g. `public.movie`)
- **Date Range:** Modified date from/to
- **Path Includes / Excludes:** Comma-separated substrings
- **Tags:** Finder tags (comma-separated)
- **Search:** Name or path substring

## Requirements
- macOS 14.0+
- Xcode 15+ (Swift 5)

## Build & Run
Open the project in Xcode:
- `StorageBuddy.xcodeproj`

Or build from the command line:
```bash
xcodebuild -project StorageBuddy.xcodeproj -scheme StorageBuddy -configuration Debug
```

If you prefer to regenerate the Xcode project using `project.yml`, use XcodeGen (optional):
```bash
xcodegen generate
```

## Project Structure
- `StorageBuddy/App`: App entry point and coordinator
- `StorageBuddy/Presentation`: SwiftUI views and view models
- `StorageBuddy/Domain`: Core models and use cases
- `StorageBuddy/Data`: File scanning and metadata loading
- `StorageBuddy/Core`: Utilities and extensions

## Privacy & Safety
Storage Buddy uses only local filesystem metadata and runs entirely on-device. It does not modify files, create caches, or upload data.

## Status
Early development. Feedback and contributions are welcome.

## License
No license specified yet.
