import 'package:flutter/foundation.dart';
import 'package:shop_app/repository/user_repository.dart';

import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserRepository userRepository = UserRepository();

  Future<void> addUserToDatabase(AppUser user) async {

    return userRepository.addUserToDatabase(user);
  }

  Future<void> updateUser(String email, AppUser newUser) async {
    notifyListeners();
   return userRepository.updateUser(email, newUser);

  }
}
