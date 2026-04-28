import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackyond/core/common/enums/user_role.dart';
import 'package:trackyond/core/common/models/company/company_model.dart';
import 'package:trackyond/core/common/models/member/member_profile_model.dart';
import 'package:trackyond/features/auth/data/models/user/user_model.dart';

class UserService extends GetxService {
  final SharedPreferences _prefs;

  UserService(this._prefs);

  // ------------------ KEYS ------------------

  static final _keys = _UserKeys();

  // ------------------ STATE ------------------

  final Rxn<UserModel> _user = Rxn<UserModel>();
  final Rxn<MemberProfileModel> _profile = Rxn<MemberProfileModel>();
  final Rxn<CompanyModel> _company = Rxn<CompanyModel>();
  final Rx<bool> _hasCompletedAddTeamMember = false.obs;

  // ------------------ INIT / RESTORE ------------------

  Future<void> init() async {
    final userJson = _prefs.getString(_keys.user);
    if (userJson != null) {
      _user.value = UserModel.fromJson(jsonDecode(userJson));
    }

    final profileJson = _prefs.getString(_keys.profile);
    if (profileJson != null) {
      _profile.value = MemberProfileModel.fromJson(jsonDecode(profileJson));
    }

    final companyJson = _prefs.getString(_keys.company);
    if (companyJson != null) {
      _company.value = CompanyModel.fromJson(jsonDecode(companyJson));
    }

    _hasCompletedAddTeamMember.value =
        _prefs.getBool(_keys.hasCompletedAddTeamMember) ?? false;
  }

  // ------------------ USER ------------------
  
  Future<void> setUser(UserModel model) async {
    _user.value = model;
    await _prefs.setString(_keys.user, jsonEncode(model.toJson()));
  }

  UserModel? getUser() => _user.value;

  UserRole? getUserRole() => _user.value?.role;

  bool get isLoggedIn => _user.value != null;

  // ------------------ ROLE PERSISTENCE ------------------

  Future<void> saveUserRole(UserRole role) async {
    await _prefs.setString(_keys.role, role.value);
  }

  UserRole? getUserRoleSaved() {
    final roleStr = _prefs.getString(_keys.role);
    if (roleStr == null) return null;
    return UserRole.fromString(roleStr);
  }

  // ------------------ MEMBER PROFILE ------------------

  Future<void> setProfile(MemberProfileModel model) async {
    _ensureUser();
    _profile.value = model;
    await _prefs.setString(_keys.profile, jsonEncode(model.toJson()));
  }

  MemberProfileModel? getProfile() => _profile.value;

  String? getAccountUid() => _profile.value?.accountUid;

  // ------------------ COMPANY ------------------

  Future<void> setCompany(CompanyModel model) async {
    _ensureUser();
    _company.value = model;
    await _prefs.setString(_keys.company, jsonEncode(model.toJson()));
  }

  CompanyModel? getCompany() => _company.value;

  // ------------------ ONBOARDING FLAGS ------------------

  Future<void> setHasCompletedAddTeamMember(bool value) async {
    _hasCompletedAddTeamMember.value = value;
    await _prefs.setBool(_keys.hasCompletedAddTeamMember, value);
  }

  bool get hasCompletedAddTeamMember => _hasCompletedAddTeamMember.value;

  // ------------------ CLEAR ------------------

  Future<void> clear() async {
    _user.value = null;
    _profile.value = null;
    _company.value = null;
    _hasCompletedAddTeamMember.value = false;

    await Future.wait([
      _prefs.remove(_keys.user),
      _prefs.remove(_keys.profile),
      _prefs.remove(_keys.company),
      _prefs.remove(_keys.role),
      _prefs.remove(_keys.hasCompletedAddTeamMember),
    ]);
  }

  // ------------------ GUARDS ------------------

  void _ensureUser() {
    if (_user.value == null) {
      throw Exception('User not set');
    }
  }
}

// ------------------ PRIVATE KEYS ------------------

class _UserKeys {
  final user = 'user_json';
  final role = 'user_role';
  final profile = 'member_profile_json';
  final company = 'company_json';
  final hasCompletedAddTeamMember = 'has_completed_add_team_member';
}
