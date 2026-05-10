enum UserRole {
  owner('owner'),
  worker('worker');

  final String value;

  const UserRole(this.value);

  static UserRole fromString(dynamic value) {
    final strValue = value?.toString().toLowerCase() ?? '';
    if (strValue == 'admin' || strValue == 'owner') return UserRole.owner;
    return UserRole.worker;
  }
}
