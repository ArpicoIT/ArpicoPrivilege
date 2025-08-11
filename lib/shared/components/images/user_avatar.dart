import 'package:flutter/material.dart';

/*class AppNetworkImage extends StatelessWidget {
  final String? url;
  final String? text;
  final BoxFit fit;
  final double radius;

  const AppNetworkImage({super.key, this.fit = BoxFit.cover})
      : url = null,
        text = null,
        radius = 24.0;

  const AppNetworkImage.user(
      {super.key,
      required this.url,
      this.text,
      this.fit = BoxFit.cover,
      this.radius = 24.0});

  @override
  Widget build(BuildContext context) {
    return userImage(context);
  }

  Widget userImage(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox.square(
      dimension: radius*2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
        ),
        alignment: Alignment.center,
        clipBehavior: Clip.hardEdge,
        child: Image.network(
          url ?? '',
          fit: fit,
          // Placeholder for error
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: colorScheme.surfaceContainerLow,
              alignment: Alignment.center,
              child: Text(text?[0]??'', style: TextStyle(fontSize: radius)),
            );
          },
          // Placeholder while loading
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }

            return const SizedBox.shrink();
            // else {
            //   return placeholder ?? _placeholder(context);
            // }
          },
          // Fade-in effect when the image is loaded
          // frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          //   if (wasSynchronouslyLoaded) {
          //     return child; // Show immediately if already loaded
          //   }
          //   return AnimatedOpacity(
          //     opacity: frame == null
          //         ? 0
          //         : 1, // Fade-in once the first frame is available
          //     duration: const Duration(milliseconds: 500),
          //     curve: Curves.easeIn,
          //     child: child,
          //   );
          // },
        ),
      ),
    );
  }
}*/

class UserAvatar extends StatelessWidget {
  final String? avatar;
  final String? userName;
  final VoidCallback? onTap;
  final BoxFit fit;
  final double radius;

  const UserAvatar(
      {super.key,
      required this.avatar,
      this.userName,
      this.onTap,
      this.fit = BoxFit.cover,
      this.radius = 24.0})
      : _userName = userName ?? '';

  final String _userName;

  /// Generates a consistent color for a given username
  Color? _generateColor(String name) {
    if (name.isEmpty) return null;
    final int hash = name.codeUnits.fold(0, (sum, char) => sum + char);
    return Colors.primaries[hash % Colors.primaries.length];
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _generateColor(_userName);

    return CircleAvatar(
      backgroundColor:
          backgroundColor ?? Theme.of(context).colorScheme.surfaceContainerLow,
      radius: radius,
      child: InkWell(
        onTap: onTap,
        child: ClipOval(
          child: (avatar ?? '').trim().isNotEmpty
              ? Image.network(
                  avatar!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback to showing the first letter of the username
                    return Center(
                      child: Text(
                        _userName.isNotEmpty ? _userName[0].toUpperCase() : '?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: radius,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    _userName.isNotEmpty ? _userName[0].toUpperCase() : '?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: radius,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
