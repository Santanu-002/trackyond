import 'package:trackyond/core/services/sync/models/sync_result.dart';

abstract class SyncCommand {
  const SyncCommand();

  String get actionType;
  Map<String, dynamic> toJson();
  String? get requestId => null;
}

abstract class SyncCommandHandler<T extends SyncCommand> {
  const SyncCommandHandler();

  Future<SyncResult> handle(T command, int taskId);
}
