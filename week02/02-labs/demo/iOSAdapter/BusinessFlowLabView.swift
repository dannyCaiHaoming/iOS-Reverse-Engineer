import BusinessLogicCore
import SwiftUI

struct BusinessFlowLabView: View {
    @State private var selectedScenario: LabScenario = .baseline
    @State private var result: ExportResult?

    private let runner = LabScenarioRunner()

    var body: some View {
        Form {
            Section("Scenario") {
                Picker("Mode", selection: $selectedScenario) {
                    ForEach(LabScenario.allCases, id: \.rawValue) { scenario in
                        Text(scenario.rawValue).tag(scenario)
                    }
                }

                Button("Run Export Flow") {
                    result = runner.run(selectedScenario)
                }
            }

            if let result {
                Section("Decision") {
                    LabeledContent("Outcome", value: result.outcome.rawValue)
                    Text(result.reason)
                }

                Section("Trace") {
                    ForEach(Array(result.trace.enumerated()), id: \.offset) { _, event in
                        Text(event)
                            .font(.caption.monospaced())
                    }
                }
            }
        }
        .navigationTitle("Business Flow Lab")
    }
}
