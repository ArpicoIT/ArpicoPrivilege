import 'package:flutter/material.dart';

class CommonActions {
  static void onSearch(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Search button tapped!")),
    );
  }

  static void onSignOut(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Signed out successfully!")),
    );
    // Add your sign-out logic here, e.g., FirebaseAuth.instance.signOut();
  }

  static void onNotification(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Notifications clicked!")),
    );
  }

}