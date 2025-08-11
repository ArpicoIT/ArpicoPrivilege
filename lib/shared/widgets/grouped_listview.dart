import 'package:flutter/material.dart';

class GroupedListView<T> extends StatelessWidget {
  // final TextStyle
  final List<MapEntry<String, List<T>>> groupedItems;
  final Widget Function(int, T) itemBuilder; // Function to build each item
  final Widget Function(int, String)? titleBuilder;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  const GroupedListView({super.key, required this.groupedItems, required this.itemBuilder, this.titleBuilder, this.physics, this.shrinkWrap = false});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: groupedItems.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        String groupName = groupedItems[index].key; // Get group name
        List<T> items = groupedItems[index].value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (titleBuilder != null) ? titleBuilder!.call(index, groupName) : Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: Text(
                groupName, // Show group name
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...items.asMap().entries.map((entry) => itemBuilder(entry.key, entry.value)),
          ],
        );
      },
    );
  }
}

class GroupedSliverListView<T> extends StatelessWidget {
  final List<MapEntry<String, List<T>>> groupedItems;
  final Widget Function(int, T) itemBuilder;
  final Widget Function(int, String)? titleBuilder;

  const GroupedSliverListView({
    super.key,
    required this.groupedItems,
    required this.itemBuilder,
    this.titleBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final slivers = <Widget>[];

    for (int groupIndex = 0; groupIndex < groupedItems.length; groupIndex++) {
      final group = groupedItems[groupIndex];
      final groupName = group.key;
      final items = group.value;

      // Title/Header as a Sliver
      slivers.add(
        SliverToBoxAdapter(
          child: (titleBuilder != null)
              ? titleBuilder!(groupIndex, groupName)
              : Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Text(
              groupName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );

      // Items in the group
      slivers.add(
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, itemIndex) => itemBuilder(itemIndex, items[itemIndex]),
            childCount: items.length,
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildListDelegate(
        slivers, // all header/item pairs flattened
      ),
    );
  }
}

