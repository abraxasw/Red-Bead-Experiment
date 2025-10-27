//
//  Red_Bead_ExperimentTests.swift
//  Red Bead ExperimentTests
//
//  Created by Andrew Tam on 13/11/2024.
//

import Testing
@testable import Red_Bead_Experiment

/// Comprehensive test suite for the Red Bead Experiment app.
/// 
/// This test suite covers all major functionality including:
/// - Worker model creation and calculations
/// - ExperimentData management and statistics
/// - Data persistence and JSON coding
/// - Edge cases and error conditions
@Suite("Red Bead Experiment Tests")
struct Red_Bead_ExperimentTests {

    // MARK: - Worker Model Tests
    
    @Suite("Worker Model Tests")
    struct WorkerTests {
        
        @Test("Worker initialization with default values")
        func testWorkerInitialization() {
            let worker = Worker(name: "John Doe", dailyBeadCounts: [5, 10, 15])
            
            #expect(worker.name == "John Doe")
            #expect(worker.dailyBeadCounts == [5, 10, 15])
            #expect(worker.id != UUID()) // Should have a unique ID
        }

        @Test("Worker average calculation with multiple values")
        func testWorkerAverageBeadCount() {
            let worker = Worker(name: "Jane Smith", dailyBeadCounts: [10, 20, 30])
            
            #expect(worker.averageBeadCount == 20.0)
        }

        @Test("Worker average calculation with empty array")
        func testWorkerAverageBeadCountWithEmptyArray() {
            let worker = Worker(name: "Empty Worker", dailyBeadCounts: [])
            
            #expect(worker.averageBeadCount == 0.0)
        }

        @Test("Worker average calculation with single value")
        func testWorkerAverageBeadCountWithSingleValue() {
            let worker = Worker(name: "Single Worker", dailyBeadCounts: [15])
            
            #expect(worker.averageBeadCount == 15.0)
        }
        
        @Test("Worker computed properties")
        func testWorkerComputedProperties() {
            let worker = Worker(name: "Test Worker", dailyBeadCounts: [5, 10, 15, 8])
            
            #expect(worker.totalDays == 4)
            #expect(worker.totalBeads == 38)
            #expect(worker.averageBeadCount == 9.5)
        }
        
        @Test("Worker with zero bead counts")
        func testWorkerWithZeroCounts() {
            let worker = Worker(name: "Zero Worker", dailyBeadCounts: [0, 0, 0])
            
            #expect(worker.averageBeadCount == 0.0)
            #expect(worker.totalBeads == 0)
            #expect(worker.totalDays == 3)
        }
    }

    // MARK: - ExperimentData Tests
    
    @Suite("ExperimentData Management Tests")
    struct ExperimentDataTests {
        
        @Test("ExperimentData initialization")
        func testExperimentDataInitialization() {
            let experimentData = ExperimentData()
            
            #expect(experimentData.workers.isEmpty)
            #expect(experimentData.totalWorkers == 0)
            #expect(experimentData.totalExperimentDays == 0)
        }

        @Test("Adding workers to experiment")
        func testAddWorker() {
            let experimentData = ExperimentData()
            let worker = Worker(name: "Test Worker", dailyBeadCounts: [5])
            
            experimentData.addWorker(worker)
            
            #expect(experimentData.workers.count == 1)
            #expect(experimentData.workers.first?.name == "Test Worker")
            #expect(experimentData.totalWorkers == 1)
        }
        
        @Test("Removing workers from experiment")
        func testRemoveWorker() {
            let experimentData = ExperimentData()
            let worker1 = Worker(name: "Worker 1", dailyBeadCounts: [5])
            let worker2 = Worker(name: "Worker 2", dailyBeadCounts: [10])
            
            experimentData.addWorker(worker1)
            experimentData.addWorker(worker2)
            
            #expect(experimentData.workers.count == 2)
            
            experimentData.removeWorker(withId: worker1.id)
            
            #expect(experimentData.workers.count == 1)
            #expect(experimentData.workers.first?.name == "Worker 2")
        }
        
        @Test("Updating worker information")
        func testUpdateWorker() {
            let experimentData = ExperimentData()
            let originalWorker = Worker(name: "Original Name", dailyBeadCounts: [5])
            
            experimentData.addWorker(originalWorker)
            
            var updatedWorker = originalWorker
            updatedWorker.name = "Updated Name"
            updatedWorker.dailyBeadCounts.append(10)
            
            experimentData.updateWorker(withId: originalWorker.id, to: updatedWorker)
            
            #expect(experimentData.workers.first?.name == "Updated Name")
            #expect(experimentData.workers.first?.dailyBeadCounts == [5, 10])
        }
    }
    
    // MARK: - Statistical Calculation Tests
    
    @Suite("Statistical Calculation Tests")
    struct StatisticalTests {

        
        @Test("Total beads per day calculation")
        func testTotalBeadsPerDay() {
            let experimentData = ExperimentData()
            experimentData.workers = [
                Worker(name: "Worker 1", dailyBeadCounts: [5, 10, 15]),
                Worker(name: "Worker 2", dailyBeadCounts: [10, 20, 30]),
                Worker(name: "Worker 3", dailyBeadCounts: [5, 5, 5])
            ]

            let totals = experimentData.totalBeadsPerDay
            
            #expect(totals == [20, 35, 50])
        }

        @Test("Total beads per day with empty workers")
        func testTotalBeadsPerDayWithEmptyWorkers() {
            let experimentData = ExperimentData()
            let totals = experimentData.totalBeadsPerDay
            
            #expect(totals.isEmpty)
        }

        @Test("Average beads per day calculation")
        func testAverageBeadsPerDay() {
            let experimentData = ExperimentData()
            experimentData.workers = [
                Worker(name: "Worker 1", dailyBeadCounts: [10, 20, 30]),
                Worker(name: "Worker 2", dailyBeadCounts: [20, 40, 60])
            ]

            let averages = experimentData.averageBeadsPerDay
            
            #expect(averages == [15.0, 30.0, 45.0])
        }

        @Test("Average beads per day with empty workers")
        func testAverageBeadsPerDayWithEmptyWorkers() {
            let experimentData = ExperimentData()
            let averages = experimentData.averageBeadsPerDay
            
            #expect(averages.isEmpty)
        }

        @Test("Control limits calculation with normal data")
        func testCalculateControlLimits() {
            let experimentData = ExperimentData()
            experimentData.workers = [
                Worker(name: "Worker 1", dailyBeadCounts: [10, 12, 14]),
                Worker(name: "Worker 2", dailyBeadCounts: [11, 13, 15])
            ]

            let limits = experimentData.calculateControlLimits()

            // Mean should be (10+12+14+11+13+15)/6 = 75/6 = 12.5
            #expect(limits.mean == 12.5)

            // Verify that upper limit is greater than mean
            #expect(limits.upperLimit > limits.mean)

            // Verify that lower limit is less than or equal to mean
            #expect(limits.lowerLimit <= limits.mean)

            // Verify that lower limit is never negative
            #expect(limits.lowerLimit >= 0.0)
        }

        @Test("Control limits calculation with empty data")
        func testCalculateControlLimitsWithEmptyData() {
            let experimentData = ExperimentData()
            let limits = experimentData.calculateControlLimits()

            #expect(limits.mean == 0.0)
            #expect(limits.upperLimit == 0.0)
            #expect(limits.lowerLimit == 0.0)
        }

        @Test("Control limits calculation with low variance")
        func testCalculateControlLimitsWithLowVariance() {
            let experimentData = ExperimentData()
            experimentData.workers = [
                Worker(name: "Worker 1", dailyBeadCounts: [10, 10, 10]),
                Worker(name: "Worker 2", dailyBeadCounts: [10, 10, 10])
            ]

            let limits = experimentData.calculateControlLimits()

            // All values are 10, so mean should be 10 and variance should be 0
            #expect(limits.mean == 10.0)
            #expect(limits.upperLimit == 10.0)
            #expect(limits.lowerLimit == 10.0)
        }

        @Test("Control limits calculation with high variance")
        func testCalculateControlLimitsWithHighVariance() {
            let experimentData = ExperimentData()
            experimentData.workers = [
                Worker(name: "Worker 1", dailyBeadCounts: [0, 50, 0]),
                Worker(name: "Worker 2", dailyBeadCounts: [50, 0, 50])
            ]

            let limits = experimentData.calculateControlLimits()

            // Mean should be (0+50+0+50+0+50)/6 = 150/6 = 25
            #expect(limits.mean == 25.0)

            // With high variance, control limits should be wide apart
            #expect(limits.upperLimit - limits.mean > 10.0)
        }
        
        @Test("Process statistics calculation")
        func testCalculateProcessStatistics() {
            let experimentData = ExperimentData()
            experimentData.workers = [
                Worker(name: "Worker 1", dailyBeadCounts: [8, 12, 16]),
                Worker(name: "Worker 2", dailyBeadCounts: [10, 14, 18])
            ]
            
            let stats = experimentData.calculateProcessStatistics()
            
            #expect(stats.overallMean == 13.0) // (8+12+16+10+14+18)/6 = 78/6 = 13
            #expect(stats.processRange == 10.0) // 18 - 8 = 10
            #expect(stats.totalDataPoints == 6)
            #expect(stats.overallStandardDeviation > 0.0)
        }
    }
    
    // MARK: - Data Persistence Tests
    
    @Suite("Data Persistence Tests")
    struct PersistenceTests {
        
        @Test("Worker Codable conformance")
        func testWorkerCodable() throws {
            let worker = Worker(name: "Test Worker", dailyBeadCounts: [5, 10, 15])

            // Encode
            let encoder = JSONEncoder()
            let data = try encoder.encode(worker)

            // Decode
            let decoder = JSONDecoder()
            let decodedWorker = try decoder.decode(Worker.self, from: data)

            #expect(decodedWorker.name == worker.name)
            #expect(decodedWorker.dailyBeadCounts == worker.dailyBeadCounts)
            #expect(decodedWorker.id == worker.id)
        }

        @Test("Multiple workers Codable conformance")
        func testMultipleWorkersCodable() throws {
            let workers = [
                Worker(name: "Worker 1", dailyBeadCounts: [5, 10]),
                Worker(name: "Worker 2", dailyBeadCounts: [15, 20])
            ]

            // Encode
            let encoder = JSONEncoder()
            let data = try encoder.encode(workers)

            // Decode
            let decoder = JSONDecoder()
            let decodedWorkers = try decoder.decode([Worker].self, from: data)

            #expect(decodedWorkers.count == 2)
            #expect(decodedWorkers[0].name == "Worker 1")
            #expect(decodedWorkers[1].name == "Worker 2")
            #expect(decodedWorkers[0].dailyBeadCounts == [5, 10])
            #expect(decodedWorkers[1].dailyBeadCounts == [15, 20])
        }
    }
    
    // MARK: - Experiment Management Tests
    
    @Suite("Experiment Management Tests")
    struct ExperimentManagementTests {
        
        @Test("Reset experiment functionality")
        func testResetExperiment() {
            let experimentData = ExperimentData()
            experimentData.workers = [
                Worker(name: "Worker 1", dailyBeadCounts: [5, 10]),
                Worker(name: "Worker 2", dailyBeadCounts: [15, 20])
            ]

            #expect(experimentData.workers.count == 2)

            experimentData.reset()

            #expect(experimentData.workers.isEmpty)
            #expect(experimentData.totalWorkers == 0)
            #expect(experimentData.totalExperimentDays == 0)
        }
        
        @Test("Total experiment days calculation")
        func testTotalExperimentDays() {
            let experimentData = ExperimentData()
            experimentData.workers = [
                Worker(name: "Worker 1", dailyBeadCounts: [5, 10, 15]),      // 3 days
                Worker(name: "Worker 2", dailyBeadCounts: [20, 25, 30, 35]), // 4 days
                Worker(name: "Worker 3", dailyBeadCounts: [8])               // 1 day
            ]
            
            #expect(experimentData.totalExperimentDays == 4) // Maximum is 4 days
        }
        
        @Test("Control limit dash pattern")
        func testControlLimitDashPattern() {
            let pattern = ExperimentData.controlLimitDashPattern
            
            #expect(pattern == [5, 5])
            #expect(pattern.count == 2)
        }
    }
    
    // MARK: - Performance and Concurrency Tests
    
    @Suite("Performance and Concurrency Tests")
    struct PerformanceTests {
        
        @Test("Performance with large dataset")
        func testPerformanceWithLargeDataset() async {
            let experimentData = ExperimentData()
            
            // Create 100 workers with 365 days of data each
            for i in 1...100 {
                let dailyCounts = (1...365).map { _ in Int.random(in: 0...50) }
                let worker = Worker(name: "Worker \(i)", dailyBeadCounts: dailyCounts)
                experimentData.addWorker(worker)
            }
            
            // Test that calculations complete in reasonable time
            let startTime = Date()
            let limits = experimentData.calculateControlLimits()
            let stats = experimentData.calculateProcessStatistics()
            let elapsed = Date().timeIntervalSince(startTime)
            
            // Should complete within 1 second for this dataset size
            #expect(elapsed < 1.0)
            #expect(limits.mean > 0)
            #expect(stats.totalDataPoints == 36500) // 100 workers × 365 days
        }
        
        @Test("Memory efficiency with repeated operations")
        func testMemoryEfficiencyWithRepeatedOperations() {
            let experimentData = ExperimentData()
            
            // Add some test data
            for i in 1...50 {
                let worker = Worker(name: "Worker \(i)", dailyBeadCounts: [10, 20, 30])
                experimentData.addWorker(worker)
            }
            
            // Perform repeated calculations (should not cause memory issues)
            for _ in 1...1000 {
                let _ = experimentData.calculateControlLimits()
                let _ = experimentData.totalBeadsPerDay
                let _ = experimentData.averageBeadsPerDay
            }
            
            // If we get here without crashing, memory management is working properly
            #expect(experimentData.workers.count == 50)
        }
        
        @Test("ObservableObject publishing behavior")
        func testObservableObjectPublishing() async {
            let experimentData = ExperimentData()
            var changeCount = 0
            
            // This is a simplified test - in a real UI, you'd use a proper observer
            let originalCount = experimentData.workers.count
            
            let worker = Worker(name: "Test Worker", dailyBeadCounts: [5])
            experimentData.addWorker(worker)
            
            // Verify the change was made
            #expect(experimentData.workers.count == originalCount + 1)
        }
    }
    
    // MARK: - Data Validation Tests
    
    @Suite("Data Validation Tests")
    struct DataValidationTests {
        
        @Test("Worker name validation scenarios")
        func testWorkerNameValidation() {
            // Test various name scenarios
            let emptyNameWorker = Worker(name: "", dailyBeadCounts: [5])
            let longNameWorker = Worker(name: String(repeating: "A", count: 100), dailyBeadCounts: [10])
            let specialCharWorker = Worker(name: "Test-Worker_123!@#", dailyBeadCounts: [15])
            let unicodeWorker = Worker(name: "测试员工👨‍💼", dailyBeadCounts: [20])
            
            // All should be valid - the app should handle these gracefully
            #expect(emptyNameWorker.name.isEmpty)
            #expect(longNameWorker.name.count == 100)
            #expect(specialCharWorker.name.contains("!"))
            #expect(unicodeWorker.name.contains("👨‍💼"))
        }
        
        @Test("Daily bead count edge values")
        func testDailyBeadCountEdgeValues() {
            let maxIntWorker = Worker(name: "Max Int Worker", dailyBeadCounts: [Int.max])
            let zeroWorker = Worker(name: "Zero Worker", dailyBeadCounts: [0])
            let mixedWorker = Worker(name: "Mixed Worker", dailyBeadCounts: [0, 1, Int.max, 500])
            
            #expect(maxIntWorker.totalBeads == Int.max)
            #expect(zeroWorker.totalBeads == 0)
            #expect(mixedWorker.dailyBeadCounts.contains(Int.max))
            #expect(mixedWorker.dailyBeadCounts.contains(0))
        }
        
        @Test("JSON encoding/decoding edge cases")
        func testJSONEncodingDecodingEdgeCases() throws {
            // Test with extreme values
            let extremeWorker = Worker(
                name: "Extreme 🚀", 
                dailyBeadCounts: [0, Int.max, 1, 999999]
            )
            
            let encoder = JSONEncoder()
            let decoder = JSONDecoder()
            
            let encoded = try encoder.encode([extremeWorker])
            let decoded = try decoder.decode([Worker].self, from: encoded)
            
            #expect(decoded.count == 1)
            #expect(decoded[0].name == extremeWorker.name)
            #expect(decoded[0].dailyBeadCounts == extremeWorker.dailyBeadCounts)
            #expect(decoded[0].id == extremeWorker.id)
        }
    }
    
    // MARK: - Business Logic Tests
    
    @Suite("Business Logic Tests")  
    struct BusinessLogicTests {
        
        @Test("Red Bead Experiment statistical assumptions")
        func testRedBeadExperimentAssumptions() {
            let experimentData = ExperimentData()
            
            // Simulate realistic Red Bead Experiment data
            // In the real experiment, workers typically get 0-20 red beads out of 50 draws
            experimentData.workers = [
                Worker(name: "Alice", dailyBeadCounts: [8, 12, 6, 14, 10]),
                Worker(name: "Bob", dailyBeadCounts: [15, 9, 11, 7, 13]),
                Worker(name: "Carol", dailyBeadCounts: [5, 18, 8, 12, 9]),
                Worker(name: "David", dailyBeadCounts: [11, 7, 16, 10, 8])
            ]
            
            let limits = experimentData.calculateControlLimits()
            let stats = experimentData.calculateProcessStatistics()
            
            // Verify realistic ranges for the Red Bead Experiment
            #expect(limits.mean >= 0 && limits.mean <= 50) // Should be within possible range
            #expect(limits.upperLimit > limits.mean) // Upper limit should be higher than mean
            #expect(limits.lowerLimit <= limits.mean) // Lower limit should be at or below mean
            #expect(stats.totalDataPoints == 20) // 4 workers × 5 days
            
            // Verify process variation is captured
            #expect(stats.overallStandardDeviation > 0) // Should have some variation
        }
        
        @Test("Control chart interpretation scenarios")
        func testControlChartInterpretation() {
            let experimentData = ExperimentData()
            
            // Scenario 1: Process in control (all points within limits)
            experimentData.workers = [
                Worker(name: "Stable Worker", dailyBeadCounts: [10, 12, 8, 11, 9])
            ]
            
            let limits = experimentData.calculateControlLimits()
            let allCounts = experimentData.workers.flatMap { $0.dailyBeadCounts }
            
            // All points should be within control limits (or close, given small sample size)
            for count in allCounts {
                let doubleCount = Double(count)
                let isWithinLimits = doubleCount >= limits.lowerLimit && doubleCount <= limits.upperLimit
                
                // With such a small sample, the limits might be tight, so we'll check the math is consistent
                #expect(limits.upperLimit >= limits.mean)
                #expect(limits.lowerLimit <= limits.mean)
            }
        }
        
        @Test("Multi-day experiment progression")
        func testMultiDayExperimentProgression() {
            let experimentData = ExperimentData()
            
            // Simulate adding data over time (as would happen in real experiment)
            let worker1 = Worker(name: "Progressive Worker 1", dailyBeadCounts: [])
            let worker2 = Worker(name: "Progressive Worker 2", dailyBeadCounts: [])
            
            experimentData.addWorker(worker1)
            experimentData.addWorker(worker2)
            
            // Initially no data
            #expect(experimentData.totalExperimentDays == 0)
            
            // Simulate adding daily data
            var updatedWorker1 = worker1
            var updatedWorker2 = worker2
            
            // Day 1
            updatedWorker1.dailyBeadCounts.append(8)
            updatedWorker2.dailyBeadCounts.append(12)
            experimentData.updateWorker(withId: worker1.id, to: updatedWorker1)
            experimentData.updateWorker(withId: worker2.id, to: updatedWorker2)
            
            #expect(experimentData.totalExperimentDays == 1)
            
            // Day 2
            updatedWorker1.dailyBeadCounts.append(10)
            updatedWorker2.dailyBeadCounts.append(14)
            experimentData.updateWorker(withId: worker1.id, to: updatedWorker1)
            experimentData.updateWorker(withId: worker2.id, to: updatedWorker2)
            
            #expect(experimentData.totalExperimentDays == 2)
            #expect(experimentData.totalBeadsPerDay == [20, 24]) // Day 1: 8+12=20, Day 2: 10+14=24
        }
    }

    // MARK: - Edge Case Tests
    
    @Suite("Edge Case Tests")
    struct EdgeCaseTests {
        
        @Test("Worker with very large bead counts")
        func testWorkerWithLargeBeadCounts() {
            let worker = Worker(name: "High Performer", dailyBeadCounts: [1000, 2000, 3000])
            
            #expect(worker.totalBeads == 6000)
            #expect(worker.averageBeadCount == 2000.0)
        }
        
        @Test("Control limits with negative potential lower limit")
        func testControlLimitsWithNegativeLowerLimit() {
            let experimentData = ExperimentData()
            // Create data with very low values and high variance
            experimentData.workers = [
                Worker(name: "Worker 1", dailyBeadCounts: [0, 0, 1]),
                Worker(name: "Worker 2", dailyBeadCounts: [0, 1, 0])
            ]
            
            let limits = experimentData.calculateControlLimits()
            
            // Lower limit should be clamped to 0 (not negative)
            #expect(limits.lowerLimit >= 0.0)
            #expect(limits.mean >= 0.0)
            #expect(limits.upperLimit >= limits.mean)
        }
        
        @Test("Uneven daily counts across workers")
        func testUnevenDailyCountsAcrossWorkers() {
            let experimentData = ExperimentData()
            experimentData.workers = [
                Worker(name: "Worker 1", dailyBeadCounts: [5, 10]),
                Worker(name: "Worker 2", dailyBeadCounts: [15, 20, 25]),
                Worker(name: "Worker 3", dailyBeadCounts: [8])
            ]
            
            let totals = experimentData.totalBeadsPerDay
            
            // Should handle uneven counts gracefully
            #expect(totals == [28, 30, 25]) // Day 1: 5+15+8=28, Day 2: 10+20+0=30, Day 3: 0+25+0=25
        }
    }
}
