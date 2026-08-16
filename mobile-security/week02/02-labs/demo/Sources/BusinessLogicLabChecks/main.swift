import BusinessLogicCore
import Foundation

var failures = 0

@MainActor
func check(_ condition: @autoclosure () -> Bool, _ name: String) {
    if condition() {
        print("PASS: \(name)")
    } else {
        failures += 1
        print("FAIL: \(name)")
    }
}

let runner = LabScenarioRunner()

let baseline = runner.run(.baseline)
check(baseline.outcome == .allowed, "owned premium export is allowed")
check(
    baseline.trace.contains { $0.contains("authoritative session and ownership") },
    "baseline uses authoritative authorization"
)

let localTamper = runner.run(.localTamper)
check(localTamper.outcome == .deniedByServer, "local tamper is denied by secure server")
check(
    localTamper.trace.contains { $0.contains("owner mismatch") },
    "secure server checks resource ownership"
)

let vulnerable = runner.run(.serverTrustsClient)
check(vulnerable.outcome == .allowed, "vulnerable mode demonstrates the authorization flaw")
check(
    vulnerable.trace.contains { $0.contains("untrusted client claims") },
    "vulnerable mode records the untrusted decision source"
)

if failures > 0 {
    print("\(failures) check(s) failed")
    exit(1)
}

print("All business authorization checks passed")
