import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_mvvm_mobx_github/features/domain/entities/produto.dart';
import 'package:flutter_mvvm_mobx_github/features/presentation/pages/ProductDetailPage.dart';
import 'package:flutter_mvvm_mobx_github/features/presentation/pages/CheckoutPage.dart';
import 'package:flutter_mvvm_mobx_github/features/presentation/stores/cart_store.dart';

import 'helpers/test_app.dart';
import 'helpers/test_mocks.mocks.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Fluxo de Carrinho', () {
    late CartStore cartStore;
    late MockIPreferenceRepository mockPreferenceRepo;
    final produto = Produto(nome: 'Mochila Sport', preco: 149.90);

    setUp(() {
      cartStore = CartStore();
      mockPreferenceRepo = MockIPreferenceRepository();
    });

    group('ProductDetailPage', () {
      testWidgets('deve exibir nome e preço do produto', (tester) async {
        await tester.pumpWidget(buildTestApp(
          child: ProductDetailPage(produto: produto),
          cartStore: cartStore,
        ));
        await tester.pump();

        expect(find.text('Mochila Sport'), findsOneWidget);
        expect(find.textContaining('149.90'), findsOneWidget);
        expect(find.text('Add to Cart'), findsOneWidget);
      });

      testWidgets('tap em Add to Cart exibe snackbar de confirmação',
          (tester) async {
        await tester.pumpWidget(buildTestApp(
          child: ProductDetailPage(produto: produto),
          cartStore: cartStore,
        ));
        await tester.pump();

        await tester.tap(find.text('Add to Cart'));
        await tester.pump();

        expect(find.textContaining('added to cart'), findsOneWidget);
      });

      testWidgets('tap em Add to Cart adiciona item ao CartStore', (tester) async {
        await tester.pumpWidget(buildTestApp(
          child: ProductDetailPage(produto: produto),
          cartStore: cartStore,
        ));
        await tester.pump();

        expect(cartStore.cartItems, isEmpty);

        await tester.tap(find.text('Add to Cart'));
        await tester.pump();

        expect(cartStore.cartItems.length, 1);
        expect(cartStore.cartItems.first.nome, 'Mochila Sport');
      });
    });

    group('CheckoutPage', () {
      testWidgets('deve exibir carrinho vazio quando não há itens', (tester) async {
        when(mockPreferenceRepo.createPreference(any))
            .thenAnswer((_) async => 'pref_123');

        await tester.pumpWidget(buildTestApp(
          child: const CheckoutPage(),
          cartStore: cartStore,
          preferenceRepository: mockPreferenceRepo,
        ));
        await tester.pump();

        expect(find.text('Total: R\$ 0.00'), findsOneWidget);
        expect(find.text('Proceed to Payment'), findsOneWidget);
      });

      testWidgets('deve listar itens do carrinho com preços', (tester) async {
        cartStore.addToCart(Produto(nome: 'Camiseta', preco: 59.90));
        cartStore.addToCart(Produto(nome: 'Calça', preco: 120.00));
        when(mockPreferenceRepo.createPreference(any))
            .thenAnswer((_) async => 'pref_456');

        await tester.pumpWidget(buildTestApp(
          child: const CheckoutPage(),
          cartStore: cartStore,
          preferenceRepository: mockPreferenceRepo,
        ));
        await tester.pump();

        expect(find.text('Camiseta'), findsOneWidget);
        expect(find.text('Calça'), findsOneWidget);
        expect(find.text('Total: R\$ 179.90'), findsOneWidget);
      });

      testWidgets('remover item do carrinho atualiza a lista e o total',
          (tester) async {
        cartStore.addToCart(Produto(nome: 'Tênis', preco: 200.00));
        cartStore.addToCart(Produto(nome: 'Meia', preco: 20.00));
        when(mockPreferenceRepo.createPreference(any))
            .thenAnswer((_) async => 'pref_789');

        await tester.pumpWidget(buildTestApp(
          child: const CheckoutPage(),
          cartStore: cartStore,
          preferenceRepository: mockPreferenceRepo,
        ));
        await tester.pump();

        // Remove "Meia"
        final removeButtons = find.byIcon(Icons.remove_shopping_cart);
        await tester.tap(removeButtons.last);
        await tester.pump();

        expect(find.text('Meia'), findsNothing);
        expect(find.text('Total: R\$ 200.00'), findsOneWidget);
      });

      testWidgets('botão Proceed to Payment chama createPreference', (tester) async {
        cartStore.addToCart(Produto(nome: 'Produto X', preco: 50.00));
        when(mockPreferenceRepo.createPreference(any))
            .thenAnswer((_) async => 'pref_abc');

        await tester.pumpWidget(buildTestApp(
          child: const CheckoutPage(),
          cartStore: cartStore,
          preferenceRepository: mockPreferenceRepo,
        ));
        await tester.pump();

        await tester.tap(find.text('Proceed to Payment'));
        await tester.pumpAndSettle();

        verify(mockPreferenceRepo.createPreference(any)).called(1);
      });
    });
  });
}
