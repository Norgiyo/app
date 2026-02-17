import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileRepository {
  UserProfileRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _userRef(String uid) {
    return _firestore.collection('users').doc(uid);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchUserProfile(String uid) {
    return _userRef(uid).snapshots();
  }

  Future<void> ensureUserProfile(User user) async {
    final userRef = _userRef(user.uid);
    final snapshot = await userRef.get();

    if (snapshot.exists) {
      await userRef.update({'lastLoginDate': FieldValue.serverTimestamp()});
      return;
    }

    final email = user.email ?? '';
    final fallbackName = email.split('@').first;

    await userRef.set({
      'uid': user.uid,
      'displayName': user.displayName ?? fallbackName,
      'email': email,
      'favoriteTeamId': null,
      'isPublicProfile': true,
      'lastLoginDate': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
      'role': 'user',
      'balance': 0,
      'shields': 0,
      'tickets': 0,
      'weekPoints': 0,
    });
  }

  Future<void> saveFavoriteTeam({
    required String uid,
    required String teamId,
  }) async {
    await _userRef(uid).update({
      'favoriteTeamId': teamId,
      'lastLoginDate': FieldValue.serverTimestamp(),
    });
  }
}
