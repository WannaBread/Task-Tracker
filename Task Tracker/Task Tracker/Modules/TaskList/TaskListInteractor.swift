import Foundation

final class TaskListInteractor: TaskListBusinessLogic {
    var presenter: TaskListPresentationLogic?
    var provider: TaskListProviderProtocol?
    var worker: TaskListWorker?

    // D2: retain the active fetch task so it can be cancelled on retry.
    private var fetchTask: Task<Void, Never>?

    private var currentTasks: [TaskItem] = []

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
                let response = TaskList.Fetch.Response(result: .success(tasks))
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

    // MARK: - Delete

    func deleteTask(request: TaskList.Delete.Request) {
        let index = request.index
        guard index < currentTasks.count else { return }
        let taskId = currentTasks[index].id

        Task { [weak self] in
            guard let self else { return }
            do {
                try await self.provider?.deleteTask(id: taskId)
                self.currentTasks.remove(at: index)
                let response = TaskList.Delete.Response(result: .success(()))
                await MainActor.run {
                    self.presenter?.presentDelete(response: response)
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
        let index = request.index
        guard index < currentTasks.count else { return }
        let taskId = currentTasks[index].id

        Task { [weak self] in
            guard let self else { return }
            do {
                let updated = try await self.provider?.toggleCompletion(id: taskId)
                if let updated {
                    self.currentTasks[index] = updated
                }
                let item = updated ?? self.currentTasks[index]
                let response = TaskList.ToggleCompletion.Response(result: .success(item))
                await MainActor.run {
                    self.presenter?.presentToggle(response: response)
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
