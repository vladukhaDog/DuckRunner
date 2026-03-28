# Routka

Idea: **German Zykin**
iOS Implementation: **Vladislav Permyakov**

Routka is an iOS route-tracking application built with SwiftUI, Core Location, MapKit, and Core Data. The app records movement as timestamped track points, supports replay-oriented runs, stores measured attempts separately from regular history, and exposes imported tracks alongside locally recorded sessions.

## Technical Overview

- SwiftUI-first application with an `@main` entry point in `RoutkaApp`.
- Protocol-oriented service layer composed by a central `DependencyManager`, leveraging dependency injection.
- Observable view models drive presentation state and coordinate async work.
- Core Data repositories persist domain models and publish storage mutations to the UI leveraging Observable pattern.
- Map, replay, navigation, caching, and file import/export concerns are split into dedicated services.

## Architecture

The codebase follows a pragmatic MVVM-style structure with explicit dependency injection:

- `Views/` contains SwiftUI screens, reusable view components, and feature-specific view models.
- `Logic/` contains services, repositories, navigation, replay coordination, settings, file handling, and map utilities.
- `Model/` contains domain entities such as `Track`, `TrackPoint`, `MeasuredTrack`, replay modes, and list-state abstractions.
- `Helpers/` contains formatting, conversion, geometry, and model-construction helpers.

At runtime, `RoutkaApp` creates a production `DependencyManager` and passes it into feature entry points. Each view model depends on protocols rather than concrete implementations, which keeps previews, mocks, and tests isolated from production services.

## Core Runtime Flow

1. `LocationService` wraps `CLLocationManager` and publishes authorization changes and live location updates.
2. `BaseMapViewModel` subscribes to those publishers and transforms raw locations into domain `TrackPoint` values.
3. `TrackRecordingService` manages the in-memory recording session, auto-stop policies, and recording progress.
4. Completed tracks are persisted through `TrackRepository` or `MeasuredTrackRepository`.
5. Repository actions are broadcast through Combine subjects so list-oriented view models can update incrementally without reloading the whole UI tree, Observable pattern.

## Modularity

The project is organized around separable responsibilities instead of a single monolithic app layer:

- Recording: `TrackRecordingService` owns ephemeral session state.
- Location: `LocationService` abstracts Core Location access.
- Persistence: `TrackRepository` and `MeasuredTrackRepository` isolate Core Data storage.
- Replay: `TrackReplayCoordinator` and `TrackReplayValidator` coordinate replay selection and checkpoint logic.
- Navigation: `Router` and `TabRouter` decouple navigation state from view composition.
- File I/O: `TrackFileService` handles import/export flows for tracks.
- Map rendering: snapshot generation and snippet caching are isolated behind dedicated protocols.

This separation allows production and mock dependency graphs to coexist cleanly. `ReleaseDependencies.swift` builds the live graph, while `MockDependencies.swift` provides preview/test doubles for SwiftUI previews and isolated feature work.

## Persistence Model

Persistent data is stored with Core Data using the `CoreDataStorage` model:

- `Track` represents a recorded route as an ordered collection of `TrackPoint` values.
- `MeasuredTrack` stores tracks captured under specific measurement policies such as distance or speed goals.
- Repositories use a background context and convert between DTOs and domain models.
- Storage layers publish create, update, and delete events so UI state can stay reactive.

## Engineering Characteristics

- Modern Swift features such as `@Observable`, actors, and `async/await`.
- Protocol-backed boundaries for dependency inversion and mockability.
- Combine-based event propagation where storage and location streams need fan-out.
- Clear split between transient runtime state and persisted historical data.
- Preview-friendly architecture through mock dependency composition.

## Repository Structure

```text
Routka/
  Routka/
    Helpers/
    Logic/
      DependencyManager/
      LocationService/
      Navigation/
      Storage/
      TrackService/
    Model/
    Views/
```

Routka is structured to keep UI, domain logic, persistence, and infrastructure replaceable, which makes it suitable for iterative feature development around route recording, replay workflows, and track analysis.
