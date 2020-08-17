class Entities {
  Entities({this.view, this.limit, this.offset, this.sort});

  String view;
  int limit;
  int offset;
  String sort;

  Entities.fromMap(Map<String, dynamic> map) {
    view = map['view'];
    limit = map['limit'];
    offset = map['offset'];
    sort = map['sort'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = Map<String, dynamic>();
    if (view != null) {
      map['view'] = view;
    }
    if (limit != null) {
      map['limit'] = limit;
    }
    if (offset != null) {
      map['offset'] = offset;
    }
    if (sort != null) {
      map['sort'] = sort;
    }
    return map;
  }
}
