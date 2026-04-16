import 'package:mobx/mobx.dart';
import '../../domain/entities/produto.dart';
import '../../domain/repositories/i_preference_repository.dart';

part 'preference_view_model.g.dart';

class PreferenceViewModel = _PreferenceViewModelBase with _$PreferenceViewModel;

abstract class _PreferenceViewModelBase with Store {
  final IPreferenceRepository _repository;

  _PreferenceViewModelBase(this._repository);

  @observable
  bool isLoading = false;

  @observable
  String? preferenceId;

  @observable
  String? errorMessage;

  @action
  Future<void> createPreference(List<Produto> cartItems) async {
    isLoading = true;
    errorMessage = null;

    try {
      preferenceId = await _repository.createPreference(cartItems);
    } catch (e) {
      errorMessage = 'Error creating preference: $e';
    } finally {
      isLoading = false;
    }
  }
}