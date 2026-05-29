import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
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

    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: errorWidget != null
            ? (context, error, stackTrace) => errorWidget!(context, imageUrl, error)
            : (context, error, stackTrace) => const Center(child: Icon(Icons.error_outline)),
      );
    }

    final localFile = File(imageUrl);
    if (localFile.existsSync()) {
      return Image.file(
        localFile,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: errorWidget != null
            ? (context, error, stackTrace) => errorWidget!(context, imageUrl, error)
            : (context, error, stackTrace) => const Center(child: Icon(Icons.error_outline)),
      );
    }

    final fullUrl = getFullUrl(imageUrl);
    if (fullUrl.isEmpty) {
      return errorWidget?.call(context, imageUrl, 'Empty URL') ??
          const Center(child: Icon(Icons.error_outline));
    }

    return CachedNetworkImage(
      imageUrl: fullUrl,
      fit: fit,
      width: width,
      height: height,
      placeholder: placeholder != null
          ? (context, url) => placeholder!(context, url)
          : (context, url) => buildPlaceholder(
                blurHash: blurHash,
                fit: fit,
                child: const CircularProgressIndicator(strokeWidth: 2),
              ),
      errorWidget: errorWidget != null
          ? (context, url, error) => errorWidget!(context, url, error)
          : (context, url, error) => buildPlaceholder(
                blurHash: blurHash,
                fit: fit,
                child: const Icon(Icons.error_outline),
              ),
    );
  }
}
