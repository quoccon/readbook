class Book {
  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.content,
    required this.description,
    required this.image,
    required this.genre,
    required this.createdAt,
  });

  final String? id;
  final String? title;
  final String? author;
  final String? content;
  final String? description;
  final String? image;
  final String? genre;
  final DateTime? createdAt;

  factory Book.fromJson(Map<String, dynamic> json){
    return Book(
      id: json["id"],
      title: json["title"],
      author: json["author"],
      content: json["content"],
      description: json["description"],
      image: json["image"],
      genre: json["genre"],
      createdAt: json["createdAt"],
    );
  }

}
