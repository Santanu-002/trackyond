enum Gender {
  male('Male'),
  female('Female'),
  other('Other');

  final String value;

  const Gender(this.value);

  static Gender fromString(String value) {
    return Gender.values.firstWhere(
      (e) => e.value.toLowerCase() == value.toLowerCase(),
      orElse: () => Gender.other,
    );
  }
}
