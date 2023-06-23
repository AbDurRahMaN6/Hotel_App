import 'package:auth_ui/api/auth.dart';
import 'package:auth_ui/enum/role.dart';
import 'package:auth_ui/ui/login.dart';
import 'package:auth_ui/ui/manager_dashboard.dart';
import 'package:auth_ui/ui/users/user_dashboard.dart';
import 'package:flutter/material.dart';

import 'admin_dashboard.dart';

class Register extends StatefulWidget {
  static const routeName = '/register';
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();
  // Roles? _roleForUser = Roles.roleUser;
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
      role == Roles.roleManager.names
          ? Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ManagerDashboard()))
          : Navigator.push(context,
              MaterialPageRoute(builder: (context) => const UserDashboard()));
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
                  // const Text(
                  //   "What is your Role?",
                  //   style: TextStyle(
                  //     fontSize: 16,
                  //     color: Colors.black,
                  //   ),
                  // ),
                  // RadioListTile<Roles>(
                  //   title: const Text(
                  //     'User',
                  //     style: TextStyle(
                  //       fontSize: 16,
                  //       color: Colors.black,
                  //     ),
                  //   ),
                  //   value: Roles.roleUser,
                  //   groupValue: _roleForUser,
                  //   onChanged: (Roles? value) {
                  //     setState(() {
                  //       _roleForUser = value;
                  //       role = Roles.roleUser.names;
                  //     });
                  //   },
                  // ),
                  // RadioListTile<Roles>(
                  //   title: const Text(
                  //     'Manager',
                  //     style: TextStyle(
                  //       fontSize: 16,
                  //       color: Colors.black,
                  //     ),
                  //   ),
                  //   value: Roles.roleManager,
                  //   groupValue: _roleForUser,
                  //   onChanged: (Roles? value) {
                  //     setState(() {
                  //       _roleForUser = value;
                  //       role = Roles.roleManager.names;
                  //     });
                  //   },
                  // ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  ElevatedButton(
                      onPressed: submitSignUpForm,
                      child: const Text(
                        'Create Account',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      )),
                  TextButton(
                    child: const Text(
                      "Login",
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
