import 'dart:io';

import 'package:cached_network_image_builder/cached_network_image_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import '../view-model/post_view_model.dart';
import '../view-model/video_player_controller_store.dart';
import 'PostDetailScreen.dart';

class PostHomePage extends StatefulWidget {
  const PostHomePage({super.key});

  @override
  State<PostHomePage> createState() => _PostHomePageState();
}

class _PostHomePageState extends State<PostHomePage> {
  final _viewModel = PostViewModel();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static const double _productFraction = 0.74;

  @override
  void initState() {
    super.initState();
    // _viewModel.getAllPost(); // Call getAllPost() in initState
    _viewModel.getAllPost2(); // Call getAllPost() in initState
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildCenterLikeCubic(),
    );
  }

  Center buildCenterLikeCubic() {
    return Center(child: Observer(builder: (_) {
      switch (_viewModel.pageState) {
        case PageState.LOADING:
          {
            return const CircularProgressIndicator();
          }
        case PageState.SUCCESS:
          {
            return buildWrapListCard(context);
          }

        case PageState.ERROR:
          {
            return const Center(
              child: Text('Error'),
            );
          }

        default:
          return const FlutterLogo();
      }
    }));
  }

  Widget buildWrapListCard(BuildContext context) {
    const imgSize = 140 * _productFraction;
    return Observer(builder: (_) {
      return SingleChildScrollView(
        child: Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: _viewModel.posts.map((post) {
            return Container(
              width: 150, // Adjust width as needed
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4.0),
                  Text(post.body ?? ''),
                  const SizedBox(height: 4.0),
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
                  const SizedBox(height: 4.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetailScreen(post: post),
                        ),
                      );
                    },
                    child: const Text('Detalhes'),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      );
    });
  }
  AppBar buildAppBar(BuildContext context) {
    final videoPlayerAppState = Provider.of<VideoPlayerControllerStore>(context);
    return AppBar(
      centerTitle: true,
      title: const Text('POSTS'),
      leading: Builder(
        builder: (context) {
          return Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  videoPlayerAppState.setReloadFlag(videoPlayerAppState.reloadFlag);
                  Navigator.of(context).pop();
                },
              ),
              Observer(
                builder: (_) {
                  return Visibility(
                    visible: _viewModel.isServiceRequestLoading,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
