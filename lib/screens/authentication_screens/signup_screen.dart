import 'package:app_xpox/screens/authentication_screens/signin_screen.dart';
import 'package:app_xpox/screens/widgets/text_field.dart';
import 'package:app_xpox/utils/gradiant.dart';
import 'package:app_xpox/utils/spacing.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController bioController = TextEditingController();

  TextEditingController usernameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: getGradiant(),
        ),
        child: Column(
          children: [
            // getVerticalSpace(10),
            Row(
              children: [
                getHorizontalSpace(70),
                const Image(
                  image: AssetImage('assets/splashscreen.png'),
                  height: 150,
                  width: 300,
                ),
              ],
            ),
            Stack(
              children: [
                const CircleAvatar(
                  radius: 55,
                  backgroundImage: AssetImage('assets/nodp.png'),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: IconButton(
                    onPressed: () {
                      print('Cam icon clicked');
                    },
                    icon: const Icon(Icons.camera_alt_sharp),
                    color: Colors.black,
                  ),
                )
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 50, 20, 60),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      textFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.email_rounded,
                            color: Colors.white,
                          ),
                          hintText: "Email",
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      getVerticalSpace(20),
                      textFormField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          hintText: "Username",
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      getVerticalSpace(20),
                      textFormField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.add_reaction_outlined,
                            color: Colors.white,
                          ),
                          hintText: "Bio",
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      getVerticalSpace(20),
                      textFormField(
                          controller: passwordController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.password,
                              color: Colors.white,
                            ),
                            hintText: "Password",
                            hintStyle: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          isObscure: true),
                      getVerticalSpace(20),
                      SizedBox(
                        height: 40,
                        width: 300,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.check),
                          label: const Text('Signup'),
                        ),
                      ),
                      getVerticalSpace(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account ? "),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SigninScreen(),
                              ),
                            ),
                            child: const Text(
                              "Signin",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
