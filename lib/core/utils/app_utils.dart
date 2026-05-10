import 'package:flutter/services.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/core/constants/app_strings.dart';

/// Copies the given [text] to the clipboard and shows a success snackbar.
/// Defaults to "Copied!" if no [message] is provided.
void copyToClipboard(String text, {String? message}) {
  Clipboard.setData(ClipboardData(text: text));
  AppSnackbar.info(message ?? AppStrings.common.copied);
}
