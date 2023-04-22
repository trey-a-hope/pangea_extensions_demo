import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future addAuditLog({required String message}) async {
    try {
      await _firebaseFirestore.collection('audit').add(
        {
          'log': {
            'action': 'test',
            'actor': 'firebase-console',
            'message': message,
            'source': 'firestore',
            'status': 'complete',
            'target': 'audit-log-ext',
          },
        },
      );
      return;
    } catch (e) {
      throw Exception(e);
    }
  }
}
