import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app/api/firebase-api.dart';
import 'package:shop_app/models/user_model.dart';

class UserRepository{
  Api userApi = Api('users');

  
  Future<void> addUserToDatabase(AppUser user) async {
    return userApi
        .addDocument(user.toMap())
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> updateUser(String email, AppUser newUser) async {
    var user = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .then((snapshot) {
      return snapshot.docs[0];
    });

    userApi.updateDocument(newUser.toMap(), user.id);

  }

}