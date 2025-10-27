import SwiftUI

/// View for adding a new worker to the Red Bead Experiment.
///
/// This view provides a simple form interface for entering a new worker's name
/// and adding them to the experiment. It includes input validation to ensure
/// worker names are not empty and provides appropriate accessibility support.
///
/// Features:
/// - Text field validation for non-empty names
/// - Automatic whitespace trimming
/// - Cancel/Save navigation buttons
/// - Full accessibility support
/// - Form-based layout following iOS design patterns
struct AddWorkerView: View {
    
    // MARK: - Environment
    
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Properties
    
    /// The experiment data model to add the worker to
    @ObservedObject var experimentData: ExperimentData
    
    // MARK: - State
    
    /// The input text for the worker's name
    @State private var workerName = ""
    
    /// Focus state for the text field
    @FocusState private var isTextFieldFocused: Bool
    
    // MARK: - Computed Properties
    
    /// Validates that the worker name is not empty after trimming whitespace.
    /// - Returns: true if the name is valid, false if empty or whitespace-only
    private var isValidName: Bool {
        !workerName.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    // MARK: - Body

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Worker Name", text: $workerName)
                        .focused($isTextFieldFocused)
                        .submitLabel(.done)
                        .onSubmit {
                            if isValidName {
                                addWorker()
                            }
                        }
                        .accessibilityLabel("Worker name input field")
                        .accessibilityHint("Enter the name of the worker to add to the experiment")
                } footer: {
                    Text("Enter a name for the new worker participating in the Red Bead Experiment")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Add Worker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                cancelToolbarItem
                saveToolbarItem
            }
            .onAppear {
                // Focus the text field when the view appears for better UX
                isTextFieldFocused = true
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
            .accessibilityLabel("Cancel adding worker")
            .accessibilityHint("Discards the entered name and returns to the previous screen")
        }
    }
    
    /// Save button in the navigation toolbar
    private var saveToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            Button("Add") {
                addWorker()
            }
            .disabled(!isValidName)
            .accessibilityLabel("Add worker")
            .accessibilityHint(isValidName ? 
                              "Adds the worker to the experiment" : 
                              "Enter a valid worker name to enable adding")
        }
    }
    
    // MARK: - Actions

    /// Adds a new worker with the validated name to the experiment data.
    /// 
    /// This method trims whitespace from the input, creates a new Worker instance,
    /// and adds it to the experiment data before dismissing the view.
    private func addWorker() {
        let trimmedName = workerName.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else { return }

        let worker = Worker(name: trimmedName, dailyBeadCounts: [])
        experimentData.addWorker(worker)
        dismiss()
    }
}
