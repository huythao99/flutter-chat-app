import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  late User _user;

  /// An unmodifiable view of the items in the cart.

  /// The current total price of all items (assuming all items cost $42).
  String? get getUserName => _user.displayName;

  void updateUser(User newUser) {
    _user = newUser;
    notifyListeners();
  }
}
