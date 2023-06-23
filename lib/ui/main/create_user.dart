import 'package:auth_ui/api/auth.dart';
import 'package:auth_ui/enum/role.dart';
import 'package:auth_ui/ui/login.dart';
import 'package:auth_ui/ui/manager_dashboard.dart';
import 'package:auth_ui/ui/users/user_dashboard.dart';
import 'package:flutter/material.dart';

class CreateUser extends StatefulWidget {
  static const routeName = '/create';
  const CreateUser({super.key});

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final formKey = GlobalKey<FormState>();
  String? userName;
  String? mail;
  String? pasword;
  String? role;

  void submitSignUpForm() {
    final isValid = formKey.currentState?.validate();
    if ((isValid ?? false)) {
      formKey.currentState?.save();
      ApiManager().signUpUsers(
        context,
        userName,
        mail,
        pasword,
        role,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 30.0,
              right: 30.0,
              top: 150.0,
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    validator: (String? value) {
                      userName = value;
                      if ((value ?? "").isEmpty) {
                        return "Please Enter User Name";
                      } else if ((value ?? "").length < 4) {
                        return "User Name must be atleast 4 characters long";
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: "User Name",
                      hintStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(40.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    validator: (String? value) {
                      mail = value;
                      if ((value ?? "").isEmpty) {
                        return "Please Enter Email-Id";
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: "Email-Id",
                      hintStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(40.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    obscureText: true,
                    validator: (String? value) {
                      pasword = value;
                      if ((value ?? "").isEmpty) {
                        return "Please Enter Password";
                      } else if ((value ?? "").length < 8) {
                        return "Password must be atleast 8 characters long";
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(40.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    obscureText: true,
                    validator: (String? value) {
                      if ((value ?? "").isEmpty) {
                        return "Please Re-Enter Password";
                      } else if ((value ?? "").length < 8) {
                        return "Password must be atleast 8 characters long";
                      } else if (value != pasword) {
                        return "Password must be same as above";
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: "Confirm Password",
                      hintStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(40.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  ElevatedButton(
                      onPressed: submitSignUpForm,
                      child: const Text(
                        'Create Account',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
