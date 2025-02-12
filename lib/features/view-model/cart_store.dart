import 'package:mobx/mobx.dart';
import '../model/produto.dart';

part 'cart_store.g.dart';

class CartStore = _CartStore with _$CartStore;

abstract class _CartStore with Store {
  @observable
  ObservableList<Produto> cartItems = ObservableList.of([]);

  @computed
  double get totalPrice {
    return cartItems.fold(0, (sum, item) => sum + (item.preco ?? 0));
  }

  @action
  void addToCart(Produto produto) {
    var qtd = 0;
    if (produto.quantidade != null) {
      produto.quantidade = produto.quantidade! + 1;
    } else {
      produto.quantidade = qtd++;
    }
    cartItems.add(produto);
  }

  @action
  void removeFromCart(Produto produto) {
    cartItems.remove(produto);
  }
}