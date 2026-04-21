enum UserRole {
  owner('owner'),
  worker('worker');

  final String value;

  const UserRole(this.value);

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere((e) => e.value == value);
  }
}
