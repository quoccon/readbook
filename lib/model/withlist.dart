class WithList {
  WithList({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.content,
    required this.image,
    required this.genre,
    required this.isFavourite,
  });

  final String? id;
  final String? title;
  final String? author;
  final String? description;
  final String? content;
  final String? image;
  final String? genre;
  final bool? isFavourite;

  factory WithList.fromJson(Map<String, dynamic> json){
    return WithList(
      id: json["_id"],
      title: json["title"],
      author: json["author"],
      description: json["description"],
      content: json["content"],
      image: json["image"],
      genre: json["genre"],
      isFavourite: json["isFavourite"],
    );
  }

}
