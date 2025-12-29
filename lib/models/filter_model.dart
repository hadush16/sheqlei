class Tag {
  final String id;
  final String name;

  Tag({required this.id, required this.name});

  factory Tag.fromJson(Map<String, dynamic> json) =>
      Tag(id: json['_id'] ?? json['id'] ?? '', name: json['name'] ?? '');
}

class Category {
  final String id;
  final String name;
  final List<String> tagIds; // Relates categories to tags

  Category({required this.id, required this.name, required this.tagIds});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['_id'] ?? json['id'] ?? '',
    name: json['name'] ?? '',
    tagIds: List<String>.from(json['tagIds'] ?? []),
  );
}

class FilterData {
  final List<Tag> tags;
  final List<Category> categories;

  FilterData({required this.tags, required this.categories});
}
