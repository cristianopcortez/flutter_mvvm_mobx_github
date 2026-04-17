import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_mvvm_mobx_github/features/domain/entities/post.dart';
import 'package:flutter_mvvm_mobx_github/features/domain/repositories/i_post_repository.dart';
import 'package:flutter_mvvm_mobx_github/features/presentation/stores/post_view_model.dart';

import 'post_view_model_test.mocks.dart';

@GenerateMocks([IPostRepository])
void main() {
  group('PostViewModel', () {
    late PostViewModel viewModel;
    late MockIPostRepository mockRepository;

    setUp(() {
      mockRepository = MockIPostRepository();
      viewModel = PostViewModel(mockRepository);
    });

    test('estado inicial deve ser NORMAL com lista de posts vazia', () {
      expect(viewModel.pageState, PageState.NORMAL);
      expect(viewModel.posts, isEmpty);
      expect(viewModel.isServiceRequestLoading, false);
    });

    test('getAllPost2 deve atualizar pageState para SUCCESS e popular posts', () async {
      final fakePosts = [
        Post(id: 1, userId: 1, title: 'Post 1', body: 'Conteúdo 1'),
        Post(id: 2, userId: 1, title: 'Post 2', body: 'Conteúdo 2'),
      ];
      when(mockRepository.getPosts()).thenAnswer((_) async => fakePosts);

      await viewModel.getAllPost2();

      expect(viewModel.pageState, PageState.SUCCESS);
      expect(viewModel.posts.length, 2);
      expect(viewModel.posts.first.title, 'Post 1');
    });

    test('getAllPost2 deve atualizar pageState para ERROR quando repositório falha', () async {
      when(mockRepository.getPosts()).thenThrow(Exception('Falha de rede'));

      await viewModel.getAllPost2();

      expect(viewModel.pageState, PageState.ERROR);
      expect(viewModel.posts, isEmpty);
    });

    test('getAllPost2 deve retornar lista vazia quando repositório retorna vazio', () async {
      when(mockRepository.getPosts()).thenAnswer((_) async => []);

      await viewModel.getAllPost2();

      expect(viewModel.pageState, PageState.SUCCESS);
      expect(viewModel.posts, isEmpty);
    });

    test('changeRequest deve alternar isServiceRequestLoading', () {
      expect(viewModel.isServiceRequestLoading, false);

      viewModel.changeRequest();
      expect(viewModel.isServiceRequestLoading, true);

      viewModel.changeRequest();
      expect(viewModel.isServiceRequestLoading, false);
    });

    test('getAllPost2 deve chamar o repositório exatamente uma vez', () async {
      when(mockRepository.getPosts()).thenAnswer((_) async => []);

      await viewModel.getAllPost2();

      verify(mockRepository.getPosts()).called(1);
    });
  });
}
