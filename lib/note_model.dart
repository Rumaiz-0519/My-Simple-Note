class Note {
  final int? id;
  final String heading;
  final String body;
  final String createdAt;
  final String updatedAt;

  Note({
    this.id,
    required this.heading,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'heading': heading,
      'body': body,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      heading: map['heading'],
      body: map['body'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }
}
