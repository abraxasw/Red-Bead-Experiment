import SwiftUI

/// Displays a list of all workers participating in the Red Bead Experiment.
///
/// This view provides the main interface for viewing and managing experiment participants.
/// It shows each worker's name, average bead count, and provides navigation to detailed
/// individual worker views. The view supports swipe-to-delete for worker removal.
///
/// Features:
/// - Adaptive empty state for when no workers exist
/// - Individual worker statistics display
/// - Navigation to detailed worker views
/// - Swipe-to-delete worker management
/// - Comprehensive accessibility support
struct WorkerListView: View {
    
    // MARK: - Properties
    
    /// The experiment data containing all workers
    @ObservedObject var experimentData: ExperimentData
    
    // MARK: - Body

    var body: some View {
        List {
            if experimentData.workers.isEmpty {
                emptyStateView
            } else {
                workerListContent
            }
        }
        .accessibilityLabel("Workers list")
        .accessibilityHint("List of all participants in the Red Bead Experiment")
    }
    
    // MARK: - Private Views
    
    /// Empty state view displayed when no workers have been added
    @ViewBuilder
    private var emptyStateView: some View {
        if #available(iOS 17.0, *) {
            ContentUnavailableView(
                "No Workers",
                systemImage: "person.2",
                description: Text("Add workers to begin the experiment")
            )
        } else {
            VStack(spacing: 16) {
                Image(systemName: "person.2")
                    .font(.system(size: 48))
                    .foregroundColor(.secondary)
                
                VStack(spacing: 8) {
                    Text("No Workers")
                        .font(.title2)
                        .fontWeight(.medium)
                    
                    Text("Add workers to begin the experiment")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("No workers added yet. Add workers to begin the experiment.")
        }
    }
    
    /// The main list content displaying all workers
    @ViewBuilder
    private var workerListContent: some View {
        ForEach(experimentData.workers) { worker in
            NavigationLink(destination: workerDetailView(for: worker)) {
                workerRowView(for: worker)
            }
            .accessibilityLabel(accessibilityLabel(for: worker))
            .accessibilityHint("Double tap to view detailed statistics for \(worker.name)")
        }
        .onDelete(perform: deleteWorkers)
    }
    
    /// Creates a row view for displaying individual worker information
    /// - Parameter worker: The worker to display
    /// - Returns: A view showing worker name and statistics
    private func workerRowView(for worker: Worker) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(worker.name)
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack {
                Text("Average: \(String(format: "%.1f", worker.averageBeadCount)) beads")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if worker.totalDays > 0 {
                    Text("\(worker.totalDays) day\(worker.totalDays == 1 ? "" : "s")")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .padding(.vertical, 2)
    }
    
    /// Creates the destination view for a specific worker
    /// - Parameter worker: The worker to show details for
    /// - Returns: A WorkerDetailView configured for the worker
    private func workerDetailView(for worker: Worker) -> some View {
        WorkerDetailView(workerId: worker.id, experimentData: experimentData)
    }
    
    /// Generates an accessibility label for a worker row
    /// - Parameter worker: The worker to create a label for
    /// - Returns: A descriptive accessibility label
    private func accessibilityLabel(for worker: Worker) -> String {
        let averageText = String(format: "%.1f", worker.averageBeadCount)
        let daysText = worker.totalDays == 1 ? "1 day" : "\(worker.totalDays) days"
        
        return "\(worker.name), average \(averageText) beads, participated for \(daysText)"
    }
    
    // MARK: - Actions
    
    /// Deletes workers at the specified offsets with proper error handling.
    /// - Parameter offsets: The index positions of workers to delete
    private func deleteWorkers(at offsets: IndexSet) {
        // Validate that the offsets are within bounds
        guard !offsets.isEmpty,
              let maxIndex = offsets.max(),
              maxIndex < experimentData.workers.count else {
            return
        }
        
        // Remove workers using the experiment data's method for consistency
        let workersToRemove = offsets.map { experimentData.workers[$0] }
        for worker in workersToRemove {
            experimentData.removeWorker(withId: worker.id)
        }
    }
}
