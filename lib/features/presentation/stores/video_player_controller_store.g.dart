// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_player_controller_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$VideoPlayerControllerStore on _VideoPlayerControllerStore, Store {
  late final _$controllerAtom =
      Atom(name: '_VideoPlayerControllerStore.controller', context: context);

  @override
  VideoViewController? get controller {
    _$controllerAtom.reportRead();
    return super.controller;
  }

  @override
  set controller(VideoViewController? value) {
    _$controllerAtom.reportWrite(value, super.controller, () {
      super.controller = value;
    });
  }

  late final _$isInitializedAtom =
      Atom(name: '_VideoPlayerControllerStore.isInitialized', context: context);

  @override
  bool get isInitialized {
    _$isInitializedAtom.reportRead();
    return super.isInitialized;
  }

  @override
  set isInitialized(bool value) {
    _$isInitializedAtom.reportWrite(value, super.isInitialized, () {
      super.isInitialized = value;
    });
  }

  late final _$fileNameAtom =
      Atom(name: '_VideoPlayerControllerStore.fileName', context: context);

  @override
  String get fileName {
    _$fileNameAtom.reportRead();
    return super.fileName;
  }

  @override
  set fileName(String value) {
    _$fileNameAtom.reportWrite(value, super.fileName, () {
      super.fileName = value;
    });
  }

  late final _$reloadFlagAtom =
      Atom(name: '_VideoPlayerControllerStore.reloadFlag', context: context);

  @override
  bool get reloadFlag {
    _$reloadFlagAtom.reportRead();
    return super.reloadFlag;
  }

  @override
  set reloadFlag(bool value) {
    _$reloadFlagAtom.reportWrite(value, super.reloadFlag, () {
      super.reloadFlag = value;
    });
  }

  late final _$initializeControllerAsyncAction = AsyncAction(
      '_VideoPlayerControllerStore.initializeController',
      context: context);

  @override
  Future<void> initializeController(VideoViewController newController) {
    return _$initializeControllerAsyncAction
        .run(() => super.initializeController(newController));
  }

  late final _$resetAndPlayAsyncAction =
      AsyncAction('_VideoPlayerControllerStore.resetAndPlay', context: context);

  @override
  Future<void> resetAndPlay() {
    return _$resetAndPlayAsyncAction.run(() => super.resetAndPlay());
  }

  late final _$reloadPlayerAsyncAction =
      AsyncAction('_VideoPlayerControllerStore.reloadPlayer', context: context);

  @override
  Future<void> reloadPlayer() {
    return _$reloadPlayerAsyncAction.run(() => super.reloadPlayer());
  }

  late final _$_VideoPlayerControllerStoreActionController =
      ActionController(name: '_VideoPlayerControllerStore', context: context);

  @override
  void play() {
    final _$actionInfo = _$_VideoPlayerControllerStoreActionController
        .startAction(name: '_VideoPlayerControllerStore.play');
    try {
      return super.play();
    } finally {
      _$_VideoPlayerControllerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void pause() {
    final _$actionInfo = _$_VideoPlayerControllerStoreActionController
        .startAction(name: '_VideoPlayerControllerStore.pause');
    try {
      return super.pause();
    } finally {
      _$_VideoPlayerControllerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFileName(String fileName) {
    final _$actionInfo = _$_VideoPlayerControllerStoreActionController
        .startAction(name: '_VideoPlayerControllerStore.setFileName');
    try {
      return super.setFileName(fileName);
    } finally {
      _$_VideoPlayerControllerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool setReloadFlag(bool boolReloadFlag) {
    final _$actionInfo = _$_VideoPlayerControllerStoreActionController
        .startAction(name: '_VideoPlayerControllerStore.setReloadFlag');
    try {
      return super.setReloadFlag(boolReloadFlag);
    } finally {
      _$_VideoPlayerControllerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void ensureControllerInitialized() {
    final _$actionInfo =
        _$_VideoPlayerControllerStoreActionController.startAction(
            name: '_VideoPlayerControllerStore.ensureControllerInitialized');
    try {
      return super.ensureControllerInitialized();
    } finally {
      _$_VideoPlayerControllerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void disposeController() {
    final _$actionInfo = _$_VideoPlayerControllerStoreActionController
        .startAction(name: '_VideoPlayerControllerStore.disposeController');
    try {
      return super.disposeController();
    } finally {
      _$_VideoPlayerControllerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
controller: ${controller},
isInitialized: ${isInitialized},
fileName: ${fileName},
reloadFlag: ${reloadFlag}
    ''';
  }
}
