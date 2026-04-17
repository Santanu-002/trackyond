import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackyond/core/common/entities/user/user.dart';
import 'package:trackyond/core/common/entities/user/user_role.dart';
import 'package:trackyond/features/auth/data/models/owner_profile_model.dart';
import 'package:trackyond/features/auth/data/models/user_model.dart';
import 'package:trackyond/features/auth/data/models/worker_profile_model.dart';

class UserService extends GetxService {
  final SharedPreferences _prefs;

  UserService(this._prefs);

  // ------------------ KEYS ------------------

  static final _keys = _UserKeys();

  // ------------------ STATE ------------------

  final Rxn<User> _user = Rxn<User>();
  final Rxn<OwnerProfileModel> _ownerProfile = Rxn<OwnerProfileModel>();
  final Rxn<WorkerProfileModel> _workerProfile = Rxn<WorkerProfileModel>();

  // ------------------ INIT / RESTORE ------------------

  Future<void> init() async {
    final userJson = _prefs.getString(_keys.user);

    if (userJson != null) {
      _user.value = UserModel.fromJson(jsonDecode(userJson)).toEntity();
    }

    final ownerJson = _prefs.getString(_keys.ownerProfile);
    if (ownerJson != null) {
      _ownerProfile.value = OwnerProfileModel.fromJson(jsonDecode(ownerJson));
    }

    final workerJson = _prefs.getString(_keys.workerProfile);
    if (workerJson != null) {
      _workerProfile.value = WorkerProfileModel.fromJson(
        jsonDecode(workerJson),
      );
    }
  }

  // ------------------ USER ------------------

  Future<void> setUser(UserModel user) async {
    _user.value = user.toEntity();

    await _prefs.setString(_keys.user, jsonEncode(user.toJson()));
  }

  User? getUser() => _user.value;

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

  // ------------------ OWNER PROFILE ------------------

  Future<void> setOwnerProfile(OwnerProfileModel profile) async {
    _ensureRole(UserRole.owner);

    _ownerProfile.value = profile;
    _workerProfile.value = null;

    await _prefs.setString(_keys.ownerProfile, jsonEncode(profile.toJson()));

    await _prefs.remove(_keys.workerProfile);
  }

  OwnerProfileModel? getOwnerProfile() {
    _ensureRole(UserRole.owner);
    return _ownerProfile.value;
  }

  // ------------------ WORKER PROFILE ------------------

  Future<void> setWorkerProfile(WorkerProfileModel profile) async {
    _ensureRole(UserRole.worker);

    _workerProfile.value = profile;
    _ownerProfile.value = null;

    await _prefs.setString(_keys.workerProfile, jsonEncode(profile.toJson()));

    await _prefs.remove(_keys.ownerProfile);
  }

  WorkerProfileModel? getWorkerProfile() {
    _ensureRole(UserRole.worker);
    return _workerProfile.value;
  }

  // ------------------ CLEAR ------------------

  Future<void> clear() async {
    _user.value = null;
    _ownerProfile.value = null;
    _workerProfile.value = null;

    await Future.wait([
      _prefs.remove(_keys.user),
      _prefs.remove(_keys.ownerProfile),
      _prefs.remove(_keys.workerProfile),
    ]);
  }

  // ------------------ GUARDS ------------------

  void _ensureUser() {
    if (_user.value == null) {
      throw Exception('User not set');
    }
  }

  void _ensureRole(UserRole role) {
    _ensureUser();

    assert(_user.value!.role == role, 'Invalid role access: expected $role');

    if (_user.value!.role != role) {
      throw Exception('Invalid role access: expected $role');
    }
  }
}

// ------------------ PRIVATE KEYS ------------------

class _UserKeys {
  final user = 'user_json';
  final role = 'user_role';
  final ownerProfile = 'owner_profile_json';
  final workerProfile = 'worker_profile_json';
}
