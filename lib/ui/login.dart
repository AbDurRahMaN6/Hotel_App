import 'package:auth_ui/api/auth.dart';
import 'package:auth_ui/models/user.dart';
import 'package:auth_ui/ui/admin_dashboard.dart';
import 'package:auth_ui/ui/home_screen.dart';
import 'package:auth_ui/ui/manager_dashboard.dart';
import 'package:auth_ui/ui/register.dart';
import 'package:auth_ui/ui/users/user_dashboard.dart';
import 'package:flutter/material.dart';

import '../enum/role.dart';

class Login extends StatefulWidget {
  static const routeName = '/login';
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  String? username;
  String? password;

  void submitSignInForm() {
    final isValid = formKey.currentState?.validate();
    if ((isValid ?? false)) {
      formKey.currentState?.save();
      ApiManager()
          .signInUsers(context, username, password)
          .then((Users? value) {
        if (value != null) {
          value.roles.forEach(
            (element) {
              if (element == Roles.roleAdmin.names) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Home()));
              } else if (element == Roles.roleUser.names) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserDashboard()));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Invalid user role'),
                ));
              }
            },
          );
        }
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error occurred: $error'),
        ));
      });
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
              top: 200.0,
              bottom: 100.0,
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 150,
                    width: 200,
                    child: Image.network(
                      "https://t4.ftcdn.net/jpg/03/73/05/57/360_F_373055731_2JbPvJi6XurCAFL6mUngTPkLSDg2Kz6C.jpg",
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    validator: (String? value) {
                      username = value;
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
                      hintStyle: TextStyle(color: Colors.grey),
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
                      password = value;
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
                      hintStyle: TextStyle(color: Colors.grey),
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
                  ElevatedButton(
                      onPressed: submitSignInForm,
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      )),
                  TextButton(
                    child: const Text(
                      "Create Account",
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Register()));
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

  Roles determineUserRole(dynamic userResponse) {
    final roleString = userResponse['role'] as String?;
    if (roleString == Roles.roleAdmin.names) {
      return Roles.roleAdmin;
    } else if (roleString == Roles.roleUser.names) {
      return Roles.roleUser;
    } else {
      return Roles.roleManager;
    }
  }
}
