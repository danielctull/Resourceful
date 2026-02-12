
public struct Recover: Error {
  private let recover: @Sendable (Network) async throws -> Void

  public init(recover: @Sendable @escaping (Network) async throws -> Void) {
    self.recover = recover
  }
}

extension Recover {
  func callAsFunction(with network: Network) async throws -> Void {
    try await recover(network)
  }
}
