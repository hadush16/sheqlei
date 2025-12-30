class Category {
  final String id;
  final String name;
  final List<String> tagIds; // Relational link to Tag IDs

  Category({required this.id, required this.name, required this.tagIds});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['_id'] ?? json['id'] ?? '',
    name: json['name'] ?? '',
    tagIds: List<String>.from(json['tagIds'] ?? []),
  );

  Map<String, dynamic> toJson() => {'_id': id, 'name': name, 'tagIds': tagIds};
}
