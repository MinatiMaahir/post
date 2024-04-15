import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  void navigateToType(BuildContext context, String type) {
    Routemaster.of(context).push('/add-post/$type')
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double cardHightWidth = 120;
    double iconSize = 60;
    final currentTheme = ref.watch(themeNotifierProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      clildren: [
        GestureDetector(
          onTap: () => navigateToType(context, 'image'),
          child: SizedBox(
            height: cardHightWidth,
            width: cardHightWidth,
            Child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: currentTheme.backgroundColor,
              elevation: 16,
              child: Center(
                child: Icon(
                  Icon.image_outlined,
                  size:iconSize,
                ),
            ),
          )
          ),
        )
        GestureDetector(
          onTap: () => navigateToType(context, 'text'),
          child: SizedBox(
              height: cardHightWidth,
              width: cardHightWidth,
              Child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: currentTheme.backgroundColor,
                elevation: 16,
                child: Center(
                  child: Icon(
                    Icon.font_download_outlined,
                    size:iconSize,
                  ),
                ),
              )
          ),
        )
        GestureDetector(
          onTap: () => navigateToType(context, 'link'),
          child: SizedBox(
              height: cardHightWidth,
              width: cardHightWidth,
              Child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: currentTheme.backgroundColor,
                elevation: 16,
                child: Center(
                  child: Icon(
                    Icon.link_outlined,
                    size:iconSize,
                  ),
                ),
              )
          ),
        )
      ]
    );
  }
