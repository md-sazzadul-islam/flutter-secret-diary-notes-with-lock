class User {
  int? id;
  String? name;
  String tableName = "users";

  User({this.id, this.name});
  factory User.fromMap(Map<dynamic, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}
