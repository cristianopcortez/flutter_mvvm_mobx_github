import '../entities/post.dart';

abstract class IPostRepository {
  Future<List<Post>> getPosts();
}
