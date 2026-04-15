import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/produto.dart';
import 'i_produto_repository.dart';

class ProdutoRepositoryImpl implements IProdutoRepository {
  final FirebaseFirestore _firestore;

  ProdutoRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<Produto>> getProdutos() async {
    final snapshot = await _firestore.collection('produto').get();
    log('ProdutoRepository: fetched ${snapshot.docs.length} produtos');
    return snapshot.docs.map((doc) => Produto.fromJson(doc.data())).toList();
  }
}
