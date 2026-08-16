public struct ClientPolicyDecision: Equatable {
    public let allowed: Bool
    public let reason: String

    public init(allowed: Bool, reason: String) {
        self.allowed = allowed
        self.reason = reason
    }
}

public struct ClientPolicyEvaluator {
    public init() {}

    @inline(never)
    public func evaluate(session: SessionSnapshot, requestedOwnerID: String) -> ClientPolicyDecision {
        guard session.isPremium else {
            return ClientPolicyDecision(allowed: false, reason: "Premium subscription required")
        }

        guard session.role == .analyst || session.role == .administrator else {
            return ClientPolicyDecision(allowed: false, reason: "Analyst role required")
        }

        return ClientPolicyDecision(allowed: true, reason: "Client policy passed")
    }
}

public struct ExportRequestFactory {
    public init() {}

    @inline(never)
    public func makeRequest(session: SessionSnapshot, requestedOwnerID: String) -> ExportRequest {
        ExportRequest(
            bearerToken: session.token,
            requestedOwnerID: requestedOwnerID,
            claimedRole: session.role,
            claimedPremium: session.isPremium
        )
    }
}
