import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

import '../model/post.dart';
part 'post_view_model.g.dart';

class PostViewModel = _PostViewModelBase with _$PostViewModel;

abstract class _PostViewModelBase with Store {
  @observable
  List<Post> posts = [];

  final url = 'https://jsonplaceholder.typicode.com/posts';

  @observable
  bool isServiceRequestLoading = false;

  @observable
  PageState pageState = PageState.NORMAL;

  @action
  Future<void> getAllPost() async {
    changeRequest();
    final response = await Dio().get(url);

    if (response.statusCode == HttpStatus.ok) {
      final responseData = response.data as List;
      posts = responseData.map((e) => Post.fromJson(e)).toList();
      log("------------------ $posts");
    }

    changeRequest();
  }

  Future<void> getAllPost2() async {
    pageState = PageState.LOADING;

    try {
      final response = await Dio().get(url);

      if (response.statusCode == HttpStatus.ok) {
        final responseData = response.data as List;
        posts = responseData.map((e) => Post.fromJson(e)).toList();
        pageState = PageState.SUCCESS;
      }
    } catch (e) {
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
