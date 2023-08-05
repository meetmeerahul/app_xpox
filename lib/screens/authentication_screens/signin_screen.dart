import 'package:app_xpox/resourses/auth_methods.dart';
import 'package:app_xpox/screens/authentication_screens/reset_password.dart';
import 'package:app_xpox/screens/authentication_screens/signup_screen.dart';
import 'package:app_xpox/screens/bottom_nav/bottom_nav_screen.dart';
import 'package:app_xpox/screens/widgets/text_field.dart';
import 'package:app_xpox/utils/gradiant.dart';
import 'package:app_xpox/utils/spacing.dart';
import 'package:app_xpox/utils/utils.dart';
import 'package:flutter/material.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

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
            getVerticalSpace(50),
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
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const ResetPassword(),
                                ),
                              ),
                              child: const Text(
                                'Forgot password ? ',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      getVerticalSpace(20),
                      SizedBox(
                        height: 40,
                        width: 300,
                        child: isLoading != true
                            ? ElevatedButton.icon(
                                onPressed: signinUser,
                                icon: const Icon(Icons.check),
                                label: const Text('Login'),
                              )
                            : const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                      ),
                      getVerticalSpace(20),
                      const Text(
                        'OR',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      getVerticalSpace(20),
                      SizedBox(
                        height: 40,
                        width: 300,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            bool result =
                                await AuthMethods().signInWithGoogle();

                            if (result) {
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => BottomNavScreen(),
                                ),
                              );
                            } else {
                              // ignore: use_build_context_synchronously
                              showSnackbar(
                                  context, "Error Occured in google signin");
                            }
                          },
                          icon: const Image(
                            image: AssetImage('assets/google.png'),
                            height: 20,
                            width: 20,
                          ),
                          label: const Text('Signin with Google'),
                        ),
                      ),
                      getVerticalSpace(60),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account ? "),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignupScreen(),
                              ),
                            ),
                            child: const Text(
                              "Signup",
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

  signinUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().signinuser(
        email: emailController.text, password: passwordController.text);

    if (res == "Success") {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => BottomNavScreen(),
        ),
      );
    } else {
      // ignore: use_build_context_synchronously
      showSnackbar(context, res);
    }
    setState(() {
      isLoading = false;
    });
  }
}
