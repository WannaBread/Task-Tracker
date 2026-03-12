import Foundation

final class AuthWorker {
    func validate(email: String) -> Bool {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }
        return trimmed.contains("@") && trimmed.contains(".")
    }

    func validate(password: String) -> Bool {
        return password.count >= 6
    }
}
