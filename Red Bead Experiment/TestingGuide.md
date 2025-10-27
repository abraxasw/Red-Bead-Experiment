# Red Bead Experiment Testing Guide

This comprehensive testing guide will help you verify that your Red Bead Experiment app works correctly across all scenarios.

## Test Types Available

### 1. Unit Tests (`Red_Bead_ExperimentTests.swift`)
- **Worker Model Tests**: Basic worker functionality, calculations, edge cases
- **ExperimentData Management**: Adding/removing workers, data updates
- **Statistical Calculations**: Control limits, process statistics, mathematical accuracy
- **Data Persistence**: JSON encoding/decoding, data integrity
- **Performance Tests**: Large datasets, memory efficiency
- **Business Logic**: Red Bead Experiment specific scenarios

### 2. Integration Tests (`Red_Bead_ExperimentIntegrationTests.swift`)
- **View-Model Integration**: How UI components work with data models
- **Data Flow**: How changes propagate through the system
- **Statistical Consistency**: Mathematical relationships across operations
- **Real-world Scenarios**: Full experiment simulations

### 3. UI Tests (`Red_Bead_ExperimentUITests.swift`)
- **Navigation**: Tab switching, sheet presentation
- **User Workflows**: Adding workers, entering daily data
- **Error Handling**: Invalid inputs, edge cases
- **Accessibility**: Screen reader support, labels

## Running the Tests

### In Xcode:
1. **All Tests**: `Cmd+U` or Product → Test
2. **Specific Test Suite**: Click the ▷ button next to the suite in the Test Navigator
3. **Individual Test**: Click the ▷ button next to a specific test

### Test Targets:
- `Red Bead ExperimentTests` - Unit and integration tests
- `Red Bead ExperimentUITests` - End-to-end UI tests

## Manual Testing Checklist

### Core Functionality
- [ ] App launches successfully on device/simulator
- [ ] Navigation between Workers and Chart tabs works
- [ ] Add new worker (valid name)
- [ ] Add new worker (empty name) - should handle gracefully
- [ ] Daily entry disabled when no workers exist
- [ ] Daily entry enabled after adding workers
- [ ] Enter daily bead counts for workers
- [ ] View control chart with data
- [ ] Reset experiment removes all data

### Edge Cases
- [ ] Very long worker names
- [ ] Special characters in names (emojis, etc.)
- [ ] Large bead count numbers
- [ ] Zero bead counts
- [ ] Many workers (10+)
- [ ] Many days of data (weeks/months)

### UI/UX
- [ ] Empty states show appropriate messages
- [ ] Charts display correctly with various data amounts
- [ ] Toolbar buttons are properly enabled/disabled
- [ ] Alert dialogs work correctly
- [ ] Sheet presentations and dismissals work

### Accessibility
- [ ] VoiceOver navigation works
- [ ] All buttons have proper labels
- [ ] Chart data is accessible to screen readers
- [ ] Sufficient color contrast

### Performance
- [ ] App remains responsive with large datasets
- [ ] Smooth animations and transitions
- [ ] Quick calculations even with many workers
- [ ] Memory usage stays reasonable

## Test Data Scenarios

### Typical Red Bead Experiment Data:
Use these realistic values for testing:

**Workers**: 4-6 people
**Days**: 5 days typically
**Bead Counts**: Usually 5-15 red beads per person per day (out of 50 total beads drawn)

Example realistic data:
- Alice: [8, 12, 6, 14, 10]
- Bob: [15, 9, 11, 7, 13]
- Carol: [5, 18, 8, 12, 9]
- David: [11, 7, 16, 10, 8]

Expected mean: ~10.5 beads
Expected control limits: Roughly 0-21 beads (±3σ)

### Stress Test Scenarios:
- 50+ workers
- 100+ days of data
- Values at integer limits
- Empty data sets
- Single data points

## Automation Options

### Continuous Integration:
If using CI/CD, run tests automatically on:
- Pull requests
- Main branch commits
- Nightly builds

### Command Line Testing:
```bash
# Run all tests
xcodebuild test -scheme "Red Bead Experiment" -destination "platform=iOS Simulator,name=iPhone 15"

# Run specific tests
xcodebuild test -scheme "Red Bead Experiment" -destination "platform=iOS Simulator,name=iPhone 15" -only-testing:Red_Bead_ExperimentTests

# Generate test coverage
xcodebuild test -scheme "Red Bead Experiment" -destination "platform=iOS Simulator,name=iPhone 15" -enableCodeCoverage YES
```

## Expected Test Results

### Test Coverage Goals:
- **Unit Tests**: >95% code coverage
- **Integration Tests**: All major user flows covered
- **UI Tests**: All primary user interactions tested

### Performance Benchmarks:
- Control limit calculations: <100ms for 100 workers × 365 days
- UI responsiveness: <16ms frame times
- Memory usage: <50MB for typical datasets

## Troubleshooting Common Issues

### Test Failures:
1. **Floating point precision**: Use appropriate tolerance in assertions
2. **UI element timing**: Add explicit waits for UI tests
3. **Data persistence**: Clear UserDefaults between tests if needed

### Device-Specific Issues:
1. Test on multiple iOS versions
2. Test on different screen sizes
3. Verify accessibility on actual devices

## Test Maintenance

### Regular Updates:
- Update test data when business logic changes
- Add tests for new features
- Remove obsolete tests
- Update UI tests when interface changes

### Review Checklist:
- Tests are readable and well-documented
- Tests are independent (no shared state)
- Tests cover both happy path and error cases
- Performance tests have realistic thresholds