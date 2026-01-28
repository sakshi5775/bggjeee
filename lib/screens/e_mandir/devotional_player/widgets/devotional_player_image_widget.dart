import 'package:flutter/material.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DevotionalPlayerImageWidget extends StatelessWidget {
  const DevotionalPlayerImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final imageUrl = AppConstant.eMandirGanesha;
    final isNetworkImage = imageUrl.startsWith('http://') || imageUrl.startsWith('https://');
    
    return Container(
      height: 480,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: isNetworkImage
            ? CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 480,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
              )
            : Image.asset(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 480,
              ),
      ),
    );
  }
}
