import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pangea_extensions_demo/services/services.dart';
import 'package:word_generator/word_generator.dart';

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  final StorageService _storageService = StorageService();
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _uploadFile(),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.blue,
                      ),
                    ),
                    child: const Text('Upload File'),
                  ),
                  ElevatedButton(
                    onPressed: () => _createUser(),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.red,
                      ),
                    ),
                    child: const Text('Create User'),
                  ),
                  ElevatedButton(
                    onPressed: () => _createCustomEvent(),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.green,
                      ),
                    ),
                    child: const Text('Create Custom Event'),
                  ),
                ],
              ),
      ),
    );
  }

  void _uploadFile() async {
    // Prompt user to select file.
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    // If file selected...
    if (result != null && result.files.single.path != null) {
      setState(() => _isLoading = true);
      try {
        // Create file instance.
        File file = File(result.files.single.path!);

        // Submit file to storage.
        await _storageService.uploadFile(file: file);

        setState(() => _isLoading = false);

        // Display success message.
        showSnackbar(text: 'File uploaded successfully.');
      } catch (e) {
        setState(() => _isLoading = false);

        // Display error message.
        showSnackbar(text: e.toString());
      }
    }
  }

  void _createUser() async {
    try {
      setState(() => _isLoading = true);

      // Generate random word for email and create password.
      String word = WordGenerator().randomNoun();
      String email = '$word@gmail.com';
      String password = 'password';

      // Submit new auth account with credentials.
      await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      setState(() => _isLoading = false);

      // Display success message.
      showSnackbar(text: '"$email" created successfully.');
    } catch (e) {
      setState(() => _isLoading = false);

      // Display error message.
      showSnackbar(text: e.toString());
    }
  }

  void _createCustomEvent() async {
    try {
      setState(() => _isLoading = true);

      // Generate random message.
      String message = WordGenerator().randomSentence();

      // Submit log doc to audit collection.
      await _firestoreService.addAuditLog(message: message);

      setState(() => _isLoading = false);

      // Display success message.
      showSnackbar(text: '"$message" event logged.');
    } catch (e) {
      setState(() => _isLoading = false);

      // Display error message.
      showSnackbar(text: e.toString());
    }
  }

  showSnackbar({required String text}) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(text),
        ),
      );
    }
  }
}
