import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../reusable_widgets/reusabl_widgets.dart';
import './MovieListScreen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignupScreen> {
  final TextEditingController _usernameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Sign up',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://wallpaperaccess.com/full/1846693.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              height: MediaQuery.of(context).size.height * 0.5,
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
                      backgroundImage: NetworkImage('https://th.bing.com/th/id/OIP.QvFgN_6yo7RMMYd2BiaYLQHaHa?w=768&h=768&rs=1&pid=ImgDetMain'),
                      backgroundColor: Colors.black,
                    ),
                    const SizedBox(height: 10.0),
                    reusableTextFields(
                        text: 'Enter Username', icon: Icons.person_outline, isPasswordType: false, controller: _usernameTextController,borderRadius: 20.0, fillColor: Colors.yellow.withOpacity(0.30)),
                    const SizedBox(height: 10),
                    reusableTextFields(
                        text: 'Enter Email', icon: Icons.email, isPasswordType: false, controller: _emailTextController,
                     borderRadius: 20.0, fillColor: Colors.yellow.withOpacity(0.30)),
                    const SizedBox(height: 10),
                    reusableTextFields(
                        text: 'Enter Password', icon: Icons.lock, isPasswordType: true, controller: _passwordTextController,borderRadius: 20.0, fillColor: Colors.yellow.withOpacity(0.30)),
                    const SizedBox(height: 10),
                    SigninSignupButton(
                      context,
                      false,
                      () async {
                        // Validate user input
                        String username = _usernameTextController.text.trim();
                        String email = _emailTextController.text.trim();
                        String password = _passwordTextController.text.trim();

                        if (username.isEmpty || email.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("All fields are required.")),
                          );
                          return;
                        }

                        try {
                          UserCredential userCredential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: email, password: password);

                          // Store username in Firebase (replace with your logic)
                          await userCredential.user?.updateDisplayName(username);

                          String uid = getCurrentUserId();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieListsScreen(userId:'abc'),
                            ),
                          );
                        } on FirebaseAuthException catch (e) {
                          String message = handleFirebaseAuthError(e.code);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(message)));
                        } catch (error) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(content: Text("An error occurred")));
                        }
                      },
                    ),
                  ],
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
      case 'weak-password':
        return 'Password is too weak.';
      case 'email-already-in-use':
        return 'The email address is already in use by another account.';
      case 'invalid-email':
        return 'The email address is invalid.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}

String getCurrentUserId() {
  final User? user = FirebaseAuth.instance.currentUser;
  return user?.uid ?? '';
}
