import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './MovieListScreen.dart';
import '../reusable_widgets/reusabl_widgets.dart';
import './Signup.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://wallpaperaccess.com/full/1846693.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 200, 20, 20),
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 247, 176).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 65,
                        backgroundImage: NetworkImage('https://cdn3.iconfinder.com/data/icons/business-round-flat-vol-1-1/36/user_account_profile_avatar_person_student_male-512.png'),
                        backgroundColor: Colors.black,
                      ),
                      const SizedBox(height: 50),
                      reusableTextFields(text: 'Enter Email', icon: Icons.person_outline, isPasswordType: false, controller: _emailTextController,borderRadius: 20.0, fillColor: Colors.yellow.withOpacity(0.30)),
                      const SizedBox(height: 30),
                      reusableTextFields(text: 'Enter Password', icon: Icons.lock, isPasswordType: true, controller: _passwordTextController,borderRadius: 20.0, fillColor: Colors.yellow.withOpacity(0.30)),
                      const SizedBox(height: 30),
                      SigninSignupButton(
                        context,
                        true,
                        () async {
                          try {
                                // Validate user input
                   
                        String email = _emailTextController.text.trim();
                        String password = _passwordTextController.text.trim();

                        if (email.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("All fields are required.")),
                          );
                          return;
                        }
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: _emailTextController.text,
                                    password: _passwordTextController.text)
                                .then((value) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>MovieListsScreen(userId:'abc') ),
                              );
                            });
                          } on FirebaseAuthException catch (e) {
                            String message = handleFirebaseAuthError(e.code);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(message)),
                            );
                          } catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("An error occurred")),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      signUpOption(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String handleFirebaseAuthError(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-email':
        return 'The email address is invalid.';
      // Add more cases for other error codes
      default:
        return 'An error occurred. Please try again.';
    }
  }
}

Row signUpOption(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
        "Don't have an account?",
        style: TextStyle(color: Colors.black87),
      ),
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignupScreen()),
          );
        },
        child: const Text(
          " Sign up",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    ],
  );
}
