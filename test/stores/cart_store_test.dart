import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mvvm_mobx_github/features/domain/entities/produto.dart';
import 'package:flutter_mvvm_mobx_github/features/presentation/stores/cart_store.dart';

void main() {
  group('CartStore', () {
    late CartStore store;

    setUp(() {
      store = CartStore();
    });

    test('deve iniciar com carrinho vazio e preço total zero', () {
      expect(store.cartItems, isEmpty);
      expect(store.totalPrice, 0.0);
    });

    test('addToCart deve adicionar item ao carrinho', () {
      final produto = Produto(nome: 'Camiseta', preco: 59.90);

      store.addToCart(produto);

      expect(store.cartItems.length, 1);
      expect(store.cartItems.first.nome, 'Camiseta');
    });

    test('addToCart com quantidade null define quantidade como 0', () {
      // Comportamento atual: qtd++ retorna 0 antes de incrementar (post-increment)
      // O teste documenta esse comportamento para que seja revisado ao fazer merge
      final produto = Produto(nome: 'Item', preco: 10.0, quantidade: null);

      store.addToCart(produto);

      expect(produto.quantidade, 0);
    });

    test('addToCart com quantidade existente incrementa o valor', () {
      final produto = Produto(nome: 'Item', preco: 10.0, quantidade: 2);

      store.addToCart(produto);

      expect(produto.quantidade, 3);
    });

    test('removeFromCart deve remover o item do carrinho', () {
      final produto = Produto(nome: 'Tênis', preco: 199.90);
      store.addToCart(produto);

      store.removeFromCart(produto);

      expect(store.cartItems, isEmpty);
    });

    test('removeFromCart não afeta outros itens', () {
      final p1 = Produto(nome: 'A', preco: 10.0);
      final p2 = Produto(nome: 'B', preco: 20.0);
      store.addToCart(p1);
      store.addToCart(p2);

      store.removeFromCart(p1);

      expect(store.cartItems.length, 1);
      expect(store.cartItems.first.nome, 'B');
    });

    test('totalPrice deve somar os preços de todos os itens', () {
      store.addToCart(Produto(nome: 'A', preco: 30.0));
      store.addToCart(Produto(nome: 'B', preco: 70.0));

      expect(store.totalPrice, 100.0);
    });

    test('totalPrice deve tratar preco null como zero', () {
      store.addToCart(Produto(nome: 'Sem preço', preco: null));

      expect(store.totalPrice, 0.0);
    });

    test('totalPrice deve ser atualizado após remoção', () {
      final p1 = Produto(nome: 'A', preco: 50.0);
      final p2 = Produto(nome: 'B', preco: 50.0);
      store.addToCart(p1);
      store.addToCart(p2);
      store.removeFromCart(p1);

      expect(store.totalPrice, 50.0);
    });
  });
}
