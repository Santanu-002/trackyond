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

  @override
  Widget build(BuildContext context) {
    final fullUrl = getFullUrl(imageUrl);
    if (fullUrl.isEmpty) {
      return errorWidget?.call(context, imageUrl, 'Empty URL') ??
          const Center(child: Icon(Icons.error_outline));
    }

    final hasBlurHash = blurHash != null && blurHash!.isNotEmpty;

    return CachedNetworkImage(
      imageUrl: fullUrl,
      fit: fit,
      width: width,
      height: height,
      placeholder: placeholder != null
          ? (context, url) => placeholder!(context, url)
          : hasBlurHash
              ? (context, url) => Stack(
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
                  )
              : (context, url) => const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
      errorWidget: errorWidget != null
          ? (context, url, error) => errorWidget!(context, url, error)
          : hasBlurHash
              ? (context, url, error) => Stack(
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
                  )
              : (context, url, error) => const Center(
                    child: Icon(Icons.error_outline),
                  ),
    );
  }
}
