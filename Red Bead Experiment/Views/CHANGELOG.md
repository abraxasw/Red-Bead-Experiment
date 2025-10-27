# Changelog

All notable changes to the Red Bead Experiment app will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Comprehensive code documentation with detailed inline comments
- Enhanced test suite with organized test suites and edge case coverage
- Improved accessibility support throughout all views
- Better keyboard navigation in daily entry view
- Process statistics calculation method in ExperimentData
- Worker management methods (add, remove, update) in ExperimentData
- Focus state management in AddWorkerView for better user experience
- Comprehensive error handling in DailyEntryView with detailed error messages

### Changed
- **BREAKING**: Fixed ControlChartView to use correct tuple type instead of non-existent ControlLimits type
- Reorganized code structure with proper MARK comments for better organization
- Enhanced string formatting throughout the app using proper String(format:) syntax
- Improved chart visualization with enhanced accessibility labels and symbols
- Updated toolbar items with comprehensive accessibility hints
- Refactored DailyEntryView with better separation of concerns and improved layout handling

### Fixed
- Fixed compilation errors in ControlChartView related to incorrect type usage
- Fixed string interpolation formatting issues with specifier syntax
- Corrected accessibility hint calculation in ControlChartView
- Fixed potential negative control limit issues with proper clamping

### Technical Improvements
- Applied consistent Swift coding standards across all files
- Added comprehensive inline documentation for all public APIs
- Improved code organization with logical grouping using MARK comments
- Enhanced test coverage with organized test suites and edge cases
- Better error handling and user feedback mechanisms
- Improved type safety and null safety throughout the codebase

### Documentation
- Updated README.md with comprehensive project documentation
- Enhanced CONTRIBUTING.md with detailed development guidelines
- Added comprehensive code comments explaining business logic
- Documented all public methods and properties with usage examples

## [1.0.0] - Initial Release

### Added
- Initial implementation of Red Bead Experiment iOS app
- Worker management with add/delete functionality
- Daily bead count entry with validation
- Statistical control charts using Swift Charts
- Data persistence with UserDefaults
- Comprehensive unit test suite
- Full accessibility support
- Adaptive layouts for iPhone and iPad

### Features
- **Worker Management**: Add workers with name validation, delete workers with swipe-to-delete
- **Daily Entry**: Batch entry for all workers on a given day with keyboard navigation
- **Control Charts**: Real-time statistical process control charts with mean and control limits
- **Individual Tracking**: Detailed view for each worker showing all daily counts
- **Statistics**: Automatic calculation of averages and control limits
- **Persistence**: Automatic save/restore of experiment data between sessions

### Technical Implementation
- SwiftUI-based user interface following Apple's design guidelines
- MVVM architecture pattern with clear separation of concerns
- Swift Charts for professional data visualization
- JSON persistence layer with robust error handling
- Comprehensive error handling throughout the application
- Modern Swift Testing framework for reliable unit tests

### Accessibility
- VoiceOver support throughout the app with descriptive labels
- Semantic accessibility labels and hints for all interactive elements
- Keyboard navigation support for power users
- High contrast compatibility for visually impaired users
- Dynamic Type support for text scaling preferences

### Platform Support
- iOS 16.0+ with backward compatibility considerations
- iPadOS 16.0+ with adaptive layouts
- Support for all iPhone and iPad screen sizes
- Portrait and landscape orientation support
- Dark mode support throughout the interface