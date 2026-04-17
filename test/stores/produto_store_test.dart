import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_mvvm_mobx_github/features/domain/entities/produto.dart';
import 'package:flutter_mvvm_mobx_github/features/domain/repositories/i_produto_repository.dart';
import 'package:flutter_mvvm_mobx_github/features/presentation/stores/produto_store.dart';

import 'produto_store_test.mocks.dart';

@GenerateMocks([IProdutoRepository])
void main() {
  group('ProdutoStore', () {
    late ProdutoStore store;
    late MockIProdutoRepository mockRepository;

    setUp(() {
      mockRepository = MockIProdutoRepository();
      store = ProdutoStore(mockRepository);
    });

    test('estado inicial deve estar limpo', () {
      expect(store.isLoading, false);
      expect(store.hasError, false);
      expect(store.produtos, isEmpty);
    });

    test('fetchProdutos deve popular produtos e limpar flags após sucesso', () async {
      final fakeProdutos = [
        Produto(nome: 'Camiseta', preco: 59.90, categoria: 'Roupas'),
        Produto(nome: 'Tênis', preco: 199.90, categoria: 'Calçados'),
      ];
      when(mockRepository.getProdutos()).thenAnswer((_) async => fakeProdutos);

      await store.fetchProdutos();

      expect(store.isLoading, false);
      expect(store.hasError, false);
      expect(store.produtos.length, 2);
      expect(store.produtos.first.nome, 'Camiseta');
    });

    test('fetchProdutos deve definir hasError como true quando repositório falha', () async {
      when(mockRepository.getProdutos()).thenThrow(Exception('Erro Firestore'));

      await store.fetchProdutos();

      expect(store.isLoading, false);
      expect(store.hasError, true);
      expect(store.produtos, isEmpty);
    });

    test('fetchProdutos deve substituir lista anterior em nova chamada', () async {
      when(mockRepository.getProdutos()).thenAnswer(
        (_) async => [Produto(nome: 'Primeiro', preco: 10.0)],
      );
      await store.fetchProdutos();

      when(mockRepository.getProdutos()).thenAnswer(
        (_) async => [
          Produto(nome: 'Segundo A', preco: 20.0),
          Produto(nome: 'Segundo B', preco: 30.0),
        ],
      );
      await store.fetchProdutos();

      expect(store.produtos.length, 2);
      expect(store.produtos.first.nome, 'Segundo A');
    });

    test('fetchProdutos deve chamar o repositório exatamente uma vez', () async {
      when(mockRepository.getProdutos()).thenAnswer((_) async => []);

      await store.fetchProdutos();

      verify(mockRepository.getProdutos()).called(1);
    });
  });
}
