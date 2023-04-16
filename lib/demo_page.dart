import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pangea_extensions_demo/storage_service.dart';

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  final StorageService _storageService = StorageService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pangea Extensions Demo'),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: uploadFile,
                child: const Text('Upload File'),
              ),
      ),
    );
  }

  void uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      setState(() => _isLoading = true);
      try {
        File file = File(result.files.single.path!);
        await _storageService.uploadFile(
          file: file,
          path: 'eicar-test-file.com',
        );
        setState(() => _isLoading = false);
        showSnackbar(context: context);
      } catch (e) {
        setState(() => _isLoading = false);
        debugPrint(e.toString());
      }
    }
  }

  showSnackbar({required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('File uploaded successfully.'),
      ),
    );
  }
}
