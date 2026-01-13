class Tag {
  final String id;
  final String name;
  List<String>? tags;

  Tag({required this.id, required this.name, this.tags});

  factory Tag.fromJson(Map<String, dynamic> json) =>
      Tag(id: json['_id'] ?? json['id'] ?? '', name: json['name'] ?? '');

  Map<String, dynamic> toJson() => {'_id': id, 'name': name};
}
