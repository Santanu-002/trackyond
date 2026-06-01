import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';

/// Holds the resolved icon and color for a given file type.
class FileTypeIconInfo {
  final dynamic icon; // FaIconData or IconData
  final Color color;

  const FileTypeIconInfo({required this.icon, required this.color});
}

/// Centralised resolver that maps a file extension to its icon and colour.
/// Use this in any widget that needs to display a document type icon so that
/// all icon/colour decisions live in one place.
class FileTypeIconResolver {
  const FileTypeIconResolver._();

  static FileTypeIconInfo resolve(String path, ColorScheme colorScheme) {
    final ext = path.split('.').last.toLowerCase();

    switch (ext) {
      // ── Spreadsheets ───────────────────────────────────────────────────────
      case 'xls':
      case 'xlsx':
      case 'csv':
        return FileTypeIconInfo(
          icon: FontAwesomeIcons.solidFileExcel,
          color: colorScheme.completed,
        );

      // ── Word documents ─────────────────────────────────────────────────────
      case 'doc':
      case 'docx':
        return FileTypeIconInfo(
          icon: FontAwesomeIcons.solidFileWord,
          color: colorScheme.attachmentDocs,
        );

      // ── Presentations ──────────────────────────────────────────────────────
      case 'ppt':
      case 'pptx':
        return FileTypeIconInfo(
          icon: FontAwesomeIcons.solidFilePowerpoint,
          color: colorScheme.pending,
        );

      // ── Videos ────────────────────────────────────────────────────────────
      case 'mp4':
      case 'mov':
      case 'avi':
      case 'mkv':
      case 'webm':
      case '3gp':
        return FileTypeIconInfo(
          icon: FontAwesomeIcons.solidFileVideo,
          color: colorScheme.attachmentVideo,
        );

      // ── Archives ──────────────────────────────────────────────────────────
      case 'zip':
      case 'rar':
      case '7z':
      case 'tar':
      case 'gz':
        return FileTypeIconInfo(
          icon: FontAwesomeIcons.solidFileZipper,
          color: colorScheme.inProgress,
        );

      // ── Web / Code ────────────────────────────────────────────────────────
      case 'html':
      case 'htm':
        return FileTypeIconInfo(
          icon: FontAwesomeIcons.solidFileCode,
          color: colorScheme.error,
        );

      // ── Images ────────────────────────────────────────────────────────────
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'webp':
      case 'bmp':
      case 'heic':
      case 'heif':
        return FileTypeIconInfo(
          icon: FontAwesomeIcons.solidFileImage,
          color: colorScheme.attachmentImage,
        );

      // ── Plain text ────────────────────────────────────────────────────────
      case 'txt':
        return FileTypeIconInfo(
          icon: CupertinoIcons.doc_text_fill,
          color: colorScheme.onSurfaceVariant,
        );

      // ── PDF ───────────────────────────────────────────────────────────────
      case 'pdf':
        return FileTypeIconInfo(
          icon: FontAwesomeIcons.solidFilePdf,
          color: colorScheme.attachmentPdf,
        );

      // ── Default ───────────────────────────────────────────────────────────
      default:
        return FileTypeIconInfo(
          icon: FontAwesomeIcons.solidFile,
          color: colorScheme.attachmentDocs,
        );
    }
  }
}
