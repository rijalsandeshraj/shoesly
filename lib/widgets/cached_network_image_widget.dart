import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CachedNetworkImageWidget extends StatelessWidget {
  const CachedNetworkImageWidget({
    super.key,
    required this.imageUrl,
    required this.placeholderSize,
    required this.errorImagePath,
  });

  final String imageUrl;
  final double placeholderSize;
  final String errorImagePath;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.contain,
      placeholder: (context, url) => SizedBox(
        height: placeholderSize,
        width: placeholderSize,
        child: FittedBox(
          child:
              Lottie.asset(height: 30, 'assets/animations/image_loading.json'),
        ),
      ),
      errorWidget: (context, url, error) => Image.asset(errorImagePath),
    );
  }
}
