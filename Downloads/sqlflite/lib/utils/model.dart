// Note App
class Note {
  final String content;
  final String category;
  final DateTime date;
  final int? id;

  Note({
    required this.content,
    required this.category,
    required this.date,
    this.id,
  });

  Map<String, Object?> toMap() {
    return {
      'content': content,
      'category': category,
      'date': date.toString(),
    };
  }

  factory Note.fromMap(Map map) {
    return Note(
      content: map['content'] ?? '',
      category: map['category'] ?? '',
      date: DateTime.tryParse(map['date']) ?? DateTime.now(),
      id: map['id'] ?? 0,
    );
  }
}

// init(){
//  var note = Note(cnt:'my note', category: 'school', date: DateTimontee.now()).toMap();

// }
