import SwiftUI

/// Displays detailed information for a single worker, including all daily bead counts
struct WorkerDetailView: View {
    let workerId: UUID
    @ObservedObject var experimentData: ExperimentData
    @State private var newBeadCount = ""
    @Environment(\.dismiss) private var dismiss

    /// Safely retrieves the current worker from experiment data
    private var worker: Worker? {
        experimentData.workers.first(where: { $0.id == workerId })
    }

    /// Safely retrieves the worker's index in the array
    private var workerIndex: Int? {
        experimentData.workers.firstIndex(where: { $0.id == workerId })
    }

    var body: some View {
        Group {
            if let currentWorker = worker, let index = workerIndex {
                List {
                    Section("Add Daily Count") {
                        HStack {
                            TextField("White Bead Count", text: $newBeadCount)
                                .keyboardType(.numberPad)
                                .accessibilityLabel("White bead count input")

                            Button("Add") {
                                addBeadCount()
                            }
                            .disabled(Int(newBeadCount) == nil || Int(newBeadCount) ?? -1 < 0)
                            .accessibilityLabel("Add bead count")
                        }
                    }

                    Section("Daily Counts") {
                        if experimentData.workers[index].dailyBeadCounts.isEmpty {
                            Text("No daily counts recorded yet")
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(experimentData.workers[index].dailyBeadCounts.indices, id: \.self) { day in
                                HStack {
                                    Text("Day \(day + 1)")
                                    Spacer()
                                    Text("\(experimentData.workers[index].dailyBeadCounts[day]) beads")
                                }
                                .accessibilityElement(children: .combine)
                                .accessibilityLabel("Day \(day + 1): \(experimentData.workers[index].dailyBeadCounts[day]) beads")
                            }
                            .onDelete(perform: deleteDailyCounts)
                        }
                    }
                }
                .navigationTitle(currentWorker.name)
            } else {
                ContentUnavailableView(
                    "Worker Not Found",
                    systemImage: "person.slash",
                    description: Text("This worker may have been deleted")
                )
                .onAppear {
                    // Dismiss after a short delay if worker was deleted
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        dismiss()
                    }
                }
            }
        }
    }

    /// Adds a new bead count for the worker
    private func addBeadCount() {
        guard let count = Int(newBeadCount),
              count >= 0,
              let index = workerIndex else { return }

        experimentData.workers[index].dailyBeadCounts.append(count)
        newBeadCount = ""
    }

    /// Deletes daily counts at specified offsets
    private func deleteDailyCounts(at offsets: IndexSet) {
        guard let index = workerIndex else { return }
        experimentData.workers[index].dailyBeadCounts.remove(atOffsets: offsets)
    }
}
