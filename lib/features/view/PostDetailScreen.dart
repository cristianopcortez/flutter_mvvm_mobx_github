import 'dart:io';

import 'package:cached_network_image_builder/cached_network_image_builder.dart';
import 'package:flutter/material.dart';

import '../model/post.dart';

class PostDetailScreen extends StatelessWidget {
  final Post post;
  static const double _productFraction = 0.74;

  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    const imgSize = 300 * _productFraction;
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title ?? ''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'User ID: ${post.userId}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Post ID: ${post.id}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                'Title:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(post.title ?? ''),
              const SizedBox(height: 20),
              const Text(
                'Body:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(post.body ?? ''),
              const SizedBox(height: 5),
              CachedNetworkImageBuilder(
                url:
                "https://firebasestorage.googleapis.com/v0/b/mobx-in-mvvm.firebasestorage.app/o/shoes-gbdc252443_640.png?alt=media&token=2f887697-aab3-4251-8125-0c3539d88410",
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
                errorWidget: const Icon(Icons.error, color: Colors.red),
                imageExtensions: const ['jpg', 'png'],
              ),
            ],
          ),
        ),
      ),
    );
  }
}