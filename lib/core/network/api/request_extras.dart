/// Keys used in [Options.extra] to configure per-request behaviour
/// in the [AuthInterceptor] and other interceptors.
///
/// Usage:
/// ```dart
/// Options(extra: {
///   RequestExtras.isPublic: true,
///   RequestExtras.userRole: UserRole.owner,
/// })
/// ```
class RequestExtras {
  const RequestExtras._();

  /// Skip attaching the Authorization header for this request.
  static const String isPublic = 'isPublic';

  /// The role of the authenticated user making the request.
  /// Must be a [UserRole] value.
  static const String userRole = 'userRole';
}
