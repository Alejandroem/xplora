import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class SvgImageLoader extends StatefulWidget {
  final String svgUrl;

  const SvgImageLoader({Key? key, required this.svgUrl}) : super(key: key);

  @override
  State<SvgImageLoader> createState() => _SvgImageLoaderState();
}

class _SvgImageLoaderState extends State<SvgImageLoader> {
  File? _localSvgFile;

  @override
  void initState() {
    super.initState();
    _downloadAndSaveSvg(widget.svgUrl);
  }

  Future<void> _downloadAndSaveSvg(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final filePath = '${tempDir.path}/downloaded_image.svg';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        setState(() {
          _localSvgFile = file;
        });
      } else {
        throw Exception('Failed to download SVG');
      }
    } catch (e) {
      debugPrint('Error downloading SVG: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_localSvgFile == null) {
      return const CircularProgressIndicator();
    }

    return SvgPicture.file(
      _localSvgFile!,
      height: 100,
      width: 100,
      fit: BoxFit.cover,
    );
  }
}
