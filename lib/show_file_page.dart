import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class ShowFilePage extends StatelessWidget {
  const ShowFilePage({super.key, required this.file});
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
