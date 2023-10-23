import 'dart:typed_data';

import 'package:flutter/material.dart';

class ShowFilePage extends StatelessWidget {
  const ShowFilePage({required this.file, super.key});
  final Uint8List file;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.memory(file),
      ),
    );
  }
}
