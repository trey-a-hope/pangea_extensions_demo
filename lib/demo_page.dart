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
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                    ),
                    onPressed: uploadFile,
                    child: const Text('Upload File'),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                    ),
                    onPressed: deleteFile,
                    child: const Text('Delete File'),
                  ),
                ],
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
        await _storageService.uploadFile(file: file);
        setState(() => _isLoading = false);
        showSnackbar(
          context: context,
          text: 'File uploaded successfully.',
        );
      } catch (e) {
        setState(() => _isLoading = false);
        showSnackbar(
          context: context,
          text: e.toString(),
        );
      }
    }
  }

  void deleteFile() async {
    setState(() => _isLoading = true);
    try {
      await _storageService.deleteFile();
      setState(() => _isLoading = false);
      showSnackbar(
        context: context,
        text: 'File deleted successfully.',
      );
    } catch (e) {
      setState(() => _isLoading = false);
      showSnackbar(
        context: context,
        text: e.toString(),
      );
    }
  }

  showSnackbar({required BuildContext context, required String text}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }
}
