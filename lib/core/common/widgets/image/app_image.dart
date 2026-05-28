import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:image/image.dart' as img;
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

  static final Map<String, MemoryImage> _blurHashCache = {};

  static MemoryImage? getBlurHashProvider(String hash) {
    if (_blurHashCache.containsKey(hash)) {
      return _blurHashCache[hash];
    }
    try {
      final blurHashObj = BlurHash.decode(hash);
      final decodedImage = blurHashObj.toImage(32, 32);
      final pngBytes = Uint8List.fromList(img.encodePng(decodedImage));
      final memoryImage = MemoryImage(pngBytes);
      _blurHashCache[hash] = memoryImage;
      return memoryImage;
    } catch (e) {
      debugPrint('Error decoding blurhash: $e');
      return null;
    }
  }

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

    final MemoryImage? decodedHashProvider =
        (blurHash != null && blurHash!.isNotEmpty) ? getBlurHashProvider(blurHash!) : null;

    return OctoImage(
      image: CachedNetworkImageProvider(fullUrl),
      fit: fit,
      width: width,
      height: height,
      placeholderBuilder: placeholder != null
          ? (context) => placeholder!(context, fullUrl)
          : decodedHashProvider != null
              ? (context) => Stack(
                    fit: StackFit.expand,
                    children: [
                      Image(
                        image: decodedHashProvider,
                        fit: fit,
                      ),
                      const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    ],
                  )
              : OctoPlaceholder.circularProgressIndicator(),
      errorBuilder: errorWidget != null
          ? (context, error, stackTrace) => errorWidget!(context, fullUrl, error)
          : decodedHashProvider != null
              ? (context, error, stackTrace) => Stack(
                    fit: StackFit.expand,
                    children: [
                      Image(
                        image: decodedHashProvider,
                        fit: fit,
                      ),
                      const Center(
                        child: Icon(Icons.error_outline),
                      ),
                    ],
                  )
              : OctoError.icon(),
    );
  }
}
