# Red Bead Experiment

A SwiftUI iOS application implementing the Red Bead Experiment by W. Edwards Deming.

## Overview

The Red Bead Experiment is a quality management demonstration that illustrates the concept of variation in processes. This app allows you to:

- Track multiple workers and their daily white bead counts
- Visualize performance data using statistical control charts
- Calculate control limits (mean ± 3σ) to understand natural process variation
- Record and analyze data across multiple days

## Requirements

- iOS 16.0+
- Xcode 14.0+
- Swift 5.7+

## Getting Started

1. Open `Red Bead Experiment/Red Bead Experiment.xcodeproj` in Xcode
2. Select your target device or simulator
3. Build and run (⌘R)

## Features

- **Worker Management**: Add workers and track their individual performance
- **Daily Entry**: Record bead counts for all workers simultaneously
- **Control Charts**: Visualize worker performance with statistical control limits
- **Worker Details**: View detailed history for individual workers
- **Reset**: Clear all data to start a new experiment

## Architecture

Built with SwiftUI and Swift Charts, using an ObservableObject pattern for state management. See [CLAUDE.md](CLAUDE.md) for detailed architecture information.
