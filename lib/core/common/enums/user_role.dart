enum UserRole {
  owner('owner'),
  worker('worker');

  final String value;

  const UserRole(this.value);

  static UserRole fromString(dynamic value) {
    final strValue = value?.toString() ?? '';
    final lowerValue = strValue.toLowerCase();
    if (lowerValue == 'admin' || lowerValue == 'owner') return UserRole.owner;
    return UserRole.worker;
  }
}
