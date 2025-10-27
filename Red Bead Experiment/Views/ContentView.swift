import SwiftUI
import Charts

/// Main content view for the Red Bead Experiment app.
///
/// This view serves as the primary interface for the Red Bead Experiment,
/// providing navigation between different sections of the app and managing
/// the overall application state. It demonstrates W. Edwards Deming's
/// famous experiment for teaching statistical process control principles.
struct ContentView: View {
    
    // MARK: - Properties
    
    /// The central data model for the experiment
    @StateObject private var experimentData = ExperimentData()
    
    // MARK: - State
    
    @State private var showingAddWorker = false
    @State private var showingResetAlert = false
    @State private var showingDailyEntry = false
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            TabView {
                workerListTab
                controlChartTab
            }
            .navigationTitle("Red Bead Experiment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                titleToolbarItem
                resetToolbarItem
                actionToolbarItems
            }
            .sheet(isPresented: $showingAddWorker) {
                AddWorkerView(experimentData: experimentData)
            }
            .sheet(isPresented: $showingDailyEntry) {
                DailyEntryView(experimentData: experimentData)
            }
            .alert("Reset Experiment", isPresented: $showingResetAlert) {
                resetAlertButtons
            } message: {
                resetAlertMessage
            }
        }
    }
    
    // MARK: - Tab Views
    
    /// Tab showing the list of workers with their statistics
    private var workerListTab: some View {
        WorkerListView(experimentData: experimentData)
            .tabItem {
                Label("Workers", systemImage: "person.2")
            }
    }
    
    /// Tab showing the statistical control chart
    private var controlChartTab: some View {
        ControlChartView(experimentData: experimentData)
            .tabItem {
                Label("Chart", systemImage: "chart.xyaxis.line")
            }
    }
    
    // MARK: - Toolbar Items
    
    /// Custom title toolbar item with subtitle
    private var titleToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            VStack(spacing: 2) {
                Text("Red Bead Experiment")
                    .font(.headline)
                Text("by W. Edwards Deming")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    /// Reset button in the leading toolbar position
    private var resetToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: { showingResetAlert = true }) {
                Label("Reset", systemImage: "arrow.counterclockwise")
            }
            .accessibilityLabel("Reset experiment")
            .accessibilityHint("Removes all workers and their data")
        }
    }
    
    /// Action buttons in the trailing toolbar position
    private var actionToolbarItems: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack(spacing: 16) {
                dailyEntryButton
                addWorkerButton
            }
        }
    }
    
    /// Button for adding daily entries (only enabled when workers exist)
    private var dailyEntryButton: some View {
        Button(action: { showingDailyEntry = true }) {
            Label("Daily Entry", systemImage: "number")
        }
        .disabled(experimentData.workers.isEmpty)
        .accessibilityLabel("Add daily entry")
        .accessibilityHint(experimentData.workers.isEmpty ? 
                          "Add workers first to enable daily entry" : 
                          "Record bead counts for all workers")
    }
    
    /// Button for adding a new worker
    private var addWorkerButton: some View {
        Button(action: { showingAddWorker = true }) {
            Label("Add Worker", systemImage: "plus")
        }
        .accessibilityLabel("Add worker")
        .accessibilityHint("Add a new participant to the experiment")
    }
    
    // MARK: - Alert Components
    
    /// Buttons for the reset confirmation alert
    private var resetAlertButtons: some View {
        Group {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                experimentData.reset()
            }
        }
    }
    
    /// Message text for the reset confirmation alert
    private var resetAlertMessage: some View {
        Text("This will remove all workers and their data. This action cannot be undone.")
    }
}
