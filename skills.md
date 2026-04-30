# Trackyond - Architectural Standards & Skills

This document defines the strict architectural standards and development patterns for the Trackyond workspace. All contributions must adhere to these rules without exception.

---

## 1. Clean Architecture (Layered)
The project follows a strict three-layer architecture to ensure testability, scalability, and maintainability.

### A. Domain Layer (The Core)
- **Entities**: Plain Dart objects that represent the business data.
- **Use Cases**: Individual units of business logic (e.g., `GetTeamStatusUseCase`). Must inherit from `BaseUseCase`.
- **Repository Interfaces**: `abstract interface class I[Feature]Repository` defining the contract for data operations.
- **Rule**: This layer must have **zero** dependencies on other layers or external packages (except for `fpdart` and `equatable`/`freezed` if necessary).

### B. Data Layer (Implementation)
- **Models (DTOs)**: Data Transfer Objects used for API serialization.
- **Rule**: Always use `sealed class` with `@freezed`.
- **Rule**: Models must include a `toEntity()` method to map data to Domain Entities.
- **Subfolders**: Organize complex models into subfolders (e.g., `models/user/`, `models/attendance/`).
- **Data Sources**: Handle raw API calls. Inherit from `BaseRemoteDataSource` and use `performApiRequest`.
- **Repositories**: Implementation of Domain interfaces. Map `ApiResponse` to `Either<AppFailure, T>`.

### C. Presentation Layer (UI & Logic)
- **Screens**: UI widgets inheriting from `GetView<T>`.
- **Controllers**: Manage state using GetX. Use constructor injection for Use Cases.
- **Bindings**: Setup dependency injection using `Get.lazyPut`.
- **Widgets**: Feature-specific UI components.

---

## 2. Feature & Folder Structure
Features are organized by user role to prevent logic leakage and ensure clear separation.

- **Path**: `lib/features/{role}/{feature_name}/`
- **Roles**: `owner/`, `worker/`, `auth/` (shared).
- **Internal Structure**:
  ```text
  feature/
  ├── data/
  │   ├── datasources/
  │   ├── models/ (with subfolders if needed)
  │   └── repositories/
  ├── domain/
  │   ├── entities/
  │   ├── repositories/ (interfaces)
  │   └── usecases/
  └── presentation/
      ├── bindings/
      ├── controllers/
      ├── screens/
      └── widgets/
  ```

---

## 3. UI as a "Slave" (Logic-Free UI)
The UI layer is strictly for rendering and user interaction delegation.

- **No Business Logic**: No calculations or complex conditions in widgets.
- **No Validation Logic**: Handled by the controller.
- **No Direct Routing**: Navigation (e.g., `Get.toNamed`) must be triggered from the Controller.
- **Pattern**: UI consumes data from the controller and calls controller methods for actions.
- **GetView**: Always use `GetView<Controller>` for screens.

---

## 4. Indirect Service Access & Facades
To maintain architectural boundaries, feature controllers must not interact with global services directly.

- **AuthController Facade**: Acts as the bridge for global state.
- **Rule**: Features use `Get.find<AuthController>()` to access:
  - Global state (e.g., `ownerName`, `companyName`).
  - Auth actions (e.g., `logout()`).
  - Common user data fetched via Use Cases.
- **Reactivity**: `AuthController` provides reactive getters (linking to underlying `UserService` observables) so the UI stays responsive via `Obx`.

---

## 5. Centralized Constants & Tokens
Avoid hardcoding any values. Use the centralized constant files.

- **AppStrings**: Use `lib/core/constants/app_strings.dart`. All strings must be **getters**.
- **AppUIConstants**: Use `lib/core/constants/app_ui_constants.dart` for spacing, radius, and common layout boxes (getters).
- **ApiEndpoints**: Centralize all URLs in `lib/core/network/api/api_endpoints.dart`.
- **AppIcons**: Centralize all icons in `lib/core/constants/app_icons.dart`.
- **Theme Extensions**: Access theme tokens via `context.theme.colorScheme.[customToken]` or `context.textTheme`.

---

## 6. Development Patterns
- **Unified Button System**: Use `AppButton.filled()`, `.outlined()`, etc. Never use standard Flutter buttons directly.
- **Gap-Based Spacing**: Use the `spacing` property in `Column` and `Row` instead of `SizedBox` between items.
- **Sealed Classes**: Always use `sealed class` for `@freezed` models to leverage exhaustive pattern matching.
- **ApiResponse Pattern**: Use `ApiResponse<T>` in controllers to handle `loading`, `success`, and `error` states uniformly.
- **Multiple Bindings**: Routes can have multiple bindings in `AppPages` to share state across features.
- **Initialization**: Controllers should handle initial data fetching in `onInit` or `onReady` depending on whether they need route arguments.

---

## 7. Quality Assurance
- **Dart Analyze**: Always run `dart analyze` after generating or modifying code. Fix all issues before completion.
- **No Todos**: Ensure the codebase is clean of temporary comments and unused imports.

---
*Maintained by Antigravity AI*
