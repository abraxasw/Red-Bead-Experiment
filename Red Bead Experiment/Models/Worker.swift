import Foundation

/// Represents a worker participating in the Red Bead Experiment.
///
/// A worker is an individual participant in the experiment who draws beads
/// from a container and records their daily counts. This model tracks their
/// identity, name, and historical performance data.
struct Worker: Identifiable, Hashable, Codable {
    
    // MARK: - Properties
    
    /// Unique identifier for the worker
    let id: UUID
    
    /// Display name of the worker
    var name: String
    
    /// Array of white bead counts recorded per day
    /// Each element represents the count of white beads drawn on that day (indexed from 0)
    var dailyBeadCounts: [Int]
    
    // MARK: - Computed Properties
    
    /// Calculates the average bead count across all recorded days.
    /// - Returns: The arithmetic mean of all daily bead counts, or 0.0 if no data exists
    var averageBeadCount: Double {
        guard !dailyBeadCounts.isEmpty else { return 0.0 }
        let sum = dailyBeadCounts.reduce(0, +)
        return Double(sum) / Double(dailyBeadCounts.count)
    }
    
    /// The total number of days this worker has participated
    var totalDays: Int {
        dailyBeadCounts.count
    }
    
    /// The total number of beads collected by this worker across all days
    var totalBeads: Int {
        dailyBeadCounts.reduce(0, +)
    }
    
    // MARK: - Initialization
    
    /// Creates a new worker with the specified parameters.
    /// - Parameters:
    ///   - id: Unique identifier (defaults to a new UUID)
    ///   - name: Display name for the worker
    ///   - dailyBeadCounts: Historical bead count data (defaults to empty array)
    init(id: UUID = UUID(), name: String, dailyBeadCounts: [Int] = []) {
        self.id = id
        self.name = name
        self.dailyBeadCounts = dailyBeadCounts
    }
}
