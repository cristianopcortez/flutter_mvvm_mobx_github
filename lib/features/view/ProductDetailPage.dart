import 'dart:io';

import 'package:cached_network_image_builder/cached_network_image_builder.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../model/produto.dart';
import '../view-model/produto_store.dart';

class ProductDetailPage extends StatelessWidget {
  final Produto produto;
  static const double _productFraction = 0.74;

  const ProductDetailPage({Key? key, required this.produto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const imgSize = 300 * _productFraction;
    return Scaffold(
      appBar: AppBar(
        title: Text(produto.nome ?? '-- N/A --'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display product image (if available)
              CachedNetworkImageBuilder(
                url:
                produto.imagem ?? '',
                builder: (image) {
                  if (!image.existsSync()
                      || image.statSync().type != FileSystemEntityType.file) {
                    return Image.asset('assets/images/error_image.png');
                  }
                  return Image.file(
                    image,
                    fit: BoxFit.contain,
                    width: imgSize,
                    height: imgSize,
                  );
                },
                placeHolder: const SizedBox(
                  width: imgSize,
                  height: imgSize,
                  child: CircularProgressIndicator(),
                ),
                errorWidget: Image.asset('assets/images/error_image.png'),
                imageExtensions: const ['jpg', 'png'],
              ),
              const SizedBox(height: 16),
              // Display product details
              Text(
                'Preço: R\$ ${produto.preco?.toStringAsFixed(2) ?? 'N/A'}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}