import 'package:sheqlee/models/filter_model.dart';

final List<Tag> mockTags = [
  Tag(id: "tag_java", name: "Java"),
  Tag(id: "tag_py", name: "Python"),
  Tag(id: "tag_cpp", name: "C++"),
  Tag(id: "tag_js", name: "JavaScript"),
  Tag(id: "tag_rs", name: "Rust"),
  Tag(id: "tag_cs", name: "C#"),
  Tag(id: "tag_asp", name: "ASP .NET"),
  Tag(id: "tag_ts", name: "TypeScript"),
  Tag(id: "tag_fl", name: "Flutter"),
  Tag(id: "tag_re", name: "React"),
  Tag(id: "tag_re1", name: "React native"),
  Tag(id: "tag_re2", name: "React redux"),
  Tag(id: "tag_re3", name: "React typescript"),
];

// Mock Categories (The list view below tags)
final List<Category> mockCategories = [
  Category(
    id: "cat_modev_01",
    name: "Mobile Development",
    tagIds: ["tag_fl", "tag_java", "tag_re"],
  ),
  Category(
    id: "cat_UI_01",
    name: "Product Design",
    tagIds: ["tag_py", "tag_cs"],
  ),

  Category(id: "cat_py_01", name: "Machine Learning", tagIds: ["tag_py"]),
  Category(id: "cat_Pr_01", name: "QA & DevOps", tagIds: []),

  Category(
    id: "cat_web_01",
    name: "Web Frontend Development",
    tagIds: ["tag_js", "tag_re", "tag_rs", "tag_java"],
  ),
  Category(id: "cat_Pr_01", name: "Cyber Security", tagIds: []),
  Category(
    id: "cat_Ful_01",
    name: "Full-Stack Development",
    tagIds: ["tag_js", "tag_re", "tag_rs", "tag_java", "tag_asp", "tag_cpp"],
  ),
  Category(
    id: "cat_web_02",
    name: "System & Business Analysis",
    tagIds: ["tag_js", "tag_ts"],
  ),
  Category(id: "cat_Pr_01", name: "Project Management", tagIds: []),
];
