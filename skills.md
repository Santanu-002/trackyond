# Luminous Curator - Workspace Skills

This document outlines the architectural standards and best practices for the Trackyond workspace.

## 1. Unified Button System (`AppButton`)
All buttons in the application should use the `AppButton` factory to ensure design consistency and flexible styling.

- **Filled**: `AppButton.filled(...)` - For primary actions (uses theme gradient).
- **Outlined**: `AppButton.outlined(...)` - For secondary actions.
- **Ghost**: `AppButton.ghost(...)` - For tertiary actions or text-only buttons.
- **Custom**: `AppButton.custom(...)` - For specialized layouts where only the container behavior is needed.

**Rule**: Avoid using standard `ElevatedButton`, `OutlinedButton`, or `TextButton` directly.

## 2. Externalized Strings (`AppStrings`)
All user-facing strings must be externalized to `lib/core/constants/app_strings.dart` using **getters**.

- **Pattern**: `String get login => 'Login';`
- **Reasoning**: Getters provide flexibility for localization or dynamic string generation in the future without breaking the API.

**Rule**: No hardcoded strings in UI widgets.

## 3. Context Extensions (Theme)
Use shorthand extensions on `BuildContext` (provided by GetX) to access theme tokens and colors.

- **Primary Color**: `context.theme.colorScheme.primary`
- **Surface**: `context.theme.colorScheme.surface`
- **Text Theme**: `context.textTheme`

**Rule**: Prefer `context.theme.colorScheme.primary` over `Theme.of(context).colorScheme.primary`.

## 4. Unified UI Constants (`AppUIConstants`)
Maintain visual consistency by using predefined constants for spacing, radius, and common layout widgets. All properties must use **getters**.

- **Pattern**: `double get radius$16 => 16.0;`
- **usage**: `AppUIConstants.spacing.space$16` or `AppUIConstants.widgets.verticalBox$24`.

**Rule**: No hardcoded double values for spacing, margins, or border radii.

## 5. Gap-Based Spacing
When uniform spacing is needed between children in a `Column` or `Row`, prefer using the `spacing` property instead of manual `SizedBox` widgets.

- **usage**:
  ```dart
  Column(
    spacing: AppUIConstants.spacing.space$16,
    children: [...],
  )
  ```

**Rule**: Use the `spacing` property for equal distribution of gaps between flex items.

## 6. Clean Architecture
Maintain a strict separation between layers to ensure the codebase remains testable and scalable.

- **Data**: Repositories, Data Sources, Models (DTOs).
- **Domain**: Entities, Use Cases, Repository Interfaces.
- **Presentation**: UI (Screens/Pages), Controllers (GetX), Bindings.

**Rule**: The Domain layer must be independent of all other layers. Presentation should only interact with Domain (via Use Cases).

## 7. SOLID Principles
Adhere to SOLID principles for all new code:
- **S**: Single Responsibility Principle.
- **O**: Open/Closed Principle.
- **L**: Liskov Substitution Principle.
- **I**: Interface Segregation Principle.
- **D**: Dependency Inversion Principle.

## 8. Logic-Free UI (UI as Slave)
The UI layer is purely responsible for rendering and must not contain any business logic, validation, or routing code.

- **Routing**: Navigation (e.g., `Get.toNamed`) must be triggered from the Controller.
- **GetView**: Use `GetView<T>` for screens to ensure a direct link to the controller without manual `find` calls.

**Rule**: UI is a "slave" to the controller; it only consumes data and delegates actions.

## 9. Unified API Response Casing (`camelCase`)
All API responses and request bodies must maintain consistent naming conventions.

- **Convention**: Use `camelCase` for all JSON keys.
- **Reasoning**: Ensures consistency for frontend consumption (Dart/Flutter) and avoids mixed casing within the same response.

**Rule**: All JSON keys in responses and request bodies must be `camelCase`. Avoid `snake_case`.

## 10. UTC Datetimes (ISO 8601)
All datetime fields returned in JSON responses must be UTC-formatted with the `Z` suffix (e.g., `2026-04-18T05:34:57Z`).

**Rules**:
- Use `to_utc_iso()` from `core.utils.datetime_utils` for all ISO string conversions.
- Always include the `Z` suffix (enforced by the helper).
- **Timezone-Aware Logic**: Prohibit the use of `datetime.utcnow()`. Always use `now_utc()` or `datetime.now(timezone.utc)` for internal logic and comparisons to avoid `TypeError`.

## 11. Functional Programming Return Types (`Unit`)
When using `fpdart` for functional error handling, use `Unit` instead of `void` to represent the absence of a value in `Either` returns.

- **Use Case**: `Either<AppFailure, Unit>` instead of `Either<AppFailure, void>`.
- **Return**: `Right(unit)` instead of `Right(null)`.

**Rule**: Never use `void` inside `Either` or `BaseUseCase` returns when functional equivalents (`Unit`) exist.

## 12. Unified Iconography (`AppIcons`)
All icons in the application should be centralized in `lib/core/constants/app_icons.dart` using standard Material or Cupertino icons. The `AppIcons` class should be organized into categories using private classes for better discoverability and organization.

- **Pattern**:
  ```dart
  class AppIcons {
    static const auth = _AuthIcons();
    ...
  }
  class _AuthIcons {
    const _AuthIcons();
    IconData get login => Icons.login_rounded;
  }
  ```
- **Usage**: `AppIcons.dashboard.home` or `AppIcons.auth.login`.

**Rule**: Avoid calling `Icons` or `CupertinoIcons` directly in UI widgets. Always use `AppIcons` constants.

---
*Maintained by Antigravity AI*
