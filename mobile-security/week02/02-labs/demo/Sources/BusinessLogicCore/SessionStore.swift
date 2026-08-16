public final class MemorySessionStore {
    private var cachedSession: SessionSnapshot?

    public init() {}

    @inline(never)
    public func save(_ session: SessionSnapshot) {
        cachedSession = session
    }

    @inline(never)
    public func currentSession() -> SessionSnapshot? {
        cachedSession
    }

    @inline(never)
    public func overwriteCachedClaimsForLab(role: UserRole, isPremium: Bool) {
        cachedSession?.role = role
        cachedSession?.isPremium = isPremium
    }
}

public final class MockIdentityService {
    public init() {}

    @inline(never)
    public func signIn(userID: String) -> SessionSnapshot {
        switch userID {
        case "alice":
            return SessionSnapshot(
                token: "lab-token-alice",
                userID: "alice",
                role: .analyst,
                isPremium: true
            )
        default:
            return SessionSnapshot(
                token: "lab-token-bob",
                userID: "bob",
                role: .viewer,
                isPremium: false
            )
        }
    }
}
