class Note {
  int? id;
  String? title;
  String? note;
  String? date;
  String tableName = "notes";

  Note({this.id, this.title, this.note, this.date});
  factory Note.fromMap(Map<dynamic, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      note: json['note'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'note': note,
      'date': date,
    };
  }
}
