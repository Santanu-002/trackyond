import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:trackyond/core/common/entities/owner_profile/owner_profile.dart';
import 'package:trackyond/core/common/entities/user/user.dart';
import 'package:trackyond/core/common/entities/user/user_role.dart';
import 'package:trackyond/core/common/entities/worker_profile/worker_profile.dart';

class UserService extends GetxService {
  final SharedPreferences _prefs;

  UserService(this._prefs);

  // ------------------ KEYS ------------------

  static final _keys = _UserKeys();

  // ------------------ STATE ------------------

  final Rxn<User> _user = Rxn<User>();
  final Rxn<OwnerProfile> _ownerProfile = Rxn<OwnerProfile>();
  final Rxn<WorkerProfile> _workerProfile = Rxn<WorkerProfile>();

  // ------------------ INIT / RESTORE ------------------

  Future<void> init() async {
    final userJson = _prefs.getString(_keys.user);

    if (userJson != null) {
      _user.value = User.fromJson(jsonDecode(userJson));
    }

    final ownerJson = _prefs.getString(_keys.ownerProfile);
    if (ownerJson != null) {
      _ownerProfile.value =
          OwnerProfile.fromJson(jsonDecode(ownerJson));
    }

    final workerJson = _prefs.getString(_keys.workerProfile);
    if (workerJson != null) {
      _workerProfile.value =
          WorkerProfile.fromJson(jsonDecode(workerJson));
    }
  }

  // ------------------ USER ------------------

  Future<void> setUser(User user) async {
    _user.value = user;

    await _prefs.setString(
      _keys.user,
      jsonEncode(user.toJson()),
    );
  }

  User? getUser() => _user.value;

  UserRole? getUserRole() => _user.value?.role;

  bool get isLoggedIn => _user.value != null;

  // ------------------ OWNER PROFILE ------------------

  Future<void> setOwnerProfile(OwnerProfile profile) async {
    _ensureRole(UserRole.owner);

    _ownerProfile.value = profile;
    _workerProfile.value = null;

    await _prefs.setString(
      _keys.ownerProfile,
      jsonEncode(profile.toJson()),
    );

    await _prefs.remove(_keys.workerProfile);
  }

  OwnerProfile? getOwnerProfile() {
    _ensureRole(UserRole.owner);
    return _ownerProfile.value;
  }

  // ------------------ WORKER PROFILE ------------------

  Future<void> setWorkerProfile(WorkerProfile profile) async {
    _ensureRole(UserRole.worker);

    _workerProfile.value = profile;
    _ownerProfile.value = null;

    await _prefs.setString(
      _keys.workerProfile,
      jsonEncode(profile.toJson()),
    );

    await _prefs.remove(_keys.ownerProfile);
  }

  WorkerProfile? getWorkerProfile() {
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

    assert(_user.value!.role == role,
    'Invalid role access: expected $role');

    if (_user.value!.role != role) {
      throw Exception('Invalid role access: expected $role');
    }
  }
}

// ------------------ PRIVATE KEYS ------------------

class _UserKeys {
  final user = 'user_json';
  final ownerProfile = 'owner_profile_json';
  final workerProfile = 'worker_profile_json';
}