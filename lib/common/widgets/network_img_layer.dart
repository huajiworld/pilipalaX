import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:PiliPalaX/utils/extension.dart';
import '../../utils/storage.dart';
import '../constants.dart';

Box<dynamic> setting = GStrorage.setting;

class NetworkImgLayer extends StatelessWidget {
  const NetworkImgLayer({
    super.key,
    this.src,
    required this.width,
    required this.height,
    this.type,
    this.fadeOutDuration,
    this.fadeInDuration,
    // 图片质量 默认1%
    this.quality,
    this.origAspectRatio,
  });

  final String? src;
  final double width;
  final double height;
  final String? type;
  final Duration? fadeOutDuration;
  final Duration? fadeInDuration;
  final int? quality;
  final double? origAspectRatio;

  @override
  Widget build(BuildContext context) {
    final String imageUrl =
        '${src!.startsWith('//') ? 'https:${src!}' : src!}@${quality ?? 100}q.webp';
    int? memCacheWidth, memCacheHeight;

    if (width > height || (origAspectRatio != null && origAspectRatio! > 1)) {
      memCacheWidth = width.cacheSize(context);
    } else if (width < height ||
        (origAspectRatio != null && origAspectRatio! < 1)) {
      memCacheHeight = height.cacheSize(context);
    } else {
      // 不能同时设置，否则会导致图片变形
      memCacheWidth = width.cacheSize(context);
      // memCacheHeight = height.cacheSize(context);
    }

    return src != '' && src != null
        ? ClipRRect(
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(
              type == 'avatar'
                  ? 50
                  : type == 'emote'
                      ? 0
                      : StyleString.imgRadius.x,
            ),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: width,
              height: height,
              memCacheWidth: memCacheWidth,
              memCacheHeight: memCacheHeight,
              fit: BoxFit.cover,
              fadeOutDuration:
                  fadeOutDuration ?? const Duration(milliseconds: 120),
              fadeInDuration:
                  fadeInDuration ?? const Duration(milliseconds: 120),
              filterQuality: FilterQuality.high,
              errorWidget: (BuildContext context, String url, Object error) =>
                  placeholder(context),
              placeholder: (BuildContext context, String url) =>
                  placeholder(context),
            ),
          )
        : placeholder(context);
  }

  Widget placeholder(BuildContext context) {
    return Container(
      width: width,
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onInverseSurface.withOpacity(0.4),
        borderRadius: BorderRadius.circular(type == 'avatar'
            ? 50
            : type == 'emote'
                ? 0
                : StyleString.imgRadius.x),
      ),
      child: Center(
        child: Image.asset(
          type == 'avatar'
              ? 'assets/images/noface.jpeg'
              : 'assets/images/loading.png',
          width: width,
          height: height,
          cacheWidth: width.cacheSize(context),
          cacheHeight: height.cacheSize(context),
        ),
      ),
    );
  }
}
