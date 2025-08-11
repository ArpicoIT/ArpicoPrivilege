import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/constants/app_styles.dart';
import '../../../data/models/promotion.dart';
import '../app_text.dart';
import '../image_with_placeholder.dart';
import '../paints/border.dart';

class PromotionCard extends StatelessWidget {
  final Promotion data;
  final Function(Promotion promotion)? onTap;
  final bool enableSkeletonizer;
  final EdgeInsetsGeometry? margin;

  const PromotionCard(this.data, {super.key, this.onTap, this.enableSkeletonizer = false, this.margin});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    Color chipBackground;
    Color chipForeground;
    String chipText;
    bool enable;

    switch (data.proStatus) {
      case "ACT":
        chipBackground = Colors.orange;
        chipForeground = Colors.white;
        chipText = "More Details";
        enable = true;
        break;
      case "UPC":
        chipBackground = Colors.blue;
        chipForeground = Colors.white;
        chipText = "Upcoming";
        enable = true;
        break;
      case "EXP":
        chipBackground = Colors.grey;
        chipForeground = Colors.white;
        chipText = "Expired";
        enable = false;
        break;
      default:
        chipBackground = Colors.grey;
        chipForeground = Colors.white;
        chipText = "More Details";
        enable = false;
        break;
    }

    return Skeletonizer(
      enabled: enableSkeletonizer,
      child: Card(
        elevation: 1,
        margin: margin ?? EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: colorScheme.surface,
        // elevation: 0,
        // shadowColor: colorScheme.primaryContainer,
        // shape: RoundedRectangleBorder(
        //     borderRadius: AppRadius.m.all,
        //   side: BorderSide(color: Colors.grey.shade300)
        // ),
        child: InkWell(
          onTap: enable ? () => onTap?.call(data) : null,
          child: Column(
            children: [
              Skeleton.leaf(
                  enabled: enableSkeletonizer,
                  child: Card(
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    // shape: RoundedRectangleBorder(borderRadius: AppRadius.s.all),
                    child: AspectRatio(
                        aspectRatio: 2,
                        child: Builder(builder: (context) {
                          final Widget image = ImageWithPlaceholder(
                              data.imageUrl.isNotEmpty
                                  ? data.imageUrl.first
                                  : '');

                          if (enable) {
                            return image;
                          }

                          return ColorFiltered(
                            colorFilter: const ColorFilter.mode(
                                Colors.grey, BlendMode.saturation),
                            child: image,
                          );
                        })),
                  )),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(data.proDescri ?? "",
                        style: textTheme.bodyLarge
                            ?.copyWith(color: enable ? null : Colors.grey),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 24,
                      runSpacing: 16,
                      children: [
                        (data.proStartDate != null)
                            ? _labeledChip(context,
                            labelIcon: Icons.access_time,
                            labelText: DateFormat('MMMM dd, yyyy').format(
                                DateTime.parse(data.proStartDate!
                                    .toIso8601String())))
                            : const SizedBox.shrink(),
                        (data.proEndDate != null)
                            ? _labeledChip(context,
                            labelIcon: Icons.access_time_filled,
                            labelText: DateFormat('MMMM dd, yyyy').format(
                                DateTime.parse(data.proEndDate!
                                    .toIso8601String())))
                            : const SizedBox.shrink(),
                      ],
                    ),
                    Divider(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        data.proEndDate != null ? Flexible(
                            child: AppText.promotionExpiryText(
                                context, data.proEndDate!)) : const SizedBox.shrink(),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: () => onTap?.call(data),
                            style: TextButton.styleFrom(
                                backgroundColor: chipBackground,
                                foregroundColor: chipForeground,
                                padding: EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                minimumSize: Size.zero,
                                tapTargetSize:
                                MaterialTapTargetSize.shrinkWrap),
                            child: Text(chipText,
                                style: TextStyle(fontSize: 12)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _labeledChip(
      BuildContext context, {
        Function()? onTap,
        required IconData labelIcon,
        required String labelText,
        String? value,
      }) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        overlayColor: WidgetStateColor.transparent,
        child: Padding(
          padding: EdgeInsets.zero,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(labelIcon, size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              Text(labelText, style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}

class PromotionMasonryGridViewBuilder extends StatelessWidget {
  final int crossAxisCount;
  final List<Promotion> items;
  final Function(int index, Promotion data) onTapItem;
  final bool enableSkeletonizer;

  const PromotionMasonryGridViewBuilder(
      {super.key,
        this.crossAxisCount = 1,
        required this.items,
        required this.onTapItem,
        this.enableSkeletonizer = false});

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      itemCount: items.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        Promotion data = items[index];
        return PromotionCard(
          data,
          onTap: (v) => onTapItem(index, v),
          enableSkeletonizer: enableSkeletonizer,
        );
      },
    );
  }
}
