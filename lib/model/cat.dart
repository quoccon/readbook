class Category {
  Category({
    required this.id,
    required this.nameCat,
    required this.v,
  });

  final String? id;
  final String? nameCat;
  final int? v;

  factory Category.fromJson(Map<String, dynamic> json){
    return Category(
      id: json["_id"],
      nameCat: json["nameCat"],
      v: json["__v"],
    );
  }

}
