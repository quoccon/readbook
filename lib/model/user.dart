class Auth {
  Auth({
    required this.user,
  });

  final User? user;

  factory Auth.fromJson(Map<String, dynamic> json){
    return Auth(
      user: json["user"] == null ? null : User.fromJson(json["user"]),
    );
  }

}

class User {
  User({
    required this.username,
    required this.email,
    required this.password,
    required this.withlist,
    required this.id,
    required this.v,
  });

  final String? username;
  final String? email;
  final String? password;
  final List<dynamic> withlist;
  final String? id;
  final int? v;

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      username: json["username"],
      email: json["email"],
      password: json["password"],
      withlist: json["Withlist"] == null ? [] : List<dynamic>.from(json["Withlist"]!.map((x) => x)),
      id: json["_id"],
      v: json["__v"],
    );
  }

}
