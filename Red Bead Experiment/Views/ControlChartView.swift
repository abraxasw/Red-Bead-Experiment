import SwiftUI
import Charts

/// Displays a statistical process control chart for worker performance.
///
/// This view creates an interactive chart showing daily bead counts for each worker
/// along with statistical control limits. It demonstrates key concepts from the
/// Red Bead Experiment including process variation, mean performance, and control boundaries.
///
/// The chart includes:
/// - Individual worker performance lines over time
/// - Mean line showing overall average performance
/// - Upper and lower control limits (mean ± 3σ)
/// - Full accessibility support for screen readers
struct ControlChartView: View {
    
    // MARK: - Properties
    
    /// The experiment data containing all workers and their daily counts
    @ObservedObject var experimentData: ExperimentData
    
    // MARK: - Body
    
    var body: some View {
        if experimentData.workers.isEmpty {
            emptyStateView
        } else {
            controlChart
        }
    }
    
    // MARK: - Private Views
    
    /// Displays an empty state when no workers have been added to the experiment
    @ViewBuilder
    private var emptyStateView: some View {
        if #available(iOS 17.0, *) {
            ContentUnavailableView(
                "No Data",
                systemImage: "chart.xyaxis.line",
                description: Text("Add workers to see the control chart")
            )
        } else {
            VStack(spacing: 16) {
                Image(systemName: "chart.xyaxis.line")
                    .font(.system(size: 48))
                    .foregroundColor(.secondary)
                
                VStack(spacing: 8) {
                    Text("No Data")
                        .font(.title2)
                        .fontWeight(.medium)
                    
                    Text("Add workers to see the control chart")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    /// The main control chart displaying worker performance and statistical limits
    @ViewBuilder
    private var controlChart: some View {
        let limits = experimentData.calculateControlLimits()
        
        Chart {
            // Data points for each worker's daily performance
            dataPoints
            
            // Statistical control limit lines
            controlLimitLines(limits: limits)
        }
        .chartYAxis {
            AxisMarks(position: .leading) { _ in
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 5)) { _ in
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
            }
        }
        .chartLegend(position: .bottom, alignment: .center)
        .padding()
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Statistical control chart showing worker performance over time")
        .accessibilityHint(accessibilityHintText(limits: limits))
    }
    
    // MARK: - Chart Content Builders
    
    /// Creates data points for all workers showing their daily bead counts over time
    @ChartContentBuilder
    private var dataPoints: some ChartContent {
        ForEach(experimentData.workers) { worker in
            let enumeratedCounts = Array(worker.dailyBeadCounts.enumerated())
            ForEach(enumeratedCounts, id: \.offset) { index, count in
                LineMark(
                    x: .value("Day", "Day \(index + 1)"),
                    y: .value("Beads", count)
                )
                .foregroundStyle(by: .value("Worker", worker.name))
                .symbol(by: .value("Worker", worker.name))
                .accessibilityLabel("\(worker.name), Day \(index + 1), \(count) beads")
            }
        }
    }
    
    /// Creates the statistical control limit lines (mean, upper, and lower limits)
    /// - Parameter limits: The calculated statistical limits from the experiment data
    @ChartContentBuilder
    private func controlLimitLines(limits: (mean: Double, upperLimit: Double, lowerLimit: Double)) -> some ChartContent {
        meanLine(value: limits.mean)
        upperControlLimit(value: limits.upperLimit)
        lowerControlLimit(value: limits.lowerLimit)
    }
    
    /// Creates the mean line (center line) for the control chart
    /// - Parameter value: The mean value to display
    @ChartContentBuilder
    private func meanLine(value: Double) -> some ChartContent {
        RuleMark(y: .value("Mean", value))
            .foregroundStyle(.gray)
            .lineStyle(StrokeStyle(
                lineWidth: 2,
                dash: ExperimentData.controlLimitDashPattern
            ))
            .accessibilityLabel("Process mean: \(String(format: "%.1f", value)) beads")
    }
    
    /// Creates the upper control limit line
    /// - Parameter value: The upper control limit value to display
    @ChartContentBuilder
    private func upperControlLimit(value: Double) -> some ChartContent {
        RuleMark(y: .value("Upper Control Limit", value))
            .foregroundStyle(.red)
            .lineStyle(StrokeStyle(
                lineWidth: 1,
                dash: ExperimentData.controlLimitDashPattern
            ))
            .accessibilityLabel("Upper control limit: \(String(format: "%.1f", value)) beads")
    }
    
    /// Creates the lower control limit line
    /// - Parameter value: The lower control limit value to display
    @ChartContentBuilder
    private func lowerControlLimit(value: Double) -> some ChartContent {
        RuleMark(y: .value("Lower Control Limit", value))
            .foregroundStyle(.red)
            .lineStyle(StrokeStyle(
                lineWidth: 1,
                dash: ExperimentData.controlLimitDashPattern
            ))
            .accessibilityLabel("Lower control limit: \(String(format: "%.1f", value)) beads")
    }
    
    // MARK: - Accessibility Helpers
    
    /// Generates descriptive accessibility hint text explaining the chart content
    /// - Parameter limits: The statistical control limits to describe
    /// - Returns: A comprehensive description of the chart for screen readers
    private func accessibilityHintText(limits: (mean: Double, upperLimit: Double, lowerLimit: Double)) -> String {
        let range = limits.upperLimit - limits.mean
        let workerCount = experimentData.workers.count
        let dayCount = experimentData.totalExperimentDays
        
        // Break down the complex string interpolation into simpler parts
        let workerText = workerCount == 1 ? "1 worker" : "\(workerCount) workers"
        let dayText = dayCount == 1 ? "1 day" : "\(dayCount) days"
        let meanText = String(format: "%.1f", limits.mean)
        let rangeText = String(format: "%.1f", range)
        
        return "Shows daily bead counts for \(workerText) over \(dayText). Process average is \(meanText) beads with control limits at plus or minus \(rangeText) beads from the mean."
    }
}
