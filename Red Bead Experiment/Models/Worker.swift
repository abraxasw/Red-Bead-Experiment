import Foundation

/// Represents a worker participating in the Red Bead Experiment
struct Worker: Identifiable, Hashable, Codable {
    let id: UUID
    var name: String
    var dailyBeadCounts: [Int] // Array of white bead counts per day

    /// Calculates the average bead count across all days
    var averageBeadCount: Double {
        guard !dailyBeadCounts.isEmpty else { return 0 }
        return Double(dailyBeadCounts.reduce(0, +)) / Double(dailyBeadCounts.count)
    }

    init(id: UUID = UUID(), name: String, dailyBeadCounts: [Int]) {
        self.id = id
        self.name = name
        self.dailyBeadCounts = dailyBeadCounts
    }
}
