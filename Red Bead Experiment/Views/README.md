# Red Bead Experiment

[![iOS](https://img.shields.io/badge/iOS-16.0+-blue.svg)](https://developer.apple.com/ios/)
[![iPadOS](https://img.shields.io/badge/iPadOS-16.0+-blue.svg)](https://developer.apple.com/ipados/)
[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0+-green.svg)](https://developer.apple.com/xcode/swiftui/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A comprehensive SwiftUI application that implements W. Edwards Deming's famous Red Bead Experiment for teaching statistical process control principles. This app serves as both an educational tool and a practical demonstration of modern iOS development practices.

## 🎯 Overview

The Red Bead Experiment is a powerful demonstration tool used to illustrate the concepts of statistical process control, variation, and the futility of ranking and rewarding individual performance in a system where outcomes are largely determined by the system itself rather than individual effort.

This implementation brings Deming's timeless lesson to the digital age with:
- Modern SwiftUI interface following Apple's design guidelines
- Comprehensive accessibility support
- Real-time statistical calculations and visualizations
- Cross-platform support for iPhone and iPad

## ✨ Features

### 📊 Statistical Analysis
- **Real-time Control Charts**: Interactive charts showing worker performance with statistical control limits
- **Process Statistics**: Mean, standard deviation, and control limit calculations
- **Trend Analysis**: Visual representation of performance over time
- **Data Export**: Share experiment results and insights

### 👥 Worker Management
- **Dynamic Worker Addition**: Add participants during the experiment
- **Individual Tracking**: Detailed performance history for each worker
- **Batch Data Entry**: Efficient input for daily bead counts
- **Worker Profiles**: Comprehensive statistics for each participant

### 💾 Data Persistence
- **Automatic Saving**: All data is automatically saved between sessions
- **JSON Storage**: Robust data storage with error handling
- **Data Integrity**: Comprehensive validation and error recovery

### ♿ Accessibility Excellence
- **VoiceOver Support**: Full screen reader compatibility
- **Dynamic Type**: Respects user text size preferences
- **High Contrast**: Optimized for visual accessibility
- **Keyboard Navigation**: Complete keyboard support for power users

### 📱 Cross-Platform Design
- **Adaptive Layouts**: Optimized for all iPhone and iPad sizes
- **Orientation Support**: Full portrait and landscape compatibility
- **Size Classes**: Responsive design that adapts to available space
- **Dark Mode**: Native dark mode support

## 📸 Screenshots

*Coming soon - Add screenshots showing the main features of the app*

## 🛠 Technical Requirements

- **iOS**: 16.0+ / iPadOS 16.0+
- **Xcode**: 15.0+
- **Swift**: 5.9+
- **Frameworks**: SwiftUI, Swift Charts, Foundation

## 🚀 Installation & Setup

### Method 1: Direct Installation
1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/red-bead-experiment.git
   cd red-bead-experiment
   ```

2. Open the project in Xcode:
   ```bash
   open "Red Bead Experiment.xcodeproj"
   ```

3. Select your target device or simulator

4. Build and run using `Cmd+R`

### Method 2: Quick Start
1. Download the latest release from the [Releases](../../releases) page
2. Extract and open the project file
3. Build and run in Xcode

## 🏗 Architecture

The app follows modern iOS development best practices with a clear separation of concerns:

```
Red Bead Experiment/
├── 📁 Models/              # Data models and business logic
│   ├── Worker.swift        # Worker data model with calculations
│   └── ExperimentData.swift # Central data management
├── 📁 Views/               # SwiftUI view components
│   ├── ContentView.swift   # Main navigation and coordination
│   ├── ControlChartView.swift # Statistical chart visualization
│   ├── WorkerListView.swift # Worker management interface
│   ├── DailyEntryView.swift # Batch data entry form
│   ├── WorkerDetailView.swift # Individual worker details
│   └── AddWorkerView.swift # Worker creation form
└── 📁 Tests/              # Comprehensive test suite
    └── Red_Bead_ExperimentTests.swift
```

### 🏛 Design Patterns

- **MVVM Architecture**: Clear separation between views and business logic
- **ObservableObject**: Reactive data binding with SwiftUI
- **Dependency Injection**: Testable and modular component design
- **Protocol-Oriented Programming**: Flexible and extensible interfaces

## 📊 Key Components

### 🔢 Data Models

#### `Worker`
Represents an experiment participant with comprehensive statistics:
- **Properties**: Unique ID, name, daily bead counts
- **Computed Properties**: Average performance, total beads, participation days
- **Features**: Codable for persistence, Identifiable for SwiftUI

#### `ExperimentData`
Central data management with statistical calculations:
- **Worker Management**: Add, remove, and update participants
- **Statistical Methods**: Control limits, process statistics, trend analysis
- **Data Persistence**: Automatic JSON serialization with error handling

### 🎨 User Interface

#### `ControlChartView`
Professional statistical process control chart:
- **Swift Charts Integration**: Modern, interactive visualizations
- **Control Limits**: Mean ± 3σ statistical boundaries
- **Accessibility**: Comprehensive screen reader support
- **Adaptive Design**: Responsive across all device sizes

#### `DailyEntryView`
Efficient batch data entry interface:
- **Smart Layout**: Grid on iPad, list on iPhone
- **Keyboard Navigation**: Previous/next field traversal
- **Input Validation**: Real-time error checking and feedback
- **Focus Management**: Intuitive input flow

## 🧮 Statistical Calculations

The app implements industry-standard statistical process control calculations:

### Control Limits
- **Upper Control Limit (UCL)**: μ + 3σ
- **Lower Control Limit (LCL)**: max(μ - 3σ, 0)
- **Center Line**: Process mean (μ)

### Process Statistics
- **Mean (μ)**: Average of all data points
- **Standard Deviation (σ)**: Measure of process variation
- **Range**: Difference between maximum and minimum values
- **Process Capability**: Statistical measures of process performance

### Implementation Details
```swift
func calculateControlLimits() -> (mean: Double, upperLimit: Double, lowerLimit: Double) {
    // Statistical calculations using population methods
    // Handles edge cases and ensures non-negative lower limits
}
```

## ♿ Accessibility Features

The app includes comprehensive accessibility support:

### Screen Reader Support
- **VoiceOver Labels**: Descriptive labels for all interface elements
- **Accessibility Hints**: Contextual help for complex interactions
- **Semantic Grouping**: Logical organization of related content

### Visual Accessibility
- **Dynamic Type**: Respects user text size preferences
- **High Contrast**: Optimized color schemes for visibility
- **Color Independence**: Information not dependent on color alone

### Motor Accessibility
- **Large Touch Targets**: Generous button and control sizes
- **Keyboard Navigation**: Full keyboard support for all functions
- **Voice Control**: Compatible with voice navigation features

## 🧪 Testing

The project includes a comprehensive test suite using the modern Swift Testing framework:

### Test Coverage
- **Unit Tests**: All business logic and calculations
- **Integration Tests**: Data persistence and model interactions
- **Edge Case Tests**: Boundary conditions and error scenarios
- **Performance Tests**: Statistical calculation efficiency

### Running Tests
```bash
# Run all tests
xcodebuild test -scheme "Red Bead Experiment" -destination "platform=iOS Simulator,name=iPhone 15"

# Run specific test suite
xcodebuild test -scheme "Red Bead Experiment" -destination "platform=iOS Simulator,name=iPhone 15" -only-testing:Red_Bead_ExperimentTests/WorkerTests
```

### Test Organization
- **Suites**: Logical grouping of related tests
- **Descriptive Names**: Clear test descriptions for maintainability
- **Comprehensive Coverage**: All critical paths and edge cases

## 🤝 Contributing

We welcome contributions to improve the Red Bead Experiment app! Please see our [Contributing Guidelines](CONTRIBUTING.md) for detailed information about:

- **Code Style**: Swift coding standards and best practices
- **Development Setup**: Local development environment configuration
- **Pull Request Process**: How to submit improvements
- **Issue Reporting**: Bug reports and feature requests

### Quick Contribution Guide
1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes following our coding standards
4. Add tests for new functionality
5. Run the test suite to ensure everything passes
6. Commit your changes: `git commit -m 'Add amazing feature'`
7. Push to your branch: `git push origin feature/amazing-feature`
8. Open a Pull Request with a detailed description

## 📚 Educational Context

### Learning Objectives
The Red Bead Experiment demonstrates several key principles:

1. **Variation is Inherent**: All processes contain natural variation
2. **System vs. Individual**: Performance is largely determined by the system
3. **Statistical Thinking**: Data-driven decision making is essential
4. **Process Improvement**: Focus on improving the system, not blaming individuals

### Target Audience
This app serves as an educational tool for:
- **Quality Management Courses**: University and professional education
- **Six Sigma Training**: Lean and statistical process control education
- **Management Development**: Leadership and systems thinking programs
- **Corporate Training**: In-house quality and process improvement initiatives

### Usage Scenarios
- **Classroom Demonstrations**: Interactive learning experiences
- **Workshop Activities**: Hands-on statistical exercises
- **Self-Paced Learning**: Individual exploration of quality concepts
- **Team Building**: Collaborative understanding of process variation

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **W. Edwards Deming** for creating the Red Bead Experiment and advancing statistical thinking
- **The Quality Community** for decades of process improvement innovation
- **Apple** for SwiftUI and Swift Charts frameworks that make this app possible
- **Open Source Community** for inspiration and best practices

## 📞 Support & Contact

- **Issues**: Report bugs and request features in [GitHub Issues](../../issues)
- **Discussions**: Join conversations in [GitHub Discussions](../../discussions)
- **Documentation**: Comprehensive guides in the [Wiki](../../wiki)
- **Security**: Report security issues to [security@example.com](mailto:security@example.com)

## 🗺 Roadmap

### Upcoming Features
- **Data Export**: CSV and PDF report generation
- **Multiple Experiments**: Support for running concurrent experiments
- **Historical Analysis**: Long-term trend analysis and reporting
- **Team Collaboration**: Multi-user experiment management

### Platform Expansion
- **macOS Version**: Native Mac application
- **Apple Watch**: Quick data entry and notifications
- **Web Version**: Browser-based experiment management

---

**Made with ❤️ and SwiftUI**

*Bringing Deming's timeless quality principles to the modern digital age.*