import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../data/models/eBill.dart';

class BillCard extends StatelessWidget {
  final EBill data;
  final Function(EBill ebill)? onTap;
  final bool enableSkeletonizer;
  final EdgeInsetsGeometry? margin;
  final String? currency;

  const BillCard(this.data,
      {super.key,
      this.onTap,
      this.currency = 'Rs',
      this.margin,
      this.enableSkeletonizer = false});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    List<Map<String, dynamic>> list = [
      if (data.datetime != null)
        {
          "key": "Billing Date",
          "value": DateFormat('MMM dd, yyyy').format(data.datetime!).toString(),
          "highlight": false,
        },
      {
        "key": "Bill Amount",
        "value": NumberFormat.currency(
          symbol: currency,
          decimalDigits: 2,
        ).format(data.total ?? 0.0).toString(),
        "highlight": false,
      },
      {
        "key": "Earn Points",
        "value": "${(data.loyalty?.billEarnPoints ?? 0)}",
        "highlight": true,
      },
    ];

    return Skeletonizer(
      enabled: enableSkeletonizer,
      child: Card(
        elevation: 1,
        // shadowColor: colorScheme.primaryContainer,
        margin: margin ?? EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: colorScheme.surface,
        // shape: Border(),
        child: InkWell(
          onTap: () => onTap?.call(data),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                (data.location != null)
                    ? Text(data.location!,
                        style: textTheme.titleSmall?.copyWith(
                            // color: colorScheme.surfaceTint,
                            fontWeight: FontWeight.w500))
                    : const SizedBox.shrink(),
                const SizedBox(height: 8),
                LayoutBuilder(builder: (context, constraints) {
                  double disWidth = constraints.maxWidth * 0.3;

                  return Row(
                    children: [
                      SizedBox(width: disWidth),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: list
                              .map(
                                (element) => Builder(builder: (context) {
                                  final bool isHighlight =
                                      element["highlight"] == true &&
                                          !enableSkeletonizer;

                                  final keyStyle =
                                      TextStyle(color: Colors.grey);
                                  final highlightedKeyStyle =
                                      TextStyle(color: Colors.white);
                                  final valueStyle = TextStyle();
                                  final highlightedValueStyle =
                                      TextStyle(color: Colors.white);

                                  return Container(
                                    decoration: BoxDecoration(
                                      color: isHighlight
                                          ? colorScheme.primary
                                          : null,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 8),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          element["key"],
                                          style: isHighlight
                                              ? highlightedKeyStyle
                                              : keyStyle,
                                        ),
                                        Text(element["value"],
                                            style: isHighlight
                                                ? highlightedValueStyle
                                                : valueStyle),
                                      ],
                                    ),
                                  );
                                }),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
