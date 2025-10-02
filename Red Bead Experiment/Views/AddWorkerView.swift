import SwiftUI

/// View for adding a new worker to the experiment
struct AddWorkerView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var experimentData: ExperimentData
    @State private var workerName = ""

    /// Validates that the worker name is not empty or whitespace only
    private var isValidName: Bool {
        !workerName.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Worker Name", text: $workerName)
                        .accessibilityLabel("Worker name input")
                } footer: {
                    Text("Enter a name for the worker")
                        .font(.caption)
                }
            }
            .navigationTitle("Add Worker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addWorker()
                    }
                    .disabled(!isValidName)
                }
            }
        }
    }

    /// Adds a new worker with validated name
    private func addWorker() {
        let trimmedName = workerName.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else { return }

        let worker = Worker(name: trimmedName, dailyBeadCounts: [])
        experimentData.workers.append(worker)
        dismiss()
    }
}
