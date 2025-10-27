import SwiftUI

/// Displays detailed information for a single worker in the Red Bead Experiment.
///
/// This view provides comprehensive statistics and management capabilities for an individual
/// worker, including their daily bead count history, average performance, and the ability
/// to add new daily entries. It handles cases where the worker may have been deleted
/// from another part of the app.
///
/// Features:
/// - Individual worker statistics display
/// - Daily bead count history with chronological listing
/// - Add new daily bead counts with validation
/// - Delete individual daily entries with swipe-to-delete
/// - Graceful handling of deleted workers
/// - Full accessibility support
struct WorkerDetailView: View {
    
    // MARK: - Properties
    
    /// The unique identifier of the worker to display
    let workerId: UUID
    
    /// The experiment data containing all workers
    @ObservedObject var experimentData: ExperimentData
    
    // MARK: - State
    
    /// Input text for adding new bead counts
    @State private var newBeadCount = ""
    
    /// Controls focus state for the input field
    @FocusState private var isInputFocused: Bool
    
    // MARK: - Environment
    
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Computed Properties
    
    /// Safely retrieves the current worker from experiment data
    private var worker: Worker? {
        experimentData.workers.first(where: { $0.id == workerId })
    }

    /// Safely retrieves the worker's index in the experiment data array
    private var workerIndex: Int? {
        experimentData.workers.firstIndex(where: { $0.id == workerId })
    }
    
    /// Validates that the input bead count is a valid non-negative integer
    private var isValidBeadCount: Bool {
        guard let count = Int(newBeadCount) else { return false }
        return count >= 0
    }
    
    // MARK: - Body

    var body: some View {
        Group {
            if let currentWorker = worker, let index = workerIndex {
                workerDetailContent(worker: currentWorker, index: index)
            } else {
                workerNotFoundView
            }
        }
    }
    
    // MARK: - Private Views
    
    /// Main content view for displaying worker details
    /// - Parameters:
    ///   - worker: The worker to display
    ///   - index: The worker's index in the experiment data
    private func workerDetailContent(worker: Worker, index: Int) -> some View {
        List {
            statisticsSection(for: worker)
            addCountSection
            dailyCountsSection(for: index)
        }
        .navigationTitle(worker.name)
        .navigationBarTitleDisplayMode(.large)
    }
    
    /// Statistics section showing worker performance summary
    /// - Parameter worker: The worker to show statistics for
    private func statisticsSection(for worker: Worker) -> some View {
        Section("Performance Summary") {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Average")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(String(format: "%.1f", worker.averageBeadCount)) beads")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Total Days")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(worker.totalDays)")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Total Beads")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(worker.totalBeads)")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
            }
            .padding(.vertical, 8)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Performance summary: Average \(String(format: "%.1f", worker.averageBeadCount)) beads, \(worker.totalDays) days participated, \(worker.totalBeads) total beads collected")
        }
    }
    
    /// Section for adding new daily bead counts
    private var addCountSection: some View {
        Section("Add Daily Count") {
            HStack(spacing: 12) {
                TextField("Enter bead count", text: $newBeadCount)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    .focused($isInputFocused)
                    .onSubmit {
                        if isValidBeadCount {
                            addBeadCount()
                        }
                    }
                    .accessibilityLabel("New bead count input")
                    .accessibilityHint("Enter the number of white beads drawn today")

                Button("Add") {
                    addBeadCount()
                }
                .disabled(!isValidBeadCount)
                .buttonStyle(.borderedProminent)
                .accessibilityLabel("Add bead count")
                .accessibilityHint(isValidBeadCount ? 
                                  "Adds the entered bead count to the worker's history" : 
                                  "Enter a valid non-negative number to enable adding")
            }
            
            if !newBeadCount.isEmpty && !isValidBeadCount {
                Text("Please enter a valid non-negative number")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
    
    /// Section displaying all daily bead counts for the worker
    /// - Parameter index: The worker's index in the experiment data
    private func dailyCountsSection(for index: Int) -> some View {
        Section {
            if experimentData.workers[index].dailyBeadCounts.isEmpty {
                Text("No daily counts recorded yet")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
                    .accessibilityLabel("No daily bead counts recorded yet")
            } else {
                ForEach(experimentData.workers[index].dailyBeadCounts.indices, id: \.self) { dayIndex in
                    dailyCountRow(dayIndex: dayIndex, workerIndex: index)
                }
                .onDelete { offsets in
                    deleteDailyCounts(at: offsets, workerIndex: index)
                }
            }
        } header: {
            HStack {
                Text("Daily Counts")
                Spacer()
                if !experimentData.workers[index].dailyBeadCounts.isEmpty {
                    Text("\(experimentData.workers[index].dailyBeadCounts.count) entries")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    /// Individual row for a daily bead count entry
    /// - Parameters:
    ///   - dayIndex: The day index in the worker's history
    ///   - workerIndex: The worker's index in the experiment data
    private func dailyCountRow(dayIndex: Int, workerIndex: Int) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Day \(dayIndex + 1)")
                    .font(.headline)
                
                Text("Entry \(dayIndex + 1) of \(experimentData.workers[workerIndex].dailyBeadCounts.count)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("\(experimentData.workers[workerIndex].dailyBeadCounts[dayIndex])")
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            Text("beads")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Day \(dayIndex + 1): \(experimentData.workers[workerIndex].dailyBeadCounts[dayIndex]) beads")
        .accessibilityHint("Swipe to delete this entry")
    }
    
    /// View displayed when the worker cannot be found
    @ViewBuilder
    private var workerNotFoundView: some View {
        if #available(iOS 17.0, *) {
            ContentUnavailableView(
                "Worker Not Found",
                systemImage: "person.slash",
                description: Text("This worker may have been deleted from another screen")
            )
            .onAppear(perform: handleWorkerNotFound)
        } else {
            VStack(spacing: 16) {
                Image(systemName: "person.slash")
                    .font(.system(size: 48))
                    .foregroundColor(.secondary)
                
                VStack(spacing: 8) {
                    Text("Worker Not Found")
                        .font(.title2)
                        .fontWeight(.medium)
                    
                    Text("This worker may have been deleted from another screen")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear(perform: handleWorkerNotFound)
        }
    }
    
    // MARK: - Actions

    /// Adds a new bead count for the worker with comprehensive validation.
    private func addBeadCount() {
        guard let count = Int(newBeadCount),
              count >= 0,
              let index = workerIndex else { 
            return 
        }

        experimentData.workers[index].dailyBeadCounts.append(count)
        newBeadCount = ""
        
        // Remove focus from the text field to provide user feedback
        isInputFocused = false
        
        // Provide haptic feedback for successful addition
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }

    /// Deletes daily counts at specified offsets with proper error handling.
    /// - Parameters:
    ///   - offsets: The index positions of daily counts to delete
    ///   - workerIndex: The index of the worker in the experiment data
    private func deleteDailyCounts(at offsets: IndexSet, workerIndex: Int) {
        guard workerIndex < experimentData.workers.count else { return }
        
        experimentData.workers[workerIndex].dailyBeadCounts.remove(atOffsets: offsets)
    }
    
    /// Handles the case when a worker is not found, typically due to deletion
    private func handleWorkerNotFound() {
        // Dismiss the view after a short delay to allow user to see the message
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            dismiss()
        }
    }
}
