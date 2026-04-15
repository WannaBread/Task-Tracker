import Foundation

final class TaskListInteractor: TaskListBusinessLogic {
    var presenter: TaskListPresentationLogic?
    var provider: TaskListProviderProtocol?
    var worker: TaskListWorker?

    private var fetchTask: Task<Void, Never>?

    private var currentTasks: [TaskItem] = []
    private var currentSearchQuery: String = ""

    // MARK: - Fetch

    func fetchTasks(request: TaskList.Fetch.Request) {
        fetchTask?.cancel()

        presenter?.presentLoading()

        fetchTask = Task { [weak self] in
            guard let self else { return }
            do {
                let tasks = try await self.provider?.fetchTasks() ?? []
                guard !Task.isCancelled else { return }
                self.currentTasks = tasks
                let filtered = self.worker?.search(tasks: tasks, query: self.currentSearchQuery) ?? tasks
                let response = TaskList.Fetch.Response(result: .success(filtered))
                await MainActor.run {
                    self.presenter?.presentTasks(response: response)
                }
            } catch let appError as AppError {
                guard !Task.isCancelled else { return }
                let response = TaskList.Fetch.Response(result: .failure(appError))
                await MainActor.run {
                    self.presenter?.presentTasks(response: response)
                }
            } catch {
                guard !Task.isCancelled else { return }
                let response = TaskList.Fetch.Response(result: .failure(.unknown))
                await MainActor.run {
                    self.presenter?.presentTasks(response: response)
                }
            }
        }
    }

    // MARK: - Search

    func searchTasks(request: TaskList.SearchTasks.Request) {
        currentSearchQuery = request.query ?? ""
        let filtered = worker?.search(tasks: currentTasks, query: currentSearchQuery) ?? currentTasks
        let response = TaskList.Fetch.Response(result: .success(filtered))
        presenter?.presentTasks(response: response)
    }

    // MARK: - Delete

    func deleteTask(request: TaskList.Delete.Request) {
        let taskId = request.id

        Task { [weak self] in
            guard let self else { return }
            do {
                try await self.provider?.deleteTask(id: taskId)
                let cached = self.provider?.cachedTasks ?? []
                self.currentTasks = cached
                let filtered = self.worker?.search(tasks: cached, query: self.currentSearchQuery) ?? cached
                let response = TaskList.Delete.Response(result: .success(()))
                let fetchResponse = TaskList.Fetch.Response(result: .success(filtered))
                await MainActor.run {
                    self.presenter?.presentDelete(response: response)
                    self.presenter?.presentTasks(response: fetchResponse)
                }
            } catch let appError as AppError {
                let response = TaskList.Delete.Response(result: .failure(appError))
                await MainActor.run {
                    self.presenter?.presentDelete(response: response)
                }
            } catch {
                let response = TaskList.Delete.Response(result: .failure(.unknown))
                await MainActor.run {
                    self.presenter?.presentDelete(response: response)
                }
            }
        }
    }

    // MARK: - Toggle

    func toggleCompletion(request: TaskList.ToggleCompletion.Request) {
        let taskId = request.id

        Task { [weak self] in
            guard let self else { return }
            do {
                let updated = try await self.provider?.toggleCompletion(id: taskId)
                let cached = self.provider?.cachedTasks ?? []
                self.currentTasks = cached
                let filtered = self.worker?.search(tasks: cached, query: self.currentSearchQuery) ?? cached
                let item = updated ?? cached.first(where: { $0.id == taskId }) ?? cached[0]
                let response = TaskList.ToggleCompletion.Response(result: .success(item))
                let fetchResponse = TaskList.Fetch.Response(result: .success(filtered))
                await MainActor.run {
                    self.presenter?.presentToggle(response: response)
                    self.presenter?.presentTasks(response: fetchResponse)
                }
            } catch let appError as AppError {
                let response = TaskList.ToggleCompletion.Response(result: .failure(appError))
                await MainActor.run {
                    self.presenter?.presentToggle(response: response)
                }
            } catch {
                let response = TaskList.ToggleCompletion.Response(result: .failure(.unknown))
                await MainActor.run {
                    self.presenter?.presentToggle(response: response)
                }
            }
        }
    }
}
