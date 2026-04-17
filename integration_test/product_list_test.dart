import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_mvvm_mobx_github/features/domain/entities/produto.dart';
import 'package:flutter_mvvm_mobx_github/features/presentation/pages/ProductDetailPage.dart';
import 'package:flutter_mvvm_mobx_github/features/presentation/pages/ProductHomePage.dart';

import 'helpers/test_app.dart';
import 'helpers/test_mocks.mocks.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('ProductHomePage', () {
    late MockIProdutoRepository mockProdutoRepo;

    setUp(() {
      mockProdutoRepo = MockIProdutoRepository();
    });

    testWidgets('deve exibir indicador de carregamento enquanto busca produtos',
        (tester) async {
      // Completer garante que o future não resolve antes da checagem,
      // evitando race condition com o processamento de microtasks no device.
      final completer = Completer<List<Produto>>();
      when(mockProdutoRepo.getProdutos()).thenAnswer((_) => completer.future);

      await tester.pumpWidget(buildTestApp(
        child: const ProductHomePage(),
        produtoRepository: mockProdutoRepo,
      ));
      await tester.pump(); // processa a reação MobX de isLoading = true

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete([]); // libera o future para não deixar timers pendentes
      await tester.pumpAndSettle();
    });

    testWidgets('deve exibir mensagem de erro quando o repositório falha',
        (tester) async {
      when(mockProdutoRepo.getProdutos()).thenThrow(Exception('Erro Firestore'));

      await tester.pumpWidget(buildTestApp(
        child: const ProductHomePage(),
        produtoRepository: mockProdutoRepo,
      ));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Erro ao carregar produtos.'), findsOneWidget);
    });

    testWidgets('deve exibir mensagem quando não há produtos', (tester) async {
      when(mockProdutoRepo.getProdutos()).thenAnswer((_) async => []);

      await tester.pumpWidget(buildTestApp(
        child: const ProductHomePage(),
        produtoRepository: mockProdutoRepo,
      ));
      await tester.pumpAndSettle();

      expect(find.text('Nenhum produto encontrado.'), findsOneWidget);
    });

    testWidgets('deve exibir lista de produtos quando o repositório retorna dados',
        (tester) async {
      final produtos = [
        Produto(nome: 'Camiseta Azul', preco: 59.90, categoria: 'Roupas'),
        Produto(nome: 'Tênis Branco', preco: 199.90, categoria: 'Calçados'),
      ];
      when(mockProdutoRepo.getProdutos()).thenAnswer((_) async => produtos);

      await tester.pumpWidget(buildTestApp(
        child: const ProductHomePage(),
        produtoRepository: mockProdutoRepo,
      ));
      await tester.pumpAndSettle();

      expect(find.text('Camiseta Azul'), findsOneWidget);
      expect(find.text('Tênis Branco'), findsOneWidget);
      expect(find.textContaining('59.90'), findsOneWidget);
    });

    testWidgets('tap em um produto navega para a tela de detalhes',
        (tester) async {
      final produtos = [
        Produto(nome: 'Boné Preto', preco: 45.00, categoria: 'Acessórios'),
      ];
      when(mockProdutoRepo.getProdutos()).thenAnswer((_) async => produtos);

      await tester.pumpWidget(buildTestApp(
        child: const ProductHomePage(),
        produtoRepository: mockProdutoRepo,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Boné Preto'));
      await tester.pumpAndSettle();

      expect(find.byType(ProductDetailPage), findsOneWidget);
      expect(find.text('Boné Preto'), findsOneWidget);
    });

    testWidgets('ícone do carrinho na AppBar está visível', (tester) async {
      when(mockProdutoRepo.getProdutos()).thenAnswer((_) async => []);

      await tester.pumpWidget(buildTestApp(
        child: const ProductHomePage(),
        produtoRepository: mockProdutoRepo,
      ));
      await tester.pump();

      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
    });
  });
}
