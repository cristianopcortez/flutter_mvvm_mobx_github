import '../entities/produto.dart';

abstract class IPreferenceRepository {
  Future<String> createPreference(List<Produto> cartItems);
}
