# Task Tracker

## How to Run

1. Open `Task Tracker/Task Tracker.xcodeproj` in Xcode
2. Select any iPhone simulator (tested on iPhone SE and iPhone 16)
3. Press **Cmd+R** to build and run

## Auth Credentials

| Field    | Value              |
|----------|--------------------|
| Email    | `admin@task.app`   |
| Password | `password123`      |

- **Invalid credentials** → inline error message is displayed
- **Valid credentials** → loading indicator, then navigates to the Task List screen

## Architecture

**YARCH** (Yet Another Router / Clean Handler architecture)

**Rationale:**
- Builder + DI: assembly and dependencies are managed in `Builder`, ensuring loose coupling and dependency injection
- Provider layer offloads Interactor from direct network/cache interaction
- Worker encapsulates computational logic (validation, filtering) into independent units
- Inter-module navigation via Router uses identifiers (IDs); shared data is accessed through DataStores

## Modules

| Module       | Description                                                            |
|--------------|------------------------------------------------------------------------|
| **Auth**     | Login screen: input validation, service call, session creation, routing |
| **TaskList** | Task list: loading, deletion, completion toggle, filtering             |
| **TaskDetail**| Task details: view, create, edit (priority, reminders, recurrence)    |

## Screens

### 1. Auth
- **Entry:** app launch (root screen)
- **Exit:** successful login → navigates to TaskList
- **Flow:** User enters credentials → Worker validates format → Provider calls AuthService → Session saved to SessionDataStore → Router replaces root with TaskList

### 2. TaskList
- **Entry:** active UserSession required
- **Exit:** passes `taskId` to Router for navigation to TaskDetail
- **Flow:** View displays TaskListViewState via Presenter. Select/Swipe actions forwarded to Interactor → Provider updates data → View refreshes

### 3. TaskDetail
- **Entry:** receives `taskId` from TaskList Router
- **Exit:** saves state, Router navigates back to TaskList
- **Flow:** Builder injects `taskId` → Provider fetches from TaskDataStore → Presenter formats dates/priorities → Worker validates edits → Provider saves

## Key Protocols & Models

**Protocols:**
- `BusinessLogic` — module business logic (Interactor)
- `PresentationLogic` — ViewModel preparation (Presenter)
- `DisplayLogic` — UI state updates (ViewController)
- `ProviderProtocol` — data access contract (Service + DataStore)

**Models:**
- `TaskItem` — core task entity
- `TaskPriority` — importance level (Enum)
- `ReminderSettings` — reminder configuration (start date + interval)
- `RecurrenceRule` — recurrence rules (yearly / monthly / weekly)
- `DataFlow` containers — `Request`, `Response`, `ViewModel` for inter-layer data exchange

---

## Лабораторная №4

### API

**Alfa ITMO Echo API** — `https://alfaitmo.ru/server/echo/409172/todos`

Endpoint: `GET https://alfaitmo.ru/server/echo/409172/todos`

Пример ответа (массив на верхнем уровне):

```json
[
  {
    "id": "1",
    "title": "Подготовить презентацию",
    "taskDescription": "Для защиты лабораторной работы",
    "priority": 2,
    "isCompleted": false,
    "dueDate": "2026-03-28",
    "reminder": {
      "startDate": "2026-03-28",
      "interval": 3600,
      "isEnabled": true
    },
    "recurrence": null
  },
  {
    "id": "2",
    "title": "Написать unit-тесты",
    "taskDescription": "Покрыть Interactor и Presenter",
    "priority": 1,
    "isCompleted": true,
    "dueDate": "2026-03-25",
    "reminder": null,
    "recurrence": {
      "type": "weekly",
      "daysOfWeek": [1, 3, 5],
      "dayOfMonth": null,
      "month": null,
      "day": null
    }
  }
]
```

Данные залиты через `PUT`. DTO — `TaskItemDTO` (`Models/TodoDTO.swift`).

### Поля в TaskListItemViewModel

| Поле | Откуда берётся |
|---|---|
| `id` | `TaskItemDTO.id` |
| `title` | `TaskItemDTO.title` |
| `priorityText` | `TaskItemDTO.priority` (0–3) → `TaskPriority.title` ("Low"/"Medium"/"High"/"Critical") |
| `dueDateText` | `TaskItemDTO.dueDate` ("yyyy-MM-dd") → форматированная строка или `nil` |
| `isCompleted` | `TaskItemDTO.isCompleted` |
| `hasReminder` | `TaskItemDTO.reminder != nil` |
| `hasRecurrence` | `TaskItemDTO.recurrence != nil` |

### Как проверить

1. Собрать и запустить проект в Xcode (симулятор)
2. Залогиниться: `admin@task.app` / `password123`
3. После успешного логина открывается экран TaskList — в это момент Interactor вызывает `fetchTasks`

## Допы

### D1 — Своя модель ошибок

Реализован тип `NetworkError` (`Networking/NetworkError.swift`) со случаями:
- `.badURL` — невалидный URL
- `.requestFailed(statusCode:)` — HTTP-ошибка не 2xx
- `.noData` — пустой ответ
- `.decodingFailed(Error)` — ошибка парсинга
- `.cancelled` — запрос отменён
- `.underlying(Error)` — прочие сетевые ошибки

### D2 — Отмена запроса

В `TaskListInteractor` хранится `private var fetchTask: Task<Void, Never>?`. При каждом вызове `fetchTasks` предыдущий Task отменяется (`fetchTask?.cancel()`), результат старого запроса игнорируется через `guard !Task.isCancelled`. 

### D3 — Локальный fallback для отладки

В `Networking/NetworkConfig.swift` есть флаг:

```swift
static let useLocalFallback: Bool = false
```

При значении `true` вместо URLSession используется `BundleNetworkClient`, который читает `todos.json`
## Лабораторная №5

### Экран списка задач

#### Подход к реализации

`UITableView` с выделенным классом `TaskListTableManager`, который инкапсулирует `UITableViewDataSource` и `UITableViewDelegate`. Это разгружает `ViewController` и сохраняет чёткое разделение ответственностей в YARCH-архитектуре.

#### Как запустить

1. Собрать и запустить проект в Xcode (симулятор)
2. Залогиниться: `admin@task.app` / `password123`
3. После успешного входа автоматически открывается экран со списком задач

#### Состояния экрана

| Состояние | Описание |
|---|---|
| **Loading** | Спиннер при первоначальной загрузке и pull-to-refresh |
| **Content** | Таблица с ячейками задач (название, приоритет, дата, статус выполнения) |
| **Empty** | Центрированный лейбл «Нет задач», если список пустой |
| **Error** | Сообщение об ошибке + кнопка «Повторить» для повторного запроса |

#### Навигация

Нажатие на ячейку выполняет push-переход на экран TaskDetail (заглушка).

#### Допы

- **D1 — Pull-to-refresh**: `UIRefreshControl` на таблице. Повторно вызывает `fetchTasks` через интерактор.
- **D2 — Поиск**: `UISearchController` в навигационном баре. Локальная фильтрация `[TaskListItemViewModel]` по подстроке заголовка (без повторного сетевого запроса), реализована в `TaskListTableManager.filter(by:in:)`.
