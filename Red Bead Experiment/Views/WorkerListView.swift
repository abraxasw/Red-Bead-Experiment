import SwiftUI

/// Displays a list of all workers with their average bead counts
struct WorkerListView: View {
    @ObservedObject var experimentData: ExperimentData

    var body: some View {
        List {
            if experimentData.workers.isEmpty {
                ContentUnavailableView(
                    "No Workers",
                    systemImage: "person.2",
                    description: Text("Add workers to begin the experiment")
                )
            } else {
                ForEach(experimentData.workers) { worker in
                    NavigationLink(destination: WorkerDetailView(workerId: worker.id, experimentData: experimentData)) {
                        VStack(alignment: .leading) {
                            Text(worker.name)
                                .font(.headline)
                            Text("Average: \(worker.averageBeadCount, specifier: "%.1f") beads")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("\(worker.name), average \(worker.averageBeadCount, specifier: "%.1f") beads")
                    }
                }
                .onDelete(perform: deleteWorkers)
            }
        }
    }

    /// Deletes workers at specified offsets
    private func deleteWorkers(at offsets: IndexSet) {
        experimentData.workers.remove(atOffsets: offsets)
    }
}
