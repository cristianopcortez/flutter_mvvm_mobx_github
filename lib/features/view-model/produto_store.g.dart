// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'produto_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProdutoStore on _ProdutoStore, Store {
  late final _$isLoadingAtom =
      Atom(name: '_ProdutoStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$hasErrorAtom =
      Atom(name: '_ProdutoStore.hasError', context: context);

  @override
  bool get hasError {
    _$hasErrorAtom.reportRead();
    return super.hasError;
  }

  @override
  set hasError(bool value) {
    _$hasErrorAtom.reportWrite(value, super.hasError, () {
      super.hasError = value;
    });
  }

  late final _$produtosAtom =
      Atom(name: '_ProdutoStore.produtos', context: context);

  @override
  ObservableList<Produto> get produtos {
    _$produtosAtom.reportRead();
    return super.produtos;
  }

  @override
  set produtos(ObservableList<Produto> value) {
    _$produtosAtom.reportWrite(value, super.produtos, () {
      super.produtos = value;
    });
  }

  late final _$fetchProdutosAsyncAction =
      AsyncAction('_ProdutoStore.fetchProdutos', context: context);

  @override
  Future<void> fetchProdutos() {
    return _$fetchProdutosAsyncAction.run(() => super.fetchProdutos());
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
hasError: ${hasError},
produtos: ${produtos}
    ''';
  }
}
