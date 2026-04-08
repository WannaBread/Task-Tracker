# Task Tracker — Project Overview

## Purpose
An iOS task management app built with UIKit. Users authenticate, view a list of tasks fetched from a remote API, and (eventually) view/edit individual tasks. The project is in active development; the Auth module is complete, TaskList is partially implemented, and TaskDetail is scaffolded but unfinished.

---

## Architecture

**Pattern:** YARCH (View → Interactor → Presenter → Entity → Router)
**Language:** Swift 5.9+, UIKit

### Data Flow (per module)
```
User interaction
  → View (UIView delegate callback)
    → ViewController (AuthDisplayLogic / TaskListDisplayLogic)
      → Interactor (business logic, async work)
        → Provider (bridges Interactor ↔ Service)
          → Service (AuthServiceProtocol / TaskServiceProtocol)
            → NetworkClient → API / Bundle JSON
        → Presenter (formats response into ViewModel)
          → ViewController → View (renders state)
```

### Navigation
`SceneDelegate` sets the root to `AuthViewController`. On successful login, `AuthRouter` replaces the root with a `UINavigationController` wrapping `TaskListViewController`. `TaskListRouter` stubs exist for navigating to TaskDetail and CreateTask but are not yet implemented.

---

## File Tree

```
Task Tracker/Task Tracker/
│
├── AppDelegate.swift                  # App lifecycle, Core Data stack (unused in current flow)
├── SceneDelegate.swift                # Root window setup → AuthViewController
│
├── Models/
│   ├── DomainModels.swift             # UserSession, TaskItem, TaskPriority, RecurrenceRule, ReminderSettings
│   ├── TaskItemDTO.swift              # TaskItemDTO (Codable) + toTaskItem() mapping
│   ├── DTOs.swift                     # LoginRequest/Response, TaskListResponse, TaskDetailResponse,
│   │                                  # CreateTaskRequest, UpdateTaskRequest
│   └── Errors.swift                   # AppError enum with localizedMessage
│
├── Networking/
│   ├── NetworkClient.swift            # NetworkClientProtocol, URLSessionNetworkClient, BundleNetworkClient
│   ├── NetworkConfig.swift            # useLocalFallback flag, localTodoFileName
│   └── NetworkError.swift             # NetworkError enum + asAppError() mapping
│
├── Services/
│   ├── AuthServiceProtocol.swift      # login(request:) async throws, logout() async throws
│   ├── TaskServiceProtocol.swift      # fetchTasks, fetchTask, createTask, updateTask, toggleCompletion, deleteTask
│   ├── SessionManagerProtocol.swift   # currentSession, save, loadSession, clearSession, isAuthorized
│   ├── EchoAPIService.swift           # Real TaskServiceProtocol impl — hits https://alfaitmo.ru/server/echo/409172/todos
│   │                                  # createTask/updateTask throw "not supported"; toggleCompletion is optimistic local-only
│   ├── MockAuthService.swift          # Hardcoded credentials: admin@task.app / password123, 1s simulated delay
│   └── MockTaskService.swift          # All methods throw AppError.unknown — placeholder only
│
├── DataStore/
│   ├── SessionDataStore.swift         # Singleton — holds currentSession: UserSession?
│   └── TaskDataStore.swift            # Singleton — holds [TaskItem] array; get/update/remove/add by id
│
└── Modules/
    ├── Auth/                          # STATUS: COMPLETE
    │   ├── AuthContracts.swift        # AuthDisplayLogic, AuthBusinessLogic, AuthPresentationLogic,
    │   │                              # AuthRoutingLogic, AuthProviderProtocol, AuthViewDelegate
    │   ├── AuthDataFlow.swift         # Auth.LifeCycle / Validate / Login (Request/Response/ViewModel),
    │   │                              # AuthViewState (isLoading, errorText, emailError, passwordError, isLoginButtonEnabled)
    │   ├── AuthBuilder.swift          # Wires all YARCH components; injects MockAuthService
    │   ├── AuthViewController.swift   # Hosts AuthView; implements AuthDisplayLogic + AuthViewDelegate
    │   ├── AuthView.swift             # Full UIKit form: email field, password field, error labels, Sign In button,
    │   │                              # activity spinner, debounced real-time validation (0.4s), keyboard handling
    │   ├── AuthPresenter.swift        # Maps Interactor responses → AuthViewState; weak ref to VC
    │   ├── AuthInteractor.swift       # Validates fields via AuthWorker, calls AuthProvider.login(), handles AppError
    │   ├── AuthRouter.swift           # navigateToTaskList() → replaces window root with TaskListVC (cross-dissolve)
    │   ├── AuthProvider.swift         # Wraps AuthServiceProtocol; saves UserSession to SessionDataStore on login
    │   └── AuthWorker.swift           # validate(email:) — regex; validate(password:) — min 6 chars
    │
    ├── TaskList/                      # STATUS: YARCH WIRED, VIEW IS STUB
    │   ├── TaskListContracts.swift    # TaskListDisplayLogic, TaskListBusinessLogic, TaskListPresentationLogic,
    │   │                              # TaskListRoutingLogic, TaskListProviderProtocol, TaskListViewDelegate
    │   ├── TaskListDataFlow.swift     # TaskList.Fetch / SelectTask / Delete / ToggleCompletion / CreateTask,
    │   │                              # TaskListViewState enum (initial/loading/content/empty/error),
    │   │                              # TaskListItemViewModel (id, title, priorityText, dueDateText, isCompleted,
    │   │                              # hasReminder, hasRecurrence)
    │   ├── TaskListBuilder.swift      # Wires YARCH components; injects EchoAPIService
    │   ├── TaskListViewController.swift # Hosts TaskListView; implements display + delegate protocols;
    │   │                              # display methods are empty stubs
    │   ├── TaskListView.swift         # STUB — minimal UIView with update(with state:) skeleton
    │   ├── TaskListPresenter.swift    # Maps [TaskItem] → [TaskListItemViewModel]; handles empty/error states;
    │   │                              # priority text mapping duplicates TaskPriority.title
    │   ├── TaskListInteractor.swift   # fetchTasks (with Task cancellation), deleteTask, toggleCompletion;
    │   │                              # holds currentTasks: [TaskItem] as local state
    │   ├── TaskListRouter.swift       # navigateToTaskDetail() and navigateToCreateTask() — both empty stubs
    │   ├── TaskListProvider.swift     # Wraps TaskServiceProtocol; syncs TaskDataStore on fetch/delete/toggle
    │   └── TaskListWorker.swift       # sortTasksByDate (incomplete first, then createdAt desc), filter(by priority)
    │
    └── TaskDetail/                    # STATUS: SCAFFOLDED, ALL LOGIC IS STUB/fatalError
        ├── TaskDetailContracts.swift  # TaskDetailDisplayLogic, TaskDetailBusinessLogic, TaskDetailPresentationLogic,
        │                              # TaskDetailRoutingLogic, TaskDetailProviderProtocol, TaskDetailViewDelegate
        ├── TaskDetailDataFlow.swift   # TaskDetail.Fetch / ToggleCompletion / Delete / Update,
        │                              # TaskDetailViewState (initial/loading/content/error),
        │                              # TaskDetailContentViewModel (title, description, priorityText, priorityValue,
        │                              # isCompleted, hasReminder, hasRecurrence)
        ├── TaskDetailBuilder.swift    # Wires YARCH components; accepts taskId parameter
        ├── TaskDetailViewController.swift # Hosts TaskDetailView; all display methods empty
        ├── TaskDetailView.swift       # STUB
        ├── TaskDetailPresenter.swift  # STUB — all protocol methods empty
        ├── TaskDetailInteractor.swift # STUB — stores taskId, all methods empty
        ├── TaskDetailRouter.swift     # navigateBack() — empty stub
        ├── TaskDetailProvider.swift   # STUB — all methods fatalError()
        └── TaskDetailWorker.swift     # validateTitle(_:) — always returns true (stub)
```

---

## Domain Models

```swift
struct UserSession { token, userId, email }

enum TaskPriority: Int { low=0, medium=1, high=2, critical=3 }  // Comparable, has .title: String

struct TaskItem {
    id, title, taskDescription: String
    priority: TaskPriority
    isCompleted: Bool
    createdAt: Date
    dueDate: Date?
    reminder: ReminderSettings?     // startDate, interval, isEnabled
    recurrence: RecurrenceRule?     // .weekly([Int]) | .monthly(Int) | .yearly(month:day:)
}
```

`TaskItemDTO` (Codable) maps from the API JSON to `TaskItem` via `toTaskItem()`. The API returns `priority` as Int, `dueDate` as `"yyyy-MM-dd"` string, and recurrence/reminder as nested objects.

---

## API

- **Endpoint:** `GET https://alfaitmo.ru/server/echo/409172/todos`
- **Returns:** `[TaskItemDTO]` (array of task objects)
- **Supported operations:** fetch list only — create/update are not supported by this echo API
- **Local fallback:** `BundleNetworkClient` reads from a bundled `.json` file; toggled via `NetworkConfig.useLocalFallback`

---

## Known Issues / Design Debt

| Area | Issue |
|------|-------|
| `EchoAPIService` | `createTask`/`updateTask` throw "not supported" — violates `TaskServiceProtocol` contract (LSP) |
| `TaskServiceProtocol` | Too broad (6 methods); consumers can't depend on the full interface reliably |
| `TaskListProvider` | Directly accesses `TaskDataStore.shared` singleton — should be injected |
| `AuthRouter` | Directly calls `TaskListBuilder.build()` — couples modules at the router level |
| `TaskListPresenter` | Duplicates `TaskPriority.title` with its own priority→string switch |
| `TaskDetailProvider` | Uses `fatalError()` — will crash at runtime if any TaskDetail flow is triggered |
| `TaskListViewController` | All `display*` methods are empty — TaskList renders nothing |
| `TaskListRouter` | Both navigation methods are empty stubs |
| `SessionManagerProtocol` | Defined but `SessionDataStore` does not conform to it; unused as an abstraction |

---

## Implementation Status

| Module | Contracts | Builder | Interactor | Presenter | View | Router |
|--------|-----------|---------|------------|-----------|------|--------|
| Auth | Complete | Complete | Complete | Complete | Complete | Complete |
| TaskList | Complete | Complete | Complete | Complete | **Stub** | **Stub** |
| TaskDetail | Complete | Complete | **Stub** | **Stub** | **Stub** | **Stub** |
