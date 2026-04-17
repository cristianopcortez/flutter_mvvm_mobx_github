import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mvvm_mobx_github/features/domain/entities/post.dart';
import 'package:flutter_mvvm_mobx_github/features/domain/entities/produto.dart';
import 'package:flutter_mvvm_mobx_github/features/presentation/stores/cart_store.dart';
import 'package:flutter_mvvm_mobx_github/features/presentation/stores/post_view_model.dart';
import 'package:flutter_mvvm_mobx_github/features/presentation/stores/preference_view_model.dart';
import 'package:flutter_mvvm_mobx_github/features/presentation/stores/produto_store.dart';
import 'package:flutter_mvvm_mobx_github/features/presentation/stores/video_player_controller_store.dart';
import 'package:flutter_mvvm_mobx_github/features/domain/repositories/i_post_repository.dart';
import 'package:flutter_mvvm_mobx_github/features/domain/repositories/i_produto_repository.dart';
import 'package:flutter_mvvm_mobx_github/features/domain/repositories/i_preference_repository.dart';

/// Constrói um [MaterialApp] com todos os providers necessários para testar
/// qualquer tela da aplicação sem depender de Firebase ou APIs externas.
///
/// O [VideoPlayerControllerStore] é criado com [fileName] vazio para evitar
/// que o [NativeVideoView] tente inicializar a plataforma nativa nos testes.
Widget buildTestApp({
  required Widget child,
  CartStore? cartStore,
  IPostRepository? postRepository,
  IProdutoRepository? produtoRepository,
  IPreferenceRepository? preferenceRepository,
  VideoPlayerControllerStore? videoStore,
}) {
  final resolvedVideoStore = videoStore ?? _emptyVideoStore();
  final resolvedCartStore = cartStore ?? CartStore();

  // MultiProvider acima do MaterialApp para que rotas criadas pelo Navigator
  // também consigam acessar os providers via context.read / Provider.of.
  return MultiProvider(
    providers: [
      Provider<VideoPlayerControllerStore>.value(value: resolvedVideoStore),
      Provider<CartStore>.value(value: resolvedCartStore),
      Provider<PostViewModel>(
        create: (_) => PostViewModel(
          postRepository ?? _throwingPostRepository(),
        ),
      ),
      Provider<ProdutoStore>(
        create: (_) => ProdutoStore(
          produtoRepository ?? _throwingProdutoRepository(),
        ),
      ),
      Provider<PreferenceViewModel>(
        create: (_) => PreferenceViewModel(
          preferenceRepository ?? _throwingPreferenceRepository(),
        ),
      ),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: child,
    ),
  );
}

/// Cria um [VideoPlayerControllerStore] com [fileName] vazio para que o
/// [Observer] na home não tente renderizar o [NativeVideoView] nos testes.
VideoPlayerControllerStore _emptyVideoStore() {
  final store = VideoPlayerControllerStore();
  runInAction(() => store.fileName = '');
  return store;
}

// Repositórios que lançam erro se chamados sem mock explícito — garante que
// os testes que não precisam de dados não chamem repositórios acidentalmente.
IPostRepository _throwingPostRepository() => _ThrowingPostRepository();
IProdutoRepository _throwingProdutoRepository() => _ThrowingProdutoRepository();
IPreferenceRepository _throwingPreferenceRepository() => _ThrowingPreferenceRepository();

class _ThrowingPostRepository implements IPostRepository {
  @override
  Future<List<Post>> getPosts() => throw UnimplementedError('Forneça um mock de IPostRepository');
}

class _ThrowingProdutoRepository implements IProdutoRepository {
  @override
  Future<List<Produto>> getProdutos() => throw UnimplementedError('Forneça um mock de IProdutoRepository');
}

class _ThrowingPreferenceRepository implements IPreferenceRepository {
  @override
  Future<String> createPreference(_) => throw UnimplementedError('Forneça um mock de IPreferenceRepository');
}
