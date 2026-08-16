public final class SensitiveActionCoordinator {
    private let sessionStore: MemorySessionStore
    private let clientPolicy: ClientPolicyEvaluator
    private let requestFactory: ExportRequestFactory
    private let exportAPI: MockExportAPI

    public init(sessionStore: MemorySessionStore, exportAPI: MockExportAPI) {
        self.sessionStore = sessionStore
        self.clientPolicy = ClientPolicyEvaluator()
        self.requestFactory = ExportRequestFactory()
        self.exportAPI = exportAPI
    }

    @inline(never)
    public func exportReport(requestedOwnerID: String) -> ExportResult {
        guard let session = sessionStore.currentSession() else {
            return ExportResult(
                outcome: .deniedByClient,
                reason: "No local session",
                trace: ["client.denied no session"]
            )
        }

        let clientDecision = clientPolicy.evaluate(
            session: session,
            requestedOwnerID: requestedOwnerID
        )

        guard clientDecision.allowed else {
            return ExportResult(
                outcome: .deniedByClient,
                reason: clientDecision.reason,
                trace: ["client.denied \(clientDecision.reason)"]
            )
        }

        let request = requestFactory.makeRequest(
            session: session,
            requestedOwnerID: requestedOwnerID
        )
        return exportAPI.perform(request)
    }
}
