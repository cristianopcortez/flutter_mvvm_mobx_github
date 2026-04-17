import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_mvvm_mobx_github/features/domain/entities/post.dart';
import 'package:flutter_mvvm_mobx_github/features/presentation/pages/PostDetailScreen.dart';
import 'package:flutter_mvvm_mobx_github/features/presentation/pages/PostHomePage.dart';

import 'helpers/test_app.dart';
import 'helpers/test_mocks.mocks.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('PostHomePage', () {
    late MockIPostRepository mockPostRepo;

    setUp(() {
      mockPostRepo = MockIPostRepository();
    });

    testWidgets('deve exibir indicador de carregamento durante a busca',
        (tester) async {
      final completer = Completer<List<Post>>();
      when(mockPostRepo.getPosts()).thenAnswer((_) => completer.future);

      await tester.pumpWidget(buildTestApp(
        child: const PostHomePage(),
        postRepository: mockPostRepo,
      ));
      await tester.pump(); // processa a reação MobX de pageState = LOADING

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete([]); // libera o future para não deixar timers pendentes
      await tester.pumpAndSettle();
    });

    testWidgets('deve exibir "Error" quando o repositório falha', (tester) async {
      when(mockPostRepo.getPosts()).thenThrow(Exception('Falha na API'));

      await tester.pumpWidget(buildTestApp(
        child: const PostHomePage(),
        postRepository: mockPostRepo,
      ));
      await tester.pumpAndSettle();

      expect(find.text('Error'), findsOneWidget);
    });

    testWidgets('deve exibir a AppBar com título POSTS', (tester) async {
      when(mockPostRepo.getPosts()).thenAnswer((_) async => []);

      await tester.pumpWidget(buildTestApp(
        child: const PostHomePage(),
        postRepository: mockPostRepo,
      ));
      await tester.pump();

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('POSTS'), findsOneWidget);
    });

    testWidgets('deve exibir lista de posts quando a requisição tem sucesso',
        (tester) async {
      final posts = [
        Post(id: 1, title: 'Primeiro Post', body: 'Conteúdo do primeiro post'),
        Post(id: 2, title: 'Segundo Post', body: 'Conteúdo do segundo post'),
      ];
      when(mockPostRepo.getPosts()).thenAnswer((_) async => posts);

      await tester.pumpWidget(buildTestApp(
        child: const PostHomePage(),
        postRepository: mockPostRepo,
      ));
      await tester.pumpAndSettle();

      expect(find.text('Primeiro Post'), findsOneWidget);
      expect(find.text('Segundo Post'), findsOneWidget);
    });

    testWidgets('tap em Detalhes navega para PostDetailScreen', (tester) async {
      final posts = [
        Post(id: 1, title: 'Post de Teste', body: 'Corpo do post de teste'),
      ];
      when(mockPostRepo.getPosts()).thenAnswer((_) async => posts);

      await tester.pumpWidget(buildTestApp(
        child: const PostHomePage(),
        postRepository: mockPostRepo,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Detalhes'));
      await tester.pumpAndSettle();

      expect(find.byType(PostDetailScreen), findsOneWidget);
    });

    testWidgets('botão de voltar na AppBar chama Navigator.pop', (tester) async {
      when(mockPostRepo.getPosts()).thenAnswer((_) async => []);

      await tester.pumpWidget(buildTestApp(
        child: const PostHomePage(),
        postRepository: mockPostRepo,
      ));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });
  });
}
