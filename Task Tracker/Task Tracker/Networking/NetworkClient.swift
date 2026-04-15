import Foundation

// MARK: - NetworkClientProtocol

protocol NetworkClientProtocol {
    func fetch<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T
    func send<Body: Encodable, Response: Decodable>(
        _ body: Body,
        to url: URL,
        method: String,
        responseType: Response.Type
    ) async throws -> Response
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

    func send<Body: Encodable, Response: Decodable>(
        _ body: Body,
        to url: URL,
        method: String,
        responseType: Response.Type
    ) async throws -> Response {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            throw NetworkError.underlying(error)
        }

        let data: Data
        let urlResponse: URLResponse

        do {
            (data, urlResponse) = try await session.data(for: request)
        } catch let urlError as URLError where urlError.code == .cancelled {
            throw NetworkError.cancelled
        } catch {
            throw NetworkError.underlying(error)
        }

        if let http = urlResponse as? HTTPURLResponse,
           !(200...299).contains(http.statusCode) {
            throw NetworkError.requestFailed(statusCode: http.statusCode)
        }

        guard !data.isEmpty else {
            throw NetworkError.noData
        }

        do {
            return try JSONDecoder().decode(responseType, from: data)
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

    /// Локальный фолбэк не поддерживает запись — симулируем echo, декодируя отправленное тело обратно.
    func send<Body: Encodable, Response: Decodable>(
        _ body: Body,
        to url: URL,
        method: String,
        responseType: Response.Type
    ) async throws -> Response {
        let data = try JSONEncoder().encode(body)
        do {
            return try JSONDecoder().decode(responseType, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
}
