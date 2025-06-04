import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ProductImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;

  static final _cacheManager = DefaultCacheManager();

  const ProductImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FileInfo?>(
      future: _cacheManager.getFileFromCache(imageUrl).then((fileInfo) async {
        if (fileInfo == null) {
          return _cacheManager.downloadFile(
            imageUrl,
            key: imageUrl,
          );
        }
        return fileInfo;
      }),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey[100],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 40,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 8),
                Text(
                  'خطا در بارگذاری تصویر',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        }

        if (snapshot.hasData) {
          return Image.file(
            snapshot.data!.file,
            fit: fit,
            width: width,
            height: height,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: width,
                height: height,
                color: Colors.grey[100],
                child: Icon(
                  Icons.image_not_supported_outlined,
                  size: 40,
                  color: Colors.grey[300],
                ),
              );
            },
          );
        }

        return Container(
          width: width,
          height: height,
          color: Colors.grey[100],
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
} 