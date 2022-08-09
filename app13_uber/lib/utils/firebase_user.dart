import 'package:app13_uber/model/nUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FirebaseUser {
  static User getCurrentUser() {
    FirebaseAuth auth = FirebaseAuth.instance;
    return auth.currentUser!;
  }

  static Future<nUser> getLoggedUserData() async {
    User user = getCurrentUser();
    String userId = user.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;

    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await db.collection('users').doc(userId).get();

    Map<String, dynamic>? data = snapshot.data();

    String userType = data?['userType'];
    String email = data?['email'];
    String name = data?['name'];

    var newUser = nUser();
    newUser.userId = userId;
    newUser.userType = userType;
    newUser.email = email;
    newUser.name = name;

    return newUser;
  }

  static updateLocationData(String requisitionId, double latitude,
      double longitude, String type) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    nUser user = await getLoggedUserData();
    user.latitude = latitude;
    user.longitude = longitude;

    db
        .collection('requisitions')
        .doc(requisitionId)
        .update({type: user.toMap()});
  }
}
