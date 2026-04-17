import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_mvvm_mobx_github/features/presentation/pages/OverlappingButtonNativeVideoPlayer.dart';
import 'package:flutter_mvvm_mobx_github/features/presentation/stores/video_player_controller_store.dart';

import 'helpers/test_app.dart';
import 'helpers/test_mocks.mocks.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('HomeScreen', () {
    late MockIProdutoRepository mockProdutoRepo;
    late MockIPostRepository mockPostRepo;

    setUp(() {
      mockProdutoRepo = MockIProdutoRepository();
      mockPostRepo = MockIPostRepository();

      when(mockProdutoRepo.getProdutos()).thenAnswer((_) async => []);
      when(mockPostRepo.getPosts()).thenAnswer((_) async => []);
    });

    testWidgets('deve exibir os botões PRODUTOS e POSTS', (tester) async {
      await tester.pumpWidget(buildTestApp(
        child: const OverlappingButtonNativeVideoPlayer(videoPath: ''),
        produtoRepository: mockProdutoRepo,
        postRepository: mockPostRepo,
      ));
      await tester.pump();

      expect(find.text('PRODUTOS'), findsOneWidget);
      expect(find.text('POSTS'), findsOneWidget);
    });

    testWidgets('tap em PRODUTOS navega para a tela de produtos', (tester) async {
      // Usa store real (fileName preenchido) para que o Stack tenha altura
      // correta e os botões Positioned sejam alcançáveis pelo hit-test.
      await tester.pumpWidget(buildTestApp(
        child: const OverlappingButtonNativeVideoPlayer(videoPath: ''),
        produtoRepository: mockProdutoRepo,
        postRepository: mockPostRepo,
        videoStore: VideoPlayerControllerStore(),
      ));
      await tester.pump();

      await tester.tap(find.text('PRODUTOS'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.text('Produtos'), findsOneWidget);
    });

    testWidgets('tap em POSTS navega para a tela de posts', (tester) async {
      await tester.pumpWidget(buildTestApp(
        child: const OverlappingButtonNativeVideoPlayer(videoPath: ''),
        produtoRepository: mockProdutoRepo,
        postRepository: mockPostRepo,
        videoStore: VideoPlayerControllerStore(),
      ));
      await tester.pump();

      await tester.tap(find.text('POSTS'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.text('POSTS'), findsWidgets);
      expect(find.byType(AppBar), findsOneWidget);
    });
  });
}
