public enum LabScenario: String, CaseIterable, Hashable {
    case baseline
    case localTamper = "local-tamper"
    case serverTrustsClient = "server-trusts-client"
}

public struct LabScenarioRunner {
    public init() {}

    @inline(never)
    public func run(_ scenario: LabScenario) -> ExportResult {
        let identity = MockIdentityService()
        let sessionStore = MemorySessionStore()

        switch scenario {
        case .baseline:
            sessionStore.save(identity.signIn(userID: "alice"))
            let coordinator = SensitiveActionCoordinator(
                sessionStore: sessionStore,
                exportAPI: MockExportAPI(mode: .secure)
            )
            return coordinator.exportReport(requestedOwnerID: "alice")

        case .localTamper:
            sessionStore.save(identity.signIn(userID: "bob"))
            sessionStore.overwriteCachedClaimsForLab(role: .analyst, isPremium: true)
            let coordinator = SensitiveActionCoordinator(
                sessionStore: sessionStore,
                exportAPI: MockExportAPI(mode: .secure)
            )
            return coordinator.exportReport(requestedOwnerID: "alice")

        case .serverTrustsClient:
            sessionStore.save(identity.signIn(userID: "bob"))
            sessionStore.overwriteCachedClaimsForLab(role: .analyst, isPremium: true)
            let coordinator = SensitiveActionCoordinator(
                sessionStore: sessionStore,
                exportAPI: MockExportAPI(mode: .trustsClientClaims)
            )
            return coordinator.exportReport(requestedOwnerID: "alice")
        }
    }
}
