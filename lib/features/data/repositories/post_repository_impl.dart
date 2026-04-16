import 'dart:io';

import 'package:dio/dio.dart';

import '../../domain/entities/post.dart';
import '../../domain/repositories/i_post_repository.dart';

class PostRepositoryImpl implements IPostRepository {
  final Dio _dio;

  static const _url = 'https://dummyjson.com/posts?limit=100';

  PostRepositoryImpl({Dio? dio}) : _dio = dio ?? Dio();

  @override
  Future<List<Post>> getPosts() async {
    _dio.options.headers['User-Agent'] = 'Mozilla/5.0 (Android) Flutter/App';
    final response = await _dio.get(_url);

    if (response.statusCode == HttpStatus.ok) {
      final data = (response.data as Map<String, dynamic>)['posts'] as List;
      return data.map((e) => Post.fromJson(e)).toList();
    }

    throw Exception('Failed to load posts: ${response.statusCode}');
  }
}
