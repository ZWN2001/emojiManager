import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

typedef AsyncImageWidgetBuilder<T> = Widget Function(
    BuildContext context, AsyncSnapshot<T> snapshot, String url);

typedef AsyncImageFileWidgetBuilder<T> = Widget Function(
    BuildContext context, AsyncSnapshot<T> snapshot, File file);

typedef AsyncImageMemoryWidgetBuilder<T> = Widget Function(
    BuildContext context, AsyncSnapshot<T> snapshot, Uint8List bytes);

enum AsperctRaioImageType { NETWORK, FILE, ASSET, MEMORY }

///有宽高的Image
class AsperctRaioImage extends StatelessWidget {
  late String url;
  late File file;
  late Uint8List bytes;
  final ImageProvider provider;
  late AsperctRaioImageType type;
  late AsyncImageWidgetBuilder<ui.Image> builder;
  late AsyncImageFileWidgetBuilder<ui.Image> filebBuilder;
  late AsyncImageMemoryWidgetBuilder<ui.Image> memoryBuilder;

  AsperctRaioImage.network(url, {  required this.builder})
      : provider = NetworkImage(url),
        type = AsperctRaioImageType.NETWORK,
        this.url = url;

  AsperctRaioImage.file(
      file, {
        required this.filebBuilder,
      })  : provider = FileImage(file),
        type = AsperctRaioImageType.FILE,
        this.file = file;

  AsperctRaioImage.asset(name, { required this.builder})
      : provider = AssetImage(name),
        type = AsperctRaioImageType.ASSET,
        this.url = name;

  AsperctRaioImage.memory(bytes, { required this.memoryBuilder})
      : provider = MemoryImage(bytes),
        type = AsperctRaioImageType.MEMORY,
        this.bytes = bytes;

  @override
  Widget build(BuildContext context) {
    final ImageConfiguration config = createLocalImageConfiguration(context);
    final Completer<ui.Image> completer = Completer<ui.Image>();
    final ImageStream stream = provider.resolve(config);
    late ImageStreamListener listener;
    listener = ImageStreamListener(
          (ImageInfo image, bool sync) {
        completer.complete(image.image);
        stream.removeListener(listener);
      },
    );
    stream.addListener(listener);

    return FutureBuilder(
        future: completer.future,
        builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
          if (snapshot.hasData) {
            if (type == AsperctRaioImageType.FILE) {
              return filebBuilder(context, snapshot, file);
            } else if (type == AsperctRaioImageType.MEMORY) {
              return memoryBuilder(context, snapshot, bytes);
            } else {
              return builder(context, snapshot, url);
            }
          } else {
            return Container();
          }
        });
  }
}