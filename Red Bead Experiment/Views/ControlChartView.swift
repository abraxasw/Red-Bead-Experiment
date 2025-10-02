import SwiftUI
import Charts

/// Displays a statistical process control chart for worker performance
struct ControlChartView: View {
    @ObservedObject var experimentData: ExperimentData

    var body: some View {
        if experimentData.workers.isEmpty {
            ContentUnavailableView(
                "No Data",
                systemImage: "chart.xyaxis.line",
                description: Text("Add workers to see the control chart")
            )
        } else {
            let limits = experimentData.calculateControlLimits()

            Chart {
                ForEach(experimentData.workers) { worker in
                    ForEach(Array(worker.dailyBeadCounts.enumerated()), id: \.offset) { index, count in
                        LineMark(
                            x: .value("Day", "Day \(index + 1)"),
                            y: .value("Beads", count)
                        )
                        .foregroundStyle(by: .value("Worker", worker.name))
                        .accessibilityLabel("\(worker.name), Day \(index + 1), \(count) beads")
                    }
                }

                RuleMark(y: .value("Mean", limits.mean))
                    .foregroundStyle(.gray)
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: ExperimentData.controlLimitDashPattern))
                    .accessibilityLabel("Mean: \(limits.mean, specifier: "%.1f") beads")

                RuleMark(y: .value("Upper Control Limit", limits.upperLimit))
                    .foregroundStyle(.red)
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: ExperimentData.controlLimitDashPattern))
                    .accessibilityLabel("Upper control limit: \(limits.upperLimit, specifier: "%.1f") beads")

                RuleMark(y: .value("Lower Control Limit", limits.lowerLimit))
                    .foregroundStyle(.red)
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: ExperimentData.controlLimitDashPattern))
                    .accessibilityLabel("Lower control limit: \(limits.lowerLimit, specifier: "%.1f") beads")
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .chartXAxis {
                AxisMarks(values: .automatic(desiredCount: 5))
            }
            .padding()
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Statistical control chart showing worker performance over time")
            .accessibilityHint("Shows daily bead counts for each worker with control limits at \(limits.mean, specifier: "%.1f") plus or minus \(limits.upperLimit - limits.mean, specifier: "%.1f") beads")
        }
    }
}
