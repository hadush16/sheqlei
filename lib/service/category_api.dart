// service/category_api.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/core/network/dio_client.dart';
import 'package:sheqlee/models/category_model.dart';

final categoryApiProvider = Provider<CategoryApi>((ref) {
  final dio = ref.watch(dioProvider);
  return CategoryApi(dio);
});

class CategoryApi {
  final Dio dio;
  CategoryApi(this.dio);

  Future<List<Category>> fetchCategories() async {
    final response = await dio.get('/categories');

    final List data = response.data['data'];
    return data.map((e) => Category.fromJson(e)).toList();
  }
}
