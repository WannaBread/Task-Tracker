import Foundation

// MARK: - NetworkConfig (D3)

struct NetworkConfig {
    /// Flip to true to serve requests from a local JSON bundle file instead of the live API.
    static let useLocalFallback: Bool = false

    /// The name of the bundle JSON file used when useLocalFallback is true (without extension).
    static let localTodoFileName: String = "todos"
}
