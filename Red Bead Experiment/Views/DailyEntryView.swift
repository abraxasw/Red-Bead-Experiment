import SwiftUI

import SwiftUI

/// View for entering daily bead counts for all workers in the experiment.
///
/// This view provides a form interface for recording the daily white bead counts
/// for all participating workers. It supports both list and grid layouts based on
/// the device size class and includes comprehensive validation and error handling.
///
/// Key features:
/// - Adaptive layout (list on compact devices, grid on regular devices)
/// - Input validation for non-negative integers
/// - Keyboard navigation with previous/next buttons
/// - Batch saving with error handling
/// - Full accessibility support
struct DailyEntryView: View {
    
    // MARK: - Environment
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    // MARK: - Properties
    
    /// The experiment data containing all workers
    @ObservedObject var experimentData: ExperimentData
    
    // MARK: - State
    
    /// Array of string inputs for each worker's bead count
    @State private var beadCounts: [String] = []
    
    /// Controls the display of error alerts
    @State private var showingErrorAlert = false
    
    /// Error message to display in alerts
    @State private var errorMessage = ""
    
    /// Tracks which text field is currently focused for keyboard navigation
    @FocusState private var focusedField: Int?
    
    // MARK: - Computed Properties
    
    /// The current experiment day number (1-based)
    let dayNumber: Int
    
    // MARK: - Initialization
    
    /// Creates a new daily entry view for the current experiment day.
    /// - Parameter experimentData: The experiment data model
    init(experimentData: ExperimentData) {
        self.experimentData = experimentData
        self._beadCounts = State(initialValue: Array(repeating: "", count: experimentData.workers.count))
        self.dayNumber = (experimentData.workers.first?.dailyBeadCounts.count ?? 0) + 1
    }
    
    // MARK: - Body

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
                cancelToolbarItem
                saveToolbarItem
                keyboardToolbarItem
            }
            .alert("Error Saving Data", isPresented: $showingErrorAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    // MARK: - Layout Views
    
    /// Grid layout for regular size classes (iPad)
    private var gridLayout: some View {
        ScrollView {
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
    }
    
    /// List layout for compact size classes (iPhone)
    private var listLayout: some View {
        List {
            ForEach(Array(experimentData.workers.enumerated()), id: \.element.id) { index, worker in
                workerEntryCell(worker: worker, index: index)
            }
        }
    }
    
    // MARK: - Toolbar Items
    
    /// Cancel button in the navigation toolbar
    private var cancelToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("Cancel") {
                dismiss()
            }
            .accessibilityLabel("Cancel daily entry")
            .accessibilityHint("Discards all entered data and returns to previous screen")
        }
    }
    
    /// Save button in the navigation toolbar
    private var saveToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            Button("Save") {
                saveEntries()
            }
            .disabled(!isValid)
            .accessibilityLabel("Save daily entries")
            .accessibilityHint(isValid ? 
                              "Saves bead counts for all workers" : 
                              "Complete all entries with valid numbers to enable saving")
        }
    }
    
    /// Keyboard navigation toolbar
    private var keyboardToolbarItem: some ToolbarContent {
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
                .accessibilityLabel("Dismiss keyboard")
            }
        }
    }
    
    // MARK: - Cell Components

    /// Creates an input cell for a specific worker's bead count entry.
    /// - Parameters:
    ///   - worker: The worker for whom to create the entry cell
    ///   - index: The index of the worker in the experiment data
    /// - Returns: A view containing the worker name and input field
    private func workerEntryCell(worker: Worker, index: Int) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(worker.name)
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            
            HStack(spacing: 8) {
                TextField("White beads", text: $beadCounts[index])
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.trailing)
                    .focused($focusedField, equals: index)
                    .submitLabel(index == experimentData.workers.count - 1 ? .done : .next)
                    .onSubmit {
                        focusNextField()
                    }
                    .accessibilityLabel("\(worker.name) bead count input")
                    .accessibilityHint("Enter the number of white beads drawn by \(worker.name)")
                
                Text("beads")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
    
    // MARK: - Navigation Methods

    /// Navigates to the previous input field in the form.
    /// Prevents navigation beyond the first field.
    private func focusPreviousField() {
        if let current = focusedField, current > 0 {
            focusedField = current - 1
        }
    }

    /// Navigates to the next input field in the form.
    /// Removes focus when reaching the end of the form.
    private func focusNextField() {
        if let current = focusedField {
            if current + 1 < experimentData.workers.count {
                focusedField = current + 1
            } else {
                focusedField = nil
            }
        }
    }
    
    // MARK: - Validation
    
    /// Validates that all input fields contain valid non-negative integers.
    /// - Returns: true if all inputs are valid, false otherwise
    private var isValid: Bool {
        guard !experimentData.workers.isEmpty,
              beadCounts.count == experimentData.workers.count else { 
            return false 
        }
        
        return beadCounts.allSatisfy { count in
            guard let number = Int(count) else { return false }
            return number >= 0
        }
    }
    
    // MARK: - Data Management

    /// Saves all daily entries with comprehensive error handling.
    /// 
    /// This method validates all inputs, converts them to integers, and appends
    /// them to each worker's daily bead count array. It provides detailed error
    /// reporting if any issues occur during the save process.
    private func saveEntries() {
        guard isValid else {
            errorMessage = "Please enter valid bead counts for all workers (non-negative whole numbers only)."
            showingErrorAlert = true
            return
        }

        var savedCount = 0

        // Process each worker's entry
        for (index, worker) in experimentData.workers.enumerated() {
            guard index < beadCounts.count,
                  let count = Int(beadCounts[index]),
                  count >= 0 else {
                errorMessage = "Invalid input for \(worker.name). Please enter a valid number."
                showingErrorAlert = true
                return
            }

            // Find the worker in the array and update their data
            if let workerIndex = experimentData.workers.firstIndex(where: { $0.id == worker.id }) {
                experimentData.workers[workerIndex].dailyBeadCounts.append(count)
                savedCount += 1
            }
        }

        // Verify all entries were saved successfully
        if savedCount == experimentData.workers.count {
            dismiss()
        } else {
            errorMessage = "Could not save all entries. Only \(savedCount) of \(experimentData.workers.count) were saved successfully. Please try again."
            showingErrorAlert = true
        }
    }
}
