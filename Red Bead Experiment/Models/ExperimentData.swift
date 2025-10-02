import Foundation

/// Manages the data for the Red Bead Experiment, including all workers and their statistics
class ExperimentData: ObservableObject {
    /// Statistical constants for control chart calculations
    private enum Constants {
        static let standardDeviationMultiplier = 3.0
        static let dashPattern: [CGFloat] = [5, 5]
        static let minimumBeadCount = 0.0
        static let userDefaultsKey = "experimentData"
    }

    @Published var workers: [Worker] = [] {
        didSet {
            saveToUserDefaults()
        }
    }

    init() {
        loadFromUserDefaults()
    }

    /// Calculates total beads collected per day across all workers
    var totalBeadsPerDay: [Int] {
        guard let maxDays = workers.map({ $0.dailyBeadCounts.count }).max(), maxDays > 0 else { return [] }

        return (0..<maxDays).map { day in
            workers.reduce(0) { sum, worker in
                sum + (worker.dailyBeadCounts.indices.contains(day) ? worker.dailyBeadCounts[day] : 0)
            }
        }
    }

    /// Calculates average beads per day across all workers
    var averageBeadsPerDay: [Double] {
        guard !workers.isEmpty else { return [] }
        return totalBeadsPerDay.map { Double($0) / Double(workers.count) }
    }

    /// Calculates statistical control limits using mean ± 3σ
    /// - Returns: Tuple containing mean, upper control limit, and lower control limit
    func calculateControlLimits() -> (mean: Double, upperLimit: Double, lowerLimit: Double) {
        let allCounts = workers.flatMap { $0.dailyBeadCounts }
        guard !allCounts.isEmpty else { return (0, 0, 0) }

        let mean = Double(allCounts.reduce(0, +)) / Double(allCounts.count)
        let variance = allCounts.map { pow(Double($0) - mean, 2) }.reduce(0, +) / Double(allCounts.count)
        let standardDeviation = sqrt(variance)

        return (
            mean: mean,
            upperLimit: mean + (Constants.standardDeviationMultiplier * standardDeviation),
            lowerLimit: max(mean - (Constants.standardDeviationMultiplier * standardDeviation), Constants.minimumBeadCount)
        )
    }

    /// Returns the dash pattern for control limit lines
    static var controlLimitDashPattern: [CGFloat] {
        Constants.dashPattern
    }

    /// Resets all experiment data
    func reset() {
        workers.removeAll()
    }

    // MARK: - Persistence

    /// Saves experiment data to UserDefaults
    private func saveToUserDefaults() {
        do {
            let encoded = try JSONEncoder().encode(workers)
            UserDefaults.standard.set(encoded, forKey: Constants.userDefaultsKey)
        } catch {
            print("Failed to save experiment data: \(error.localizedDescription)")
        }
    }

    /// Loads experiment data from UserDefaults
    private func loadFromUserDefaults() {
        guard let data = UserDefaults.standard.data(forKey: Constants.userDefaultsKey) else { return }

        do {
            workers = try JSONDecoder().decode([Worker].self, from: data)
        } catch {
            print("Failed to load experiment data: \(error.localizedDescription)")
        }
    }
}
