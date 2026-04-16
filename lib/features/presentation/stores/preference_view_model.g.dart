// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preference_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PreferenceViewModel on _PreferenceViewModelBase, Store {
  late final _$isLoadingAtom =
      Atom(name: '_PreferenceViewModelBase.isLoading', context: context);

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

  late final _$preferenceIdAtom =
      Atom(name: '_PreferenceViewModelBase.preferenceId', context: context);

  @override
  String? get preferenceId {
    _$preferenceIdAtom.reportRead();
    return super.preferenceId;
  }

  @override
  set preferenceId(String? value) {
    _$preferenceIdAtom.reportWrite(value, super.preferenceId, () {
      super.preferenceId = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_PreferenceViewModelBase.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$createPreferenceAsyncAction = AsyncAction(
      '_PreferenceViewModelBase.createPreference',
      context: context);

  @override
  Future<void> createPreference(List<Produto> cartItems) {
    return _$createPreferenceAsyncAction
        .run(() => super.createPreference(cartItems));
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
preferenceId: ${preferenceId},
errorMessage: ${errorMessage}
    ''';
  }
}
