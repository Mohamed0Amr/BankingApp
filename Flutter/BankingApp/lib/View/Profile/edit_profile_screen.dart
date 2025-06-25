import 'package:flutter/material.dart';
import 'package:bankingapp/Model/User.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  const EditProfileScreen({
    super.key,
    required this.user,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(),
   );
  }
  // Implement profile editing functionality
}