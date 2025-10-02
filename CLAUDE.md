# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a SwiftUI iOS application implementing the Red Bead Experiment by Stephen Deming. The app allows users to simulate quality control experiments by tracking workers' performance (white bead counts) across multiple days and visualizing the results with statistical control charts.

## Build and Run

- **Open project**: Open `Red Bead Experiment/Red Bead Experiment.xcodeproj` in Xcode
- **Build**: ⌘B in Xcode or use Xcode's Product → Build menu
- **Run**: ⌘R in Xcode or use Xcode's Product → Run menu
- **Tests**: ⌘U in Xcode to run both unit tests and UI tests

Note: This project requires Xcode and cannot be built via command-line `xcodebuild` without full Xcode installation.

## Architecture

### Data Model (Models/)
- **ExperimentData**: ObservableObject that manages the entire experiment state
  - Holds array of workers
  - Calculates aggregate statistics (total beads, averages)
  - Computes statistical control limits (mean ± 3σ) for control charts
- **Worker**: Identifiable struct representing a worker
  - Stores name and daily bead counts array
  - Computes individual worker averages

### Views Architecture (Views/)
The app uses a TabView with two main screens:

1. **WorkerListView**: Displays all workers with their statistics
   - Shows each worker's average bead count
   - Navigates to WorkerDetailView for individual worker history

2. **ControlChartView**: Statistical control chart using SwiftUI Charts framework
   - Line plots for each worker's daily performance
   - Control limit lines (mean, UCL, LCL) rendered as dashed RuleMarks
   - Empty state when no workers exist

### Modal Sheets
- **AddWorkerView**: Creates new workers
- **DailyEntryView**: Records daily bead counts for all workers simultaneously
- **WorkerDetailView**: Shows detailed history for a single worker

### State Management
The app uses SwiftUI's @StateObject/@ObservedObject pattern with ExperimentData as the single source of truth. ExperimentData is created in ContentView and passed down to child views.

## Key Implementation Details

- Uses SwiftUI Charts framework for control chart visualization
- Control limits calculated using ±3 standard deviations from mean
- Lower control limit clamped to 0 (cannot have negative beads)
- Workers identified by UUID for proper SwiftUI list management
- Daily entry allows batch data entry for all workers at once
