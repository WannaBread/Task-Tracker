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