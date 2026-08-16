import Foundation

public enum UserRole: String, Equatable {
    case viewer
    case analyst
    case administrator
}

public struct SessionSnapshot: Equatable {
    public let token: String
    public let userID: String
    public var role: UserRole
    public var isPremium: Bool

    public init(token: String, userID: String, role: UserRole, isPremium: Bool) {
        self.token = token
        self.userID = userID
        self.role = role
        self.isPremium = isPremium
    }
}

public struct ExportRequest: Equatable {
    public let bearerToken: String
    public let requestedOwnerID: String
    public let claimedRole: UserRole
    public let claimedPremium: Bool

    public init(
        bearerToken: String,
        requestedOwnerID: String,
        claimedRole: UserRole,
        claimedPremium: Bool
    ) {
        self.bearerToken = bearerToken
        self.requestedOwnerID = requestedOwnerID
        self.claimedRole = claimedRole
        self.claimedPremium = claimedPremium
    }
}

public enum ExportOutcome: String, Equatable {
    case allowed
    case deniedByClient
    case deniedByServer
}

public struct ExportResult: Equatable {
    public let outcome: ExportOutcome
    public let reason: String
    public let trace: [String]

    public init(outcome: ExportOutcome, reason: String, trace: [String]) {
        self.outcome = outcome
        self.reason = reason
        self.trace = trace
    }
}

public enum ServerAuthorizationMode: String {
    case secure
    case trustsClientClaims
}
