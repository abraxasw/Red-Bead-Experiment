# Contributing to Red Bead Experiment

Thank you for your interest in contributing to the Red Bead Experiment iOS app! This document provides guidelines for contributing to the project.

## Code of Conduct

This project adheres to a code of conduct that emphasizes respect, inclusivity, and constructive collaboration. Please be respectful in all interactions.

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/yourusername/red-bead-experiment.git`
3. Create a branch for your feature: `git checkout -b feature/your-feature-name`
4. Make your changes
5. Test your changes thoroughly
6. Submit a pull request

## Development Setup

### Requirements
- Xcode 15.0+
- iOS 16.0+ deployment target
- Swift 5.9+

### Project Structure
```
Red Bead Experiment/
├── Models/
│   ├── Worker.swift
│   └── ExperimentData.swift
├── Views/
│   ├── ContentView.swift
│   ├── WorkerListView.swift
│   ├── ControlChartView.swift
│   ├── DailyEntryView.swift
│   ├── WorkerDetailView.swift
│   └── AddWorkerView.swift
└── Tests/
    └── Red_Bead_ExperimentTests.swift
```

## Coding Standards

### Swift Style Guide
- Follow [Apple's Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- Use meaningful, descriptive names for variables, functions, and types
- Add documentation comments for all public APIs
- Maintain consistent indentation (4 spaces)
- Keep line length under 120 characters when practical

### SwiftUI Best Practices
- Use `@State`, `@StateObject`, and `@ObservedObject` appropriately
- Prefer computed properties for derived data
- Extract complex views into separate components
- Use `@ViewBuilder` for conditional view content
- Follow accessibility best practices with proper labels and hints

### Code Organization
- Group related functionality together
- Use MARK comments to organize code sections
- Keep functions focused and single-purpose
- Prefer composition over inheritance
- Use extensions to group related functionality

## Testing

### Unit Tests
- All new functionality must include corresponding unit tests
- Use the Swift Testing framework with `@Test` annotations
- Test both happy path and edge cases
- Aim for high test coverage on business logic
- Mock external dependencies when necessary

### Test Structure
```swift
@Test("Description of what is being tested")
func testFeature() async throws {
    // Given
    let input = setupTestData()
    
    // When
    let result = performAction(input)
    
    // Then
    #expect(result == expectedOutput)
}
```

### Running Tests
- Run all tests: `Cmd+U` in Xcode
- Run specific test: Click the diamond icon next to the test method
- Tests must pass before submitting a pull request

## Accessibility

### Requirements
- All interactive elements must have appropriate accessibility labels
- Provide accessibility hints where helpful
- Support VoiceOver navigation
- Test with VoiceOver enabled
- Support Dynamic Type for text scaling
- Ensure sufficient color contrast

### Implementation
```swift
Button("Add Worker") {
    // Action
}
.accessibilityLabel("Add new worker to experiment")
.accessibilityHint("Opens form to enter worker details")
```

## Performance

### Guidelines
- Avoid unnecessary view updates with proper state management
- Use lazy loading for large datasets
- Optimize chart rendering with appropriate data sampling
- Profile performance with Instruments when needed
- Consider memory usage in data models

## Pull Request Process

### Before Submitting
1. Ensure all tests pass
2. Run code through Xcode's static analyzer
3. Test accessibility features
4. Update documentation if needed
5. Add/update unit tests for new functionality

### Pull Request Template
```markdown
## Description
Brief description of the changes made.

## Type of Change
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## Testing
- [ ] Unit tests pass
- [ ] Manual testing completed
- [ ] Accessibility testing completed

## Screenshots (if applicable)
Add screenshots to help explain your changes.

## Checklist
- [ ] Code follows the style guidelines
- [ ] Self-review of code completed
- [ ] Code is commented, particularly in hard-to-understand areas
- [ ] Corresponding changes to documentation made
- [ ] No new warnings introduced
```

## Issue Reporting

### Bug Reports
Include:
- iOS version
- Device model
- Steps to reproduce
- Expected vs actual behavior
- Screenshots if applicable

### Feature Requests
Include:
- Clear description of the proposed feature
- Use case or problem it solves
- Proposed implementation approach (if applicable)

## Documentation

### Code Documentation
- Use Swift documentation comments (`///`)
- Document all public APIs
- Include usage examples for complex functionality
- Keep documentation up to date with code changes

### README Updates
- Update README.md for significant feature additions
- Include screenshots for UI changes
- Update installation/setup instructions if needed

## Release Process

### Version Numbering
Follow [Semantic Versioning](https://semver.org/):
- MAJOR version for incompatible API changes
- MINOR version for backwards-compatible functionality additions
- PATCH version for backwards-compatible bug fixes

### Changelog
Update CHANGELOG.md following [Keep a Changelog](https://keepachangelog.com/) format:
- Added: for new features
- Changed: for changes in existing functionality
- Deprecated: for soon-to-be removed features
- Removed: for now removed features
- Fixed: for any bug fixes
- Security: in case of vulnerabilities

## Questions?

If you have questions about contributing, please:
1. Check the documentation first
2. Search existing issues
3. Create a new issue with the question label
4. Reach out to maintainers

Thank you for contributing to the Red Bead Experiment project!