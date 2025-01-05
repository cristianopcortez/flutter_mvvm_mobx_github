import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import '../view-model/produto_store.dart';
import '../view-model/video_player_controller_store.dart';
import 'ProductDetailPage.dart';

class ProductHomePage extends StatefulWidget {
  const ProductHomePage({super.key});

  @override
  State<ProductHomePage> createState() => _ProductHomePageState();
}

class _ProductHomePageState extends State<ProductHomePage> {
  final ProdutoStore produtoStore = ProdutoStore();

  @override
  void initState() {
    super.initState();
    produtoStore.fetchProdutos();
  }

  @override
  Widget build(BuildContext context) {
    final videoPlayerAppState = Provider.of<VideoPlayerControllerStore>(context);
    return PopScope(
        onPopInvoked: (route) {
          videoPlayerAppState.setReloadFlag(videoPlayerAppState.reloadFlag);
        },
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        centerTitle: true,
      ),
      body: Observer(
        builder: (_) {
          final produtos = produtoStore.produtos;

          if (produtoStore.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (produtoStore.hasError) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Erro ao carregar produtos.',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            );
          } else if (produtos.isEmpty) {
            return const Center(child: Text('Nenhum produto encontrado.'));
          } else {
            return ListView.builder(
              itemCount: produtos.length,
              itemBuilder: (context, index) {
                final produto = produtos[index];
                return ListTile(
                  title: Text(produto.nome ?? 'Unknown'),
                  subtitle: Text('Preço: ${produto.preco?.toStringAsFixed(2) ?? 'N/A'}'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(produto: produto),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    ));
  }
}