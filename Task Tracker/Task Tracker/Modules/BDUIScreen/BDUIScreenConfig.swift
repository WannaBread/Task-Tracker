import Foundation

struct BDUIScreenConfig {
    let title: String
    let source: Source

    enum Source {
        case remote(endpoint: String)
    }
}
