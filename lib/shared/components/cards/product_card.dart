import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../image_with_placeholder.dart';
import '../../../core/constants/app_styles.dart';
import '../../../data/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product data;
  final Function(Product product)? onTap;
  final bool enableSkeletonizer;
  final EdgeInsetsGeometry? margin;

  const ProductCard(this.data,
      {super.key, this.onTap, this.enableSkeletonizer = false, this.margin});

  Widget _discountPercentageChip(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final bgColor = (data.discountPct > 0
        ? colorScheme.secondary.withAlpha(50)
        : Colors.redAccent.withAlpha(50));

    final fgColor =
        (data.discountPct > 0 ? colorScheme.secondary : Colors.redAccent);

    return Material(
      type: MaterialType.canvas,
      color: enableSkeletonizer ? Colors.transparent : bgColor,
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.circular(4.0),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(
          "-${data.discountPct}%",
          style: textTheme.bodySmall?.copyWith(color: fgColor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Skeletonizer(
      enabled: enableSkeletonizer,
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: colorScheme.surface,
        child: InkWell(
          onTap: () => onTap?.call(data),
          child: Container(
            constraints: BoxConstraints(minHeight: 120.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Skeleton.leaf(
                    enabled: enableSkeletonizer,
                    child: Card(
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      shape:
                          RoundedRectangleBorder(borderRadius: AppRadius.m.all),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: ImageWithPlaceholder(
                          data.imageUrl.isNotEmpty ? data.imageUrl.first : null,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        data.itemDesc ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: [
                          Text(
                            data.highlightedPriceStr,
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.secondary,
                            ),
                          ),
                          (data.discountPct > 0 && data.discountPct < 100)
                              ? _discountPercentageChip(context)
                              : const SizedBox.shrink()
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      if (data.averageRating > 0)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.star,
                                color: Colors.orange.withAlpha(400),
                                size: 20.0),
                            const SizedBox(width: 2.0),
                            Text(
                                "${data.averageRating.toStringAsFixed(1)} (${data.totalReviews})",
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: colorScheme.onSurfaceVariant)),
                          ],
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProductMasonryGridViewBuilder extends StatelessWidget {
  final int crossAxisCount;
  final List<Product> items;
  final Function(int index, Product data) onTapItem;
  final bool enableSkeletonizer;

  const ProductMasonryGridViewBuilder(
      {super.key,
      this.crossAxisCount = 2,
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
        Product data = items[index];
        return ProductCard(
          data,
          onTap: (v) => onTapItem(index, v),
          enableSkeletonizer: enableSkeletonizer,
        );
      },
    );
  }
}

/*class ProductItemsBuilder extends StatelessWidget {
  final int crossAxisCount;
  final List<Product> items;
  final Function(int index, Product data) onTapItem;
  final Function()? onViewMore;
  final int maxVisibleItems;
  final bool enableSkeletonizer;

  const ProductItemsBuilder(
      {super.key,
      this.crossAxisCount = 2,
      required this.items,
      required this.onTapItem,
      this.onViewMore,
      int? maxVisibleItems,
      this.enableSkeletonizer = false})
      : maxVisibleItems = maxVisibleItems == null
            ? items.length
            : maxVisibleItems > items.length
                ? items.length
                : maxVisibleItems;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final double boxWidth = (constraints.maxWidth - (12.0 * crossAxisCount)) / crossAxisCount;
      return Column(
        children: [
          MasonryGridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12.0,
            crossAxisSpacing: 12.0,
            itemCount: maxVisibleItems,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              Product data = items[index];
              return ProductCard(
                data,
                width: boxWidth,
                onTap: () => onTapItem(index, data),
                enableSkeletonizer: enableSkeletonizer,
              );
            },
          ),
          if (onViewMore != null)
            Container(
              margin: const EdgeInsets.all(12.0),
              child: TextButton(
                onPressed: onViewMore,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("View More"),
                    Icon(Icons.navigate_next),
                  ],
                ),
              ),
            ),
        ],
      );
    });
  }
}*/

/*class SliverProductItemsBuilder extends StatelessWidget {
  final int crossAxisCount;
  final List<Product> items;
  final Function(int index, Product data) onTapItem;

  const SliverProductItemsBuilder({
    super.key,
    this.crossAxisCount = 2,
    required this.items,
    required this.onTapItem,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 12.0,
        crossAxisSpacing: 12.0,
        childCount: items.length,
        itemBuilder: (context, index) {
          final product = items[index];
          return ProductCard(
            product,
            onTap: (v) => onTapItem(index, v),
          );
        },
      ),
    );
  }
}*/
