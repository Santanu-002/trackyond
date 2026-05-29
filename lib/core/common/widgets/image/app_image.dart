import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:octo_image/octo_image.dart';
import 'package:trackyond/core/network/api/api_endpoints.dart';

class AppImage extends StatelessWidget {
  final String imageUrl;
  final String? blurHash;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget Function(BuildContext, String)? placeholder;
  final Widget Function(BuildContext, String, dynamic)? errorWidget;

  const AppImage({
    super.key,
    required this.imageUrl,
    this.blurHash,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
  });

  static String getFullUrl(String? pathOrUrl) {
    if (pathOrUrl == null || pathOrUrl.isEmpty) return '';
    if (pathOrUrl.startsWith('http://') || pathOrUrl.startsWith('https://')) {
      return pathOrUrl;
    }
    if (pathOrUrl.startsWith('/')) {
      return '${ApiEndpoints.baseUrl}$pathOrUrl';
    }
    return '${ApiEndpoints.baseUrl}${ApiEndpoints.common.download(pathOrUrl)}';
  }

  static Widget buildPlaceholder({
    required BuildContext context,
    required String? blurHash,
    BoxFit fit = BoxFit.cover,
    Widget? child,
  }) {
    if (blurHash != null && blurHash.isNotEmpty) {
      return Stack(
        fit: StackFit.expand,
        children: [
          BlurHash(
            hash: blurHash,
            imageFit: fit,
          ),
          if (child != null) Center(child: child),
        ],
      );
    }
    return child != null ? Center(child: child) : const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return errorWidget?.call(context, imageUrl, 'Empty URL') ??
          const Center(child: Icon(Icons.error_outline));
    }

    final ImageProvider imageProvider;
    if (imageUrl.startsWith('assets/')) {
      imageProvider = AssetImage(imageUrl);
    } else {
      final localFile = File(imageUrl);
      if (localFile.existsSync()) {
        imageProvider = FileImage(localFile);
      } else {
        final fullUrl = getFullUrl(imageUrl);
        if (fullUrl.isEmpty) {
          return errorWidget?.call(context, imageUrl, 'Empty URL') ??
              const Center(child: Icon(Icons.error_outline));
        }
        imageProvider = CachedNetworkImageProvider(fullUrl);
      }
    }

    return OctoImage(
      image: imageProvider,
      fit: fit,
      width: width,
      height: height,
      placeholderBuilder: placeholder != null
          ? (context) => placeholder!(context, imageUrl)
          : (blurHash != null && blurHash!.isNotEmpty)
              ? (context) => buildPlaceholder(
                    context: context,
                    blurHash: blurHash,
                    fit: fit,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
              : (context) => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
      errorBuilder: errorWidget != null
          ? (context, error, stackTrace) => errorWidget!(context, imageUrl, error)
          : (blurHash != null && blurHash!.isNotEmpty)
              ? (context, error, stackTrace) => buildPlaceholder(
                    context: context,
                    blurHash: blurHash,
                    fit: fit,
                    child: const Icon(Icons.error_outline),
                  )
              : OctoError.icon(icon: Icons.error_outline),
    );
  }
}
