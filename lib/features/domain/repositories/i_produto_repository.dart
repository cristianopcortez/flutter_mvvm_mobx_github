import '../entities/produto.dart';

abstract class IProdutoRepository {
  Future<List<Produto>> getProdutos();
}
