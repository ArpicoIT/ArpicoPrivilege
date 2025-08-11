import 'package:flutter/material.dart';

// class CustomError extends StatelessWidget {
//   final String? title;
//   final String? message;
//   final String footer;
//   final VoidCallback onRefresh;
//   final String? imageAsset;
//   final double aspectRatio;
//
//   const CustomError(
//       {super.key,
//       this.title,
//       this.message,
//       required this.onRefresh,
//       this.footer = '',
//       this.imageAsset = 'assets/errors/failed.png',
//       this.aspectRatio = 1});
//
//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: aspectRatio,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // if (imageAsset != null)
//             //   Image.asset(
//             //     imageAsset!,
//             //     height: 100,
//             //     fit: BoxFit.fill,
//             //   ),
//             // const SizedBox(height: 16),
//             Text(
//               title ?? 'Failed to load',
//               textAlign: TextAlign.center,
//               style: Theme.of(context).textTheme.bodyLarge,
//             ),
//             const SizedBox(height: 16),
//             TextButton.icon(
//               onPressed: onRefresh,
//               label: Text('Refresh'),
//               icon: Icon(Icons.refresh),
//               style: TextButton.styleFrom(
//                   tapTargetSize: MaterialTapTargetSize.shrinkWrap),
//             ),
//             if(message != null)
//               ...[
//                 const SizedBox(height: 16),
//                 Text(
//                   message!,
//                   textAlign: TextAlign.center,
//                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
//                 ),
//               ],
//             if (footer.isNotEmpty) ...[
//               const SizedBox(height: 12),
//               Text(
//                 footer,
//                 style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                       color: Colors.grey,
//                     ),
//               ),
//             ]
//           ],
//         ),
//       ),
//     );
//   }
// }


