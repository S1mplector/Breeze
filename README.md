# Breeze

A lightweight, distraction-free macOS journaling app built with Swift and SwiftUI.

## Architecture

This repository follows a hexagonal architecture with strict separation of concerns:

- `Sources/BreezeDomain`: Domain entities and value objects.
- `Sources/BreezePorts`: Inbound and outbound ports (protocols).
- `Sources/BreezeApplication`: Use case implementations.
- `Sources/BreezeAdapters`: Infrastructure adapters (persistence, clock, UUID).
- `Sources/BreezeUI`: SwiftUI views and view models (inbound adapter).
- `Sources/BreezeApp`: Composition root and app entry point.

## Running

- `swift run BreezeApp`

If you prefer Xcode, open the package and run the `BreezeApp` executable target.
