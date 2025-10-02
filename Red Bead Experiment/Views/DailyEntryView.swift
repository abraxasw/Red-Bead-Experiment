import SwiftUI

/// View for entering daily bead counts for all workers
struct DailyEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @ObservedObject var experimentData: ExperimentData
    @State private var beadCounts: [String] = []
    @State private var showingErrorAlert = false
    @State private var errorMessage = ""
    @FocusState private var focusedField: Int?

    let dayNumber: Int

    init(experimentData: ExperimentData) {
        self.experimentData = experimentData
        self._beadCounts = State(initialValue: Array(repeating: "", count: experimentData.workers.count))
        self.dayNumber = (experimentData.workers.first?.dailyBeadCounts.count ?? 0) + 1
    }

    var body: some View {
        NavigationStack {
            Group {
                if horizontalSizeClass == .regular {
                    gridLayout
                } else {
                    listLayout
                }
            }
            .navigationTitle("Day \(dayNumber)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveEntries()
                    }
                    .disabled(!isValid)
                    .accessibilityLabel("Save daily entries")
                }
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Button(action: focusPreviousField) {
                            Image(systemName: "chevron.up")
                        }
                        .disabled(focusedField == 0 || focusedField == nil)
                        .accessibilityLabel("Previous field")

                        Button(action: focusNextField) {
                            Image(systemName: "chevron.down")
                        }
                        .disabled(focusedField == nil || focusedField == experimentData.workers.count - 1)
                        .accessibilityLabel("Next field")

                        Spacer()

                        Button("Done") {
                            focusedField = nil
                        }
                    }
                }
            }
            .alert("Error Saving Data", isPresented: $showingErrorAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }

    private var gridLayout: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 20) {
            ForEach(Array(experimentData.workers.enumerated()), id: \.element.id) { index, worker in
                workerEntryCell(worker: worker, index: index)
            }
        }
        .padding()
    }

    private var listLayout: some View {
        List {
            ForEach(Array(experimentData.workers.enumerated()), id: \.element.id) { index, worker in
                workerEntryCell(worker: worker, index: index)
            }
        }
    }

    private func workerEntryCell(worker: Worker, index: Int) -> some View {
        VStack(alignment: .leading) {
            Text(worker.name)
                .font(.headline)
            HStack {
                TextField("White beads", text: $beadCounts[index])
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.trailing)
                    .focused($focusedField, equals: index)
                    .submitLabel(index == experimentData.workers.count - 1 ? .done : .next)
                    .onSubmit {
                        focusNextField()
                    }
                    .accessibilityLabel("\(worker.name) bead count")
                Text("beads")
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }

    /// Navigates to the previous input field
    private func focusPreviousField() {
        if let current = focusedField {
            focusedField = max(0, current - 1)
        }
    }

    /// Navigates to the next input field
    private func focusNextField() {
        if let current = focusedField {
            focusedField = current + 1 < experimentData.workers.count ? current + 1 : nil
        }
    }

    /// Validates that all inputs are valid non-negative integers
    private var isValid: Bool {
        guard !experimentData.workers.isEmpty else { return false }
        return beadCounts.allSatisfy { count in
            if let number = Int(count) {
                return number >= 0
            }
            return false
        }
    }

    /// Saves all daily entries with error handling
    private func saveEntries() {
        guard isValid else {
            errorMessage = "Please enter valid bead counts for all workers."
            showingErrorAlert = true
            return
        }

        var savedCount = 0

        // Use indexed iteration to avoid multiple lookups
        for (index, workerId) in experimentData.workers.map({ $0.id }).enumerated() {
            guard let count = Int(beadCounts[index]),
                  count >= 0,
                  let workerIndex = experimentData.workers.firstIndex(where: { $0.id == workerId }) else {
                continue
            }

            experimentData.workers[workerIndex].dailyBeadCounts.append(count)
            savedCount += 1
        }

        if savedCount == experimentData.workers.count {
            dismiss()
        } else {
            errorMessage = "Could not save all entries. Only \(savedCount) of \(experimentData.workers.count) were saved successfully."
            showingErrorAlert = true
        }
    }
}
