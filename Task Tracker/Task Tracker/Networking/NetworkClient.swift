import Foundation

// MARK: - NetworkClientProtocol

protocol NetworkClientProtocol {
    func fetch<T: Decodable & Sendable>(_ type: T.Type, from url: URL) async throws -> T
}

// MARK: - URLSessionNetworkClient

final class URLSessionNetworkClient: NetworkClientProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetch<T: Decodable & Sendable>(_ type: T.Type, from url: URL) async throws -> T {
        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(from: url)
        } catch let urlError as URLError where urlError.code == .cancelled {
            throw NetworkError.cancelled
        } catch {
            throw NetworkError.underlying(error)
        }

        if let http = response as? HTTPURLResponse,
           !(200...299).contains(http.statusCode) {
            throw NetworkError.requestFailed(statusCode: http.statusCode)
        }

        guard !data.isEmpty else {
            throw NetworkError.noData
        }

        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
}

// MARK: - BundleNetworkClient

final class BundleNetworkClient: NetworkClientProtocol {
    private let bundle: Bundle
    private let decoder: JSONDecoder

    init(bundle: Bundle = .main, decoder: JSONDecoder = JSONDecoder()) {
        self.bundle = bundle
        self.decoder = decoder
    }

    func fetch<T: Decodable & Sendable>(_ type: T.Type, from url: URL) async throws -> T {
        // Derive the resource name from the URL path (e.g. ".../todos" → "todos").
        let fileName = url.deletingPathExtension().lastPathComponent

        guard let fileURL = bundle.url(forResource: fileName, withExtension: "json") else {
            throw NetworkError.badURL
        }

        let data: Data
        do {
            data = try Data(contentsOf: fileURL)
        } catch {
            throw NetworkError.underlying(error)
        }

        guard !data.isEmpty else {
            throw NetworkError.noData
        }

        do {
            return try decoder.decode(type, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
}
