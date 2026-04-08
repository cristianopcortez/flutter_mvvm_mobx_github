import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

import '../model/post.dart';
part 'post_view_model.g.dart';

class PostViewModel = _PostViewModelBase with _$PostViewModel;

abstract class _PostViewModelBase with Store {
  @observable
  List<Post> posts = [];

  // jsonplaceholder.typicode.com now sits behind Cloudflare bot-protection and
  // returns 403 to non-browser clients. dummyjson.com is a reliable alternative.
  final url = 'https://dummyjson.com/posts?limit=100';

  @observable
  bool isServiceRequestLoading = false;

  @observable
  PageState pageState = PageState.NORMAL;

  @action
  Future<void> getAllPost() async {
    changeRequest();
    final response = await Dio().get(url);

    if (response.statusCode == HttpStatus.ok) {
      final responseData =
          (response.data as Map<String, dynamic>)['posts'] as List;
      posts = responseData.map((e) => Post.fromJson(e)).toList();
      log("------------------ $posts");
    }

    changeRequest();
  }

  @action
  Future<void> getAllPost2() async {
    debugPrint('[PostVM] getAllPost2 started');
    pageState = PageState.LOADING;
    debugPrint('[PostVM] pageState = LOADING');

    try {
      debugPrint('[PostVM] sending GET $url');
      final dio = Dio();
      dio.options.headers['User-Agent'] = 'Mozilla/5.0 (Android) Flutter/App';
      final response = await dio.get(url);
      debugPrint('[PostVM] response statusCode: ${response.statusCode}');

      if (response.statusCode == HttpStatus.ok) {
        // dummyjson wraps the list: { "posts": [...], "total": n, ... }
        final responseData =
            (response.data as Map<String, dynamic>)['posts'] as List;
        posts = responseData.map((e) => Post.fromJson(e)).toList();
        pageState = PageState.SUCCESS;
        debugPrint('[PostVM] pageState = SUCCESS, ${posts.length} posts');
      } else {
        pageState = PageState.ERROR;
        debugPrint('[PostVM] pageState = ERROR (non-200)');
      }
    } catch (e, s) {
      debugPrint('[PostVM] CATCH error: $e');
      if (e is DioException && e.response != null) {
        debugPrint('[PostVM] response body: ${e.response?.data}');
        debugPrint('[PostVM] response headers: ${e.response?.headers}');
      }
      debugPrint('[PostVM] stackTrace: $s');
      pageState = PageState.ERROR;
    }
  }

  @action
  void changeRequest() {
    isServiceRequestLoading = !isServiceRequestLoading;
  }
}

// ignore: constant_identifier_names
enum PageState { LOADING, ERROR, SUCCESS, NORMAL }
