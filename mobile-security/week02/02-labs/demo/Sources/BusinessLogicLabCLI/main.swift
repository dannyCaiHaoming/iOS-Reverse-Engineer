import BusinessLogicCore
import Foundation

func printUsage() {
    let scenarios = LabScenario.allCases.map(\.rawValue).joined(separator: ", ")
    print("Usage: BusinessLogicLabCLI [\(scenarios)|all]")
}

func printResult(scenario: LabScenario, result: ExportResult) {
    print("=== \(scenario.rawValue) ===")
    print("outcome: \(result.outcome.rawValue)")
    print("reason: \(result.reason)")
    for event in result.trace {
        print("trace: \(event)")
    }
}

let argument = CommandLine.arguments.dropFirst().first ?? "all"
let runner = LabScenarioRunner()

if argument == "all" {
    for scenario in LabScenario.allCases {
        printResult(scenario: scenario, result: runner.run(scenario))
        print("")
    }
} else if let scenario = LabScenario(rawValue: argument) {
    printResult(scenario: scenario, result: runner.run(scenario))
} else {
    printUsage()
    exit(2)
}
