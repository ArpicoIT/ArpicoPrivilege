class ListHelper {
  static Map<String, dynamic> paginationList<T>({
    required List<T> data,
    required Function(T item, T element) whereFn,
    required int limit,
    bool canDuplicates = false
  }){
    try {
      // remove duplicates
      if(!canDuplicates) {
        data = data.where((e) =>
        data.indexWhere((i) => whereFn.call(i, e)) == data.indexOf(e)
        ).toList();
      }

      final int sections = (data.length / limit).floor();
      final int balance = data.length % limit;

      // calculate last offset
      final offset = balance == 0 ? sections : sections + 1;

      return {
        "data": data,
        "limit": limit,
        "offset": offset,
      };
    } catch (e) {
      return {
        "data": [],
        "limit": limit,
        "offset": 0,
      };
    }
  }
}