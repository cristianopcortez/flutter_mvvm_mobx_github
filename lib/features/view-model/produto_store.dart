import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';
import '../model/produto.dart';

part 'produto_store.g.dart';

class ProdutoStore = _ProdutoStore with _$ProdutoStore;

abstract class _ProdutoStore with Store {
  @observable
  bool isLoading = false; // Initial state: not loading

  @observable
  bool hasError = false; // Initial state: no error

  @observable
  ObservableList<Produto> produtos = ObservableList.of([]);

  @action
  Future<void> fetchProdutos() async {
    isLoading = true; // Set loading state to true before fetching
    hasError = false; // Reset error state before fetching

    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('produto').get();
      produtos.clear();
      produtos.addAll(
          querySnapshot.docs.map((doc) => Produto.fromJson(doc.data())));
    } catch (e) {
      log('Error fetching produto: $e');
      hasError = true; // Set error state if there's an exception
    } finally {
      isLoading = false; // Set loading state to false after fetching (regardless of success or error)
    }
  }
}
