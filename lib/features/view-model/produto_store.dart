import 'dart:developer';

import 'package:mobx/mobx.dart';
import '../model/produto.dart';
import '../repository/i_produto_repository.dart';

part 'produto_store.g.dart';

class ProdutoStore = _ProdutoStore with _$ProdutoStore;

abstract class _ProdutoStore with Store {
  final IProdutoRepository _repository;

  _ProdutoStore(this._repository);

  @observable
  bool isLoading = false;

  @observable
  bool hasError = false;

  @observable
  ObservableList<Produto> produtos = ObservableList.of([]);

  @action
  Future<void> fetchProdutos() async {
    isLoading = true;
    hasError = false;

    try {
      final result = await _repository.getProdutos();
      produtos
        ..clear()
        ..addAll(result);
    } catch (e) {
      log('Error fetching produto: $e');
      hasError = true;
    } finally {
      isLoading = false;
    }
  }
}
