import 'dart:convert';

import 'package:arpicoprivilege/app/app_routes.dart';
import 'package:arpicoprivilege/core/services/storage_service.dart';
import 'package:arpicoprivilege/data/repositories/app_cache_repository.dart';
import 'package:arpicoprivilege/shared/customize/custom_toast.dart';
import 'package:flutter/material.dart';


class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final Function(String value) onSearch;
  final Function(String value)? onClear;
  final Function()? onTap;
  final bool hasSearchButton;
  final bool hasClearButton;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final String? hintText;
  final String? initialValue;
  SearchField({super.key,
    TextEditingController? controller,
    this.focusNode,
    required this.onSearch,
    this.onClear,
    this.onTap,
    this.hasSearchButton = false,
    this.hasClearButton = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.hintText,
    this.initialValue,
  }) : controller = controller  ?? TextEditingController() {
    if (initialValue != null) {
      this.controller.text = initialValue!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      autofocus: autofocus,
      textInputAction: TextInputAction.search,
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      readOnly: readOnly,
      onSubmitted: onSearch,
      onTap: onTap,
      decoration: InputDecoration(
          hintText: hintText ?? "Search",
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 12),
          suffixIcon: Padding(
            padding: const EdgeInsets.all(2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ValueListenableBuilder(
                  valueListenable: controller,
                  builder: (context, value, child) {
                    if(value.text.isEmpty){
                      return const SizedBox.square(dimension: 40);
                    }

                    return IconButton(
                      onPressed: (){
                        if(onClear != null){
                          onClear!.call(controller.text);
                        } else {
                          controller.clear();
                        }
                      },
                      icon: Icon(Icons.clear),
                      padding: EdgeInsets.zero,
                      style: IconButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    );
                  }
                ),
                hasSearchButton ? IconButton.filled(
                  onPressed: ()=> onSearch(controller.text),
                  icon: Icon(Icons.search),
                  iconSize: 24,
                  padding: EdgeInsets.zero,
                  color: Colors.white,
                  style: IconButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ) : SizedBox.square(
                    dimension: 40,
                    child: Icon(Icons.search, size: 24, color: colorScheme.primary)),
              ],
            ),
          ),
          suffixIconConstraints: BoxConstraints(),
          enabledBorder: Theme.of(context).inputDecorationTheme.focusedBorder
      ),
    );
  }
}


class SearchView extends StatelessWidget {
  SearchView({super.key});

  final searchCtrl = TextEditingController();
  final searchFocus = FocusNode();
  final recentlySearchedKey = GlobalKey<RecentlySearchedState>();

  
  void onSearch(BuildContext context, [String? value]) async {
    final toast = CustomToast.of(context);

    final newValue = value ?? searchCtrl.text;

    if(newValue.isEmpty){
      toast.showPrimary("Please enter any search word");
      return;
    }

    unFocusBackground(context);

    await recentlySearchedKey.currentState?.saveHistory(newValue);

    if(context.mounted) {
      await Navigator.of(context).pushNamed(AppRoutes.productCenter, arguments: newValue);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(searchCtrl.text.isNotEmpty) {
        searchCtrl.selection =
            TextSelection(baseOffset: 0, extentOffset: searchCtrl.text.length);
      }
      searchFocus.requestFocus();
    });
  }

  void unFocusBackground(BuildContext context) {
    searchFocus.unfocus();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topPadding = MediaQuery.of(context).viewPadding.top;

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.red,
        title: SearchField(
          controller: searchCtrl,
          focusNode: searchFocus,
          hasSearchButton: true,
          onSearch: (value) => onSearch(context),
        ),
      ),
      body: GestureDetector(
        onTap: ()=> unFocusBackground(context),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: size.height - topPadding - kToolbarHeight,
          ),
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24).copyWith(bottom: 0),
          child: RecentlySearched(
            key: recentlySearchedKey,
            onPressSearchKey: (searchKey){
              searchCtrl.text = searchKey;
              onSearch(context);
            },
          ),
        ),
      ),
    );
  }

}


class RecentlySearched extends StatefulWidget {
  final Function(String key) onPressSearchKey;
  const RecentlySearched({super.key, required this.onPressSearchKey});

  @override
  State<RecentlySearched> createState() => RecentlySearchedState();
}

class RecentlySearchedState extends State<RecentlySearched> {
  final String cacheKey = 'recent_searches';

  List<String> history = [];

  List<String> tempHistory = [
    "accessories",
    "saloon",
    "tools",
    "electronics",
    "groceries",
    "furniture",
    "clothing",
    "footwear",
    "beauty products",
    "toys",
    "books",
    "kitchenware",
    "sports equipment",
    "watches",
    "jewelry",
    "automobiles",
    "gardening",
    "home decor",
    "pet supplies",
    "health care",
    "accessories",
    "saloon",
    "tools",
    "electronics",
    "groceries",
    "furniture",
    "clothing",
    "footwear",
    "beauty products",
    "toys",
    "books",
    "kitchenware",
    "sports equipment",
    "watches",
    "jewelry",
    "automobiles",
    "gardening",
    "home decor",
    "pet supplies",
    "health care",
    "accessories",
    "saloon",
    "tools",
    "electronics",
    "groceries",
    "furniture",
    "clothing",
    "footwear",
    "beauty products",
    "toys",
    "books",
    "kitchenware",
    "sports equipment",
    "watches",
    "jewelry",
    "automobiles",
    "gardening",
    "home decor",
    "pet supplies",
    "health care",
    "tools",
    "electronics",
    "groceries",
    "furniture",
    "clothing",
    "footwear",
    // "beauty products",
    // "toys",
    // "books",
    // "kitchenware",
    // "sports equipment",
    // "watches",
    // "jewelry",
    // "automobiles",
    // "gardening",
    // "home decor",
    // "pet supplies",
    // "health care"
  ];

  bool isDeleteMode = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      history = AppCacheRepository.loadSearchedHistoryCache();

      if(history.isNotEmpty && context.mounted){
        setState(() {});
      }
    });

    super.initState();
  }

  void enableDeleteMode() {
    setState(() {
      isDeleteMode = !isDeleteMode;
    });
  }

  void deleteItem(String item) async {
    try {
      history.remove(item);
      AppCacheRepository.saveSearchedHistoryCache(history);
      if (history.isEmpty) isDeleteMode = false;
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void clearAll() async {
    try {
      await AppCacheRepository.deleteSearchedHistoryCache();
      history.clear();
      isDeleteMode = false;
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void done() {
    setState(() {
      isDeleteMode = false;
    });
  }

  Future<void> saveHistory(String value) async {
    try {
      history.add(value.toLowerCase());
      history = history.where((e) => e.isNotEmpty && e.length > 2).toSet().toList();
      await AppCacheRepository.saveSearchedHistoryCache(history);
      return;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Widget chip(BuildContext context, {
    required String title,
    bool hasDelete = false,
    Function(String value)? onPressed,
    Function()? onLongPress,
    Function(String value)? onDelete,
  }){
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
        onTap: ()=> !hasDelete ? onPressed?.call(title) : onDelete?.call(title),
        onLongPress: onLongPress,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: colorScheme.surfaceContainerLow,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title),
              if(hasDelete) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: ()=> onDelete?.call(title),
                  child: Icon(Icons.clear, size: 20),
                )
              ]

            ],
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if(history.isEmpty){
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Recently searched", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            if(isDeleteMode)
              GestureDetector(
                onTap: done,
                child: Text("Done", style: TextStyle(color: colorScheme.onPrimaryFixedVariant)),
              )
            else if (history.isNotEmpty)
              GestureDetector(
                onTap: clearAll,
                child: Text("Clear All", style: TextStyle(color: colorScheme.onPrimaryFixedVariant)),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.start,
              children: history.map((item) {
                return chip(
                  context,
                  title: item,
                  hasDelete: isDeleteMode,
                  onLongPress: enableDeleteMode,
                  onDelete: deleteItem,
                  onPressed: widget.onPressSearchKey
                );
              }).toList(),
            ),
          ),
        )
      ],
    );
  }
}

