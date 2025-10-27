import Foundation

/// Manages the data for the Red Bead Experiment, including all workers and their statistics.
///
/// This class serves as the central data model for the entire experiment, handling
/// worker management, statistical calculations, and data persistence. It implements
/// ObservableObject to support SwiftUI's reactive UI updates.
///
/// The Red Bead Experiment demonstrates statistical process control principles
/// by tracking worker performance over time and calculating control limits.
final class ExperimentData: ObservableObject {
    
    // MARK: - Constants
    
    /// Statistical constants for control chart calculations and UI presentation
    private enum Constants {
        /// Multiplier for standard deviation to calculate control limits (±3σ)
        static let standardDeviationMultiplier = 3.0
        
        /// Dash pattern for control limit lines in charts
        static let dashPattern: [CGFloat] = [5, 5]
        
        /// Minimum allowable bead count (prevents negative control limits)
        static let minimumBeadCount = 0.0
        
        /// UserDefaults key for data persistence
        static let userDefaultsKey = "experimentData"
    }
    
    // MARK: - Published Properties
    
    /// Array of all workers participating in the experiment
    /// Changes to this property trigger UI updates and automatic data persistence
    @Published var workers: [Worker] = [] {
        didSet {
            saveToUserDefaults()
        }
    }
    
    // MARK: - Computed Properties
    
    /// Calculates total beads collected per day across all workers.
    /// - Returns: Array where each element represents the sum of all workers' bead counts for that day
    var totalBeadsPerDay: [Int] {
        guard let maxDays = workers.map({ $0.dailyBeadCounts.count }).max(), 
              maxDays > 0 else { 
            return [] 
        }
        
        return (0..<maxDays).map { day in
            workers.reduce(0) { sum, worker in
                sum + (worker.dailyBeadCounts.indices.contains(day) ? worker.dailyBeadCounts[day] : 0)
            }
        }
    }
    
    /// Calculates average beads per day across all workers.
    /// - Returns: Array of daily averages, or empty array if no workers exist
    var averageBeadsPerDay: [Double] {
        guard !workers.isEmpty else { return [] }
        return totalBeadsPerDay.map { Double($0) / Double(workers.count) }
    }
    
    /// Total number of experiment days (maximum days any worker has participated)
    var totalExperimentDays: Int {
        workers.map { $0.totalDays }.max() ?? 0
    }
    
    /// Total number of workers in the experiment
    var totalWorkers: Int {
        workers.count
    }
    
    // MARK: - Initialization
    
    /// Creates a new ExperimentData instance and loads any previously saved data
    init() {
        loadFromUserDefaults()
    }
    
    // MARK: - Statistical Calculations
    
    /// Calculates statistical control limits using the mean ± 3σ method.
    ///
    /// Control limits are fundamental to statistical process control and help
    /// identify when a process is operating within normal variation or if
    /// special causes are present.
    ///
    /// - Returns: Named tuple containing mean, upper control limit, and lower control limit
    func calculateControlLimits() -> (mean: Double, upperLimit: Double, lowerLimit: Double) {
        let allCounts = workers.flatMap { $0.dailyBeadCounts }
        guard !allCounts.isEmpty else { 
            return (mean: 0.0, upperLimit: 0.0, lowerLimit: 0.0) 
        }
        
        // Calculate mean
        let mean = Double(allCounts.reduce(0, +)) / Double(allCounts.count)
        
        // Calculate variance and standard deviation
        let variance = allCounts
            .map { pow(Double($0) - mean, 2) }
            .reduce(0, +) / Double(allCounts.count)
        let standardDeviation = sqrt(variance)
        
        // Calculate control limits
        let upperLimit = mean + (Constants.standardDeviationMultiplier * standardDeviation)
        let lowerLimit = max(
            mean - (Constants.standardDeviationMultiplier * standardDeviation),
            Constants.minimumBeadCount
        )
        
        return (mean: mean, upperLimit: upperLimit, lowerLimit: lowerLimit)
    }
    
    /// Calculates the overall process capability metrics
    /// - Returns: Named tuple with process statistics
    func calculateProcessStatistics() -> (
        overallMean: Double,
        overallStandardDeviation: Double,
        processRange: Double,
        totalDataPoints: Int
    ) {
        let allCounts = workers.flatMap { $0.dailyBeadCounts }
        guard !allCounts.isEmpty else {
            return (overallMean: 0.0, overallStandardDeviation: 0.0, processRange: 0.0, totalDataPoints: 0)
        }
        
        let mean = Double(allCounts.reduce(0, +)) / Double(allCounts.count)
        let variance = allCounts
            .map { pow(Double($0) - mean, 2) }
            .reduce(0, +) / Double(allCounts.count)
        let standardDeviation = sqrt(variance)
        let range = (allCounts.max() ?? 0) - (allCounts.min() ?? 0)
        
        return (
            overallMean: mean,
            overallStandardDeviation: standardDeviation,
            processRange: Double(range),
            totalDataPoints: allCounts.count
        )
    }
    
    // MARK: - Public Methods
    
    /// Returns the dash pattern for control limit lines in charts
    static var controlLimitDashPattern: [CGFloat] {
        Constants.dashPattern
    }
    
    /// Resets all experiment data by removing all workers
    func reset() {
        workers.removeAll()
    }
    
    /// Adds a new worker to the experiment
    /// - Parameter worker: The worker to add
    func addWorker(_ worker: Worker) {
        workers.append(worker)
    }
    
    /// Removes a worker by ID
    /// - Parameter workerId: The ID of the worker to remove
    func removeWorker(withId workerId: UUID) {
        workers.removeAll { $0.id == workerId }
    }
    
    /// Updates a worker's information
    /// - Parameters:
    ///   - workerId: The ID of the worker to update
    ///   - updatedWorker: The worker with updated information
    func updateWorker(withId workerId: UUID, to updatedWorker: Worker) {
        guard let index = workers.firstIndex(where: { $0.id == workerId }) else { return }
        workers[index] = updatedWorker
    }
    
    // MARK: - Data Persistence
    
    /// Saves experiment data to UserDefaults for persistence between app launches
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
        guard let data = UserDefaults.standard.data(forKey: Constants.userDefaultsKey) else { 
            return 
        }
        
        do {
            workers = try JSONDecoder().decode([Worker].self, from: data)
        } catch {
            print("Failed to load experiment data: \(error.localizedDescription)")
        }
    }
}
