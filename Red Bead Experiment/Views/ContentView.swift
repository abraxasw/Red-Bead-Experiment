import SwiftUI
import Charts

/// Main content view for the Red Bead Experiment app
struct ContentView: View {
    @StateObject private var experimentData = ExperimentData()
    @State private var showingAddWorker = false
    @State private var showingResetAlert = false
    @State private var showingDailyEntry = false

    var body: some View {
        NavigationStack {
            TabView {
                WorkerListView(experimentData: experimentData)
                    .tabItem {
                        Label("Workers", systemImage: "person.2")
                    }

                ControlChartView(experimentData: experimentData)
                    .tabItem {
                        Label("Chart", systemImage: "chart.xyaxis.line")
                    }
            }
            .navigationTitle("Red Bead Experiment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack(spacing: 2) {
                        Text("Red Bead Experiment")
                            .font(.headline)
                        Text("by W. Edwards Deming")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showingResetAlert = true }) {
                        Label("Reset", systemImage: "arrow.counterclockwise")
                    }
                    .accessibilityLabel("Reset experiment")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 16) {
                        Button(action: { showingDailyEntry = true }) {
                            Label("Daily Entry", systemImage: "number")
                        }
                        .disabled(experimentData.workers.isEmpty)
                        .accessibilityLabel("Add daily entry")

                        Button(action: { showingAddWorker = true }) {
                            Label("Add Worker", systemImage: "plus")
                        }
                        .accessibilityLabel("Add worker")
                    }
                }
            }
            .sheet(isPresented: $showingAddWorker) {
                AddWorkerView(experimentData: experimentData)
            }
            .sheet(isPresented: $showingDailyEntry) {
                DailyEntryView(experimentData: experimentData)
            }
            .alert("Reset Experiment", isPresented: $showingResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    experimentData.reset()
                }
            } message: {
                Text("This will remove all workers and their data. This action cannot be undone.")
            }
        }
    }
}
