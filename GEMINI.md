# Trackyond Project Guidelines & Architecture

## 🧠 Core Engineering Principles
All code written for Trackyond must adhere to the following foundational rules:
- **DRY (Don't Repeat Yourself)**: Eliminate duplicated logic by extracting shared utilities and modules.
- **Separation of Concerns**: Each module should handle one distinct responsibility.
- **Single Responsibility Principle (SRP)**: Every class, module, function, or file should have exactly one reason to change.
- **Clear Abstractions & Contracts**: Expose intent through small, stable interfaces and hide implementation details.
- **Low Coupling, High Cohesion**: Keep modules self-contained and minimize cross-dependencies.
- **Scalability & Statelessness**: Design components to scale horizontally and prefer stateless services when possible.
- **Observability & Testability**: Build in logging, metrics, tracing, and ensure components can be unit/integration tested.
- **KISS (Keep It Simple, Stupid)**: Keep solutions as simple as possible.
- **YAGNI (You Aren't Gonna Need It)**: Avoid speculative complexity or over-engineering.

---

This document serves as the source of truth for the Trackyond workspace, covering both the Flutter client and the Python FastAPI server.

## 📱 Client (Flutter)

### 1. Packages & Dependencies
We use a modern and robust set of packages:
- **State Management & Routing**: `get`
- **Networking**: `dio`
- **Functional Programming**: `fpdart`
- **Code Generation**: `freezed`, `json_serializable`, `build_runner`
- **Storage**: `shared_preferences`, `flutter_secure_storage`
- **UI & Styling**: `google_fonts`, `pinput`, `extended_image`, `animations`, `shimmer`
- **Utilities**: `connectivity_plus`, `device_info_plus`, `geolocator`, `package_info_plus`, `intl`, `nanoid`

### 2. Shimmer & Skeleton Standards
To maintain a consistent loading experience across the app:
- **Shimmer Wrapper**: ALWAYS wrap skeleton widgets (e.g., `AppSkeletonText`, `AppSkeletonButton`, `AppSkeletonContainer`) with `AppShimmer`. The skeleton widgets provide the shape, while `AppShimmer` provides the animated color gradient.
- **Example Usage**:
  ```dart
  if (isLoading)
    const AppShimmer(child: AppSkeletonText(width: 150))
  else
    Text(data)
  ```
- **Custom Shapes**: For complex layouts, use `AppSkeletonContainer` with `AppShimmer` to create a custom-shaped placeholder.

### 3. Folder Structure
The project follows a modified Clean Architecture:
- `lib/app`: App-wide configurations, initializers, and main routes.
- `lib/core`: Shared logic, constants, network, services, theme, and common widgets.
  - `lib/core/common`: Shared entities, models, and UI components.
  - `lib/core/constants`: `AppStrings`, `AppIcons`, `AppUIConstants`.
  - `lib/core/network`: API endpoints, Dio client, and interceptors.
- `lib/features`: Feature-based modules (e.g., `auth`, `owner`, `worker`).
  - `data/`: Data Sources, Models, Repositories implementations.
  - `domain/`: Entities, Use Cases, Repository interfaces.
  - `presentation/`: Bindings, Controllers, Screens, Widgets.

**Rule: Categorization & Subfolders**: Use subfolders within `models/`, `entities/`, `widgets/`, or other folders to categorize files by sub-feature or domain logic when the number of files grows or for better structural clarity (e.g., separating `request` and `response` models).

### 3. Constants & Resources
- **Strings**: Centralized in `lib/core/constants/app_strings.dart`. Use getters for all strings. **Strict Rule**: NEVER use hardcoded strings in the UI; always use `AppStrings`.
- **Icons**: Centralized in `lib/core/constants/app_icons.dart`.
- **UI Constants**: `lib/core/constants/app_ui_constants.dart` for spacing, radius, and shadow tokens.
- **Endpoints**: `lib/core/network/api/api_endpoints.dart`. Always add new endpoints here.

### 4. Utilities
Common utilities are located in `lib/core/utils/`.
- `AppUtils`: General purpose helpers.
- `AvatarUtils`: Logic for generating/handling avatars.

### 5. Service & Data Layer
- **Services**: Located in `lib/core/services/`. They handle low-level logic (e.g., `TokenService`, `UserService`).
- **Data Layer Rule**: Controllers must **never** contact Services directly. Controllers interact with UseCases, which interact with Repositories, which may use Services or DataSources.
- **Navigation Rule**: Favor calling a navigation function inside the `Controller` (e.g., `controller.navigateToAddMemberDetails()`) rather than using `Get.toNamed` directly in the UI. This keeps the UI clean and makes navigation logic testable.

### 6. Auth Management
- `AuthController` (in `lib/features/auth`) is a permanent controller (`permanent: true`).
- To access user info anywhere: `final authController = Get.find<AuthController>();`.
- It interacts with `GetAuthenticatedUserUseCase` to fetch user data from the domain layer.

### 7. Base Classes & Naming
- **UseCases**: Must implement `BaseUseCase<SuccessType, Params>`.
- **DataSources**: Use `BaseRemoteDataSource` mixin for standardized API calls.
- **Interfaces**: All Repository and DataSource interfaces must start with `I` (e.g., `IAuthRepository`, `IAuthDataSource`).

### 8. Logic vs UI
- **Logics**: Must reside inside the `Controller`.
- **UI (Screens)**: Must be "slaves" to the controller. Use `GetView<T>` for screens.
- **Widgets**: Do not use widget functions inside a screen file. Create separate files in `feature/widgets/` or `core/common/widgets/`.

### 9. Consistent UI Components
- **Buttons**: Always use `AppButton` factory (`filled`, `outlined`, `ghost`, `custom`).
- **Snackbars**: Use `AppSnackbar` methods (`success`, `destructive`, `warn`, `info`). Do not use `Get.snackbar`.
- **Theming**: Use `context.theme.colorScheme` and extensions from `lib/core/theme/color_scheme_extension.dart`.
- **Typography**: Follow styles defined in `lib/core/theme/text_styles.dart`.
- **Padding**: Maintain consistent page padding (typically `AppUIConstants.spacing.space$16`) across all screens.

### 10. Code Generation & Analysis
- **Build Runner**: Always running in watch mode. Models should use `@freezed` and `@JsonSerializable`.
- **Sealed Classes**: As per latest Freezed documentation, use `sealed class` for your models to ensure exhaustive matching and better structure.
- **Implicit Mapping via Inheritance**: Models should implement the corresponding Entity class so the compiler can implicitly cast and map models to entities without manual `.toEntity()` mapper functions.
- **Analyze**: Run `flutter analyze` regularly to ensure code quality.
- **Entities**: Domain entities should be simple Dart classes and are NOT allowed to use `@freezed`. Use `Equatable` for value equality if needed.

### 11. API Response Styling
- **Casing**: All API responses and model fields MUST use **camelCase**. Do NOT use snake_case in API responses. This ensures consistency with Dart naming conventions and reduces the need for `@JsonKey` mappings.

### 12. Import Rules
- **Package Imports**: ALWAYS use package-based imports (e.g., `import 'package:trackyond/core/...'`) instead of relative imports (e.g., `import '../../core/...'`). This ensures consistency and prevents issues with nested folder structures.

---

## ⚙️ Server/API (Python FastAPI)

### 1. Stack & Packages
- **Framework**: `FastAPI`
- **Server**: `uvicorn`
- **ORM**: `SQLAlchemy` with `psycopg2` for PostgreSQL.
- **Cache**: `redis`
- **Migrations**: `alembic`
- **Auth**: `PyJWT`

### 2. Architecture & Routing
- **Routing**: Folder/file-based nested routing under `api/v1/`.
  - `admin/`: Owner-specific logic.
  - `employee/`: Worker-specific logic.
  - `common/`: Shared resources like file handling.
- **Thin Routers & Fat Services**: All API router files (e.g., `api/v1/.../*.py`) must remain "thin". They should only handle endpoint definitions, dependency injection (extracting `db` and `user`), and returning the final `GenericResponse`. All business logic, database queries (`db.query()`), and data serialization MUST be encapsulated in dedicated service modules inside the `services/` folder (e.g., `services/dashboard_service.py`).
- **Logic**: Encapsulated in `services/` (e.g., `auth_service.py`).

### 3. Requirements & Metadata
- **Device Metadata**: Every endpoint requires device metadata headers (handled via `DeviceMetadataMiddleware`).
- **DateTime**: All datetime fields must be UTC ISO 8601 strings.

### 4. Database & Migrations
- Use `alembic` for all database schema changes.
- Ensure `alembic revision --autogenerate` is used and migrations are applied.

### 5. Docker Environment
Services run via Docker Compose:
- **API**: Port `8000`
- **PostgreSQL**: Port `5432`
- **Redis**: Port `6379`
- **pgAdmin**: Port `5050`

### 6. API Review & Testing
When adding or modifying API endpoints, follow these review steps:
- **Postman**: Create or update requests in the Postman collection to verify endpoint behavior, status codes, and response schemas.
- **Docker Logs**: Monitor logs using `docker-compose logs -f api` to catch runtime errors, validation issues, or database conflicts.
- **Scratch Files**: Use temporary test scripts or scratch files to validate complex logic before integration.


---

## 📝 Code Examples

### Controller Implementation
```dart
class MyController extends GetxController {
  final MyUseCase _myUseCase;

  // Named required constructor for final fields
  MyController({required MyUseCase myUseCase}) : _myUseCase = myUseCase;
  
  // Logic here, UI only calls these methods
  Future<void> fetchData() async { ... }
}
```

### Model implementing Entity
```dart
@freezed
sealed class MyModel with _$MyModel implements MyEntity {
  const factory MyModel({
    required String id,
    required String name,
  }) = _MyModel;

  const MyModel._(); // Required for methods/getters in freezed classes

  factory MyModel.fromJson(Map<String, dynamic> json) => _$MyModelFromJson(json);

  @override
  List<Object?> get props => [id, name];
}
```

### Repository Implementation
```dart
class MyRepositoryImpl implements IMyRepository {
  final IMyDataSource _dataSource;

  MyRepositoryImpl(this._dataSource);

  @override
  Future<Either<AppFailure, MyEntity>> getData({required String id}) async {
    final response = await _dataSource.getData(id: id);
    return response.fold(
      (error) => left(error.toFailure()),
      (model) => right(model), // Implicitly matched/upcast by compiler!
    );
  }
}
```
