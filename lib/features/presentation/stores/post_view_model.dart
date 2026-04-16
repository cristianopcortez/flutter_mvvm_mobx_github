import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

import '../../domain/entities/post.dart';
import '../../domain/repositories/i_post_repository.dart';
part 'post_view_model.g.dart';

class PostViewModel = _PostViewModelBase with _$PostViewModel;

abstract class _PostViewModelBase with Store {
  final IPostRepository _repository;

  _PostViewModelBase(this._repository);

  @observable
  List<Post> posts = [];

  @observable
  bool isServiceRequestLoading = false;

  @observable
  PageState pageState = PageState.NORMAL;

  @action
  Future<void> getAllPost2() async {
    debugPrint('[PostVM] getAllPost2 started');
    pageState = PageState.LOADING;

    try {
      posts = await _repository.getPosts();
      pageState = PageState.SUCCESS;
      debugPrint('[PostVM] pageState = SUCCESS, ${posts.length} posts');
    } catch (e, s) {
      debugPrint('[PostVM] CATCH error: $e');
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
