class MemberTable {
  const MemberTable._();

  static const String tableName = 'member_profiles';

  static const columnNames = _MemberTableColumns._();

  static String get tableCreate => '''
    CREATE TABLE $tableName (
      ${columnNames.uid} TEXT PRIMARY KEY,
      ${columnNames.userUid} TEXT NOT NULL,
      ${columnNames.name} TEXT NOT NULL,
      ${columnNames.phone} TEXT NOT NULL,
      ${columnNames.designation} TEXT NOT NULL,
      ${columnNames.gender} TEXT,
      ${columnNames.image} TEXT,
      ${columnNames.companyUid} TEXT,
      ${columnNames.createdBy} TEXT
    )
  ''';
}

class _MemberTableColumns {
  const _MemberTableColumns._();

  final String uid = 'uid';
  final String userUid = 'user_uid';
  final String name = 'name';
  final String phone = 'phone';
  final String designation = 'designation';
  final String gender = 'gender';
  final String image = 'image';
  final String companyUid = 'company_uid';
  final String createdBy = 'created_by';
}
