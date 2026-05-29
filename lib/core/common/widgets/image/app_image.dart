import 'package:extended_image/extended_image.dart';
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

  @override
  Widget build(BuildContext context) {
    final fullUrl = getFullUrl(imageUrl);
    if (fullUrl.isEmpty) {
      return errorWidget?.call(context, imageUrl, 'Empty URL') ??
          const Center(child: Icon(Icons.error_outline));
    }

    return ExtendedImage.network(
      fullUrl,
      fit: fit,
      width: width,
      height: height,
      cache: true,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            if (placeholder != null) {
              return placeholder!(context, fullUrl);
            }
            if (blurHash != null && blurHash!.isNotEmpty) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  BlurHash(
                    hash: blurHash!,
                    imageFit: fit,
                  ),
                  const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );

          case LoadState.completed:
            return null;

          case LoadState.failed:
            if (errorWidget != null) {
              return errorWidget!(context, fullUrl, state.lastException);
            }
            if (blurHash != null && blurHash!.isNotEmpty) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  BlurHash(
                    hash: blurHash!,
                    imageFit: fit,
                  ),
                  const Center(
                    child: Icon(Icons.error_outline),
                  ),
                ],
              );
            }
            return const Center(child: Icon(Icons.error_outline));
        }
      },
    );
  }
}
