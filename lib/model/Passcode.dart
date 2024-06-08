class Passcode {
  int? id;
  String? code;
  String? email;
  String tableName = "passcode";

  Passcode({this.id, this.code, this.email});
  factory Passcode.fromMap(Map<dynamic, dynamic> json) {
    return Passcode(
      id: json['id'],
      code: json['code'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'email': email,
    };
  }
}
