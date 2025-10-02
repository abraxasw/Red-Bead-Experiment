//
//  Red_Bead_ExperimentTests.swift
//  Red Bead ExperimentTests
//
//  Created by Andrew Tam on 13/11/2024.
//

import Testing
@testable import Red_Bead_Experiment

struct Red_Bead_ExperimentTests {

    // MARK: - Worker Tests

    @Test func testWorkerInitialization() {
        let worker = Worker(name: "John Doe", dailyBeadCounts: [5, 10, 15])
        #expect(worker.name == "John Doe")
        #expect(worker.dailyBeadCounts == [5, 10, 15])
    }

    @Test func testWorkerAverageBeadCount() {
        let worker = Worker(name: "Jane Smith", dailyBeadCounts: [10, 20, 30])
        #expect(worker.averageBeadCount == 20.0)
    }

    @Test func testWorkerAverageBeadCountWithEmptyArray() {
        let worker = Worker(name: "Empty Worker", dailyBeadCounts: [])
        #expect(worker.averageBeadCount == 0.0)
    }

    @Test func testWorkerAverageBeadCountWithSingleValue() {
        let worker = Worker(name: "Single Worker", dailyBeadCounts: [15])
        #expect(worker.averageBeadCount == 15.0)
    }

    // MARK: - ExperimentData Tests

    @Test func testExperimentDataInitialization() {
        let experimentData = ExperimentData()
        #expect(experimentData.workers.isEmpty)
    }

    @Test func testAddWorker() {
        let experimentData = ExperimentData()
        let worker = Worker(name: "Test Worker", dailyBeadCounts: [5])
        experimentData.workers.append(worker)
        #expect(experimentData.workers.count == 1)
        #expect(experimentData.workers.first?.name == "Test Worker")
    }

    @Test func testTotalBeadsPerDay() {
        let experimentData = ExperimentData()
        experimentData.workers = [
            Worker(name: "Worker 1", dailyBeadCounts: [5, 10, 15]),
            Worker(name: "Worker 2", dailyBeadCounts: [10, 20, 30]),
            Worker(name: "Worker 3", dailyBeadCounts: [5, 5, 5])
        ]

        let totals = experimentData.totalBeadsPerDay
        #expect(totals == [20, 35, 50])
    }

    @Test func testTotalBeadsPerDayWithEmptyWorkers() {
        let experimentData = ExperimentData()
        let totals = experimentData.totalBeadsPerDay
        #expect(totals.isEmpty)
    }

    @Test func testAverageBeadsPerDay() {
        let experimentData = ExperimentData()
        experimentData.workers = [
            Worker(name: "Worker 1", dailyBeadCounts: [10, 20, 30]),
            Worker(name: "Worker 2", dailyBeadCounts: [20, 40, 60])
        ]

        let averages = experimentData.averageBeadsPerDay
        #expect(averages == [15.0, 30.0, 45.0])
    }

    @Test func testAverageBeadsPerDayWithEmptyWorkers() {
        let experimentData = ExperimentData()
        let averages = experimentData.averageBeadsPerDay
        #expect(averages.isEmpty)
    }

    @Test func testCalculateControlLimits() {
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
        #expect(limits.lowerLimit >= 0)
    }

    @Test func testCalculateControlLimitsWithEmptyData() {
        let experimentData = ExperimentData()
        let limits = experimentData.calculateControlLimits()

        #expect(limits.mean == 0)
        #expect(limits.upperLimit == 0)
        #expect(limits.lowerLimit == 0)
    }

    @Test func testCalculateControlLimitsWithLowVariance() {
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

    @Test func testCalculateControlLimitsWithHighVariance() {
        let experimentData = ExperimentData()
        experimentData.workers = [
            Worker(name: "Worker 1", dailyBeadCounts: [0, 50, 0]),
            Worker(name: "Worker 2", dailyBeadCounts: [50, 0, 50])
        ]

        let limits = experimentData.calculateControlLimits()

        // Mean should be (0+50+0+50+0+50)/6 = 150/6 = 25
        #expect(limits.mean == 25.0)

        // With high variance, control limits should be wide apart
        #expect(limits.upperLimit - limits.mean > 10)
    }

    @Test func testResetExperiment() {
        let experimentData = ExperimentData()
        experimentData.workers = [
            Worker(name: "Worker 1", dailyBeadCounts: [5, 10]),
            Worker(name: "Worker 2", dailyBeadCounts: [15, 20])
        ]

        #expect(experimentData.workers.count == 2)

        experimentData.reset()

        #expect(experimentData.workers.isEmpty)
    }

    @Test func testWorkerCodable() throws {
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

    @Test func testMultipleWorkersCodable() throws {
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
    }
}
