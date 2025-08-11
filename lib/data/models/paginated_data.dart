class PaginatedData<T> {
  int limit;
  int offset;
  String sortType;
  String sortOrder;
  String searchKey;
  Map<String, dynamic> filters;
  List<T> data;

  PaginatedData({
    this.limit = 20,
    this.offset = 0,
    this.sortType = '',
    this.sortOrder = '',
    this.searchKey = '',
    this.filters = const {},
    required this.data,
  });

  PaginatedData<T> copyWith({
    int? limit,
    int? offset,
    String? sortType,
    String? sortOrder,
    String? searchKey,
    Map<String, dynamic>? filters,
    List<T>? data,
  }) {
    return PaginatedData<T>(
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
      sortType: sortType ?? this.sortType,
      sortOrder: sortOrder ?? this.sortOrder,
      searchKey: searchKey ?? this.searchKey,
      filters: filters ?? this.filters,
      data: data ?? this.data,
    );
  }


  PaginatedData<T> paginationList({
    required List<T> newData,
    required Function(T item, T element) whereFn,
    bool canDuplicates = false
  }){
    try {
      // remove duplicates
      if(!canDuplicates) {
        newData = newData.where((e) =>
        newData.indexWhere((i) => whereFn.call(i, e)) == newData.indexOf(e)
        ).toList();
      }

      final int sections = (newData.length / limit).floor();
      final int balance = newData.length % limit;

      // calculate last offset
      final newOffset = balance == 0 ? sections : sections + 1;

      return PaginatedData<T>(
        limit: limit,
        offset: newOffset,
        sortType: sortType,
        sortOrder: sortOrder,
        searchKey: searchKey,
        filters: filters,
        data: newData,
      );
    } catch (e) {
      return this;
    }
  }
}