import 'package:app_xpox/resourses/auth_methods.dart';
import 'package:app_xpox/screens/authentication_screens/signin_screen.dart';
import 'package:app_xpox/screens/widgets/text_field.dart';
import 'package:app_xpox/utils/gradiant.dart';
import 'package:app_xpox/utils/spacing.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _emailController = TextEditingController();

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: getGradiant(),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              getVerticalSpace(MediaQuery.of(context).size.height * .2),
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
              textFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.alternate_email,
                    color: Colors.white,
                  ),
                  hintText: "Enter your registered email",
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              getVerticalSpace(20),
              SizedBox(
                height: 40,
                width: 300,
                child: isLoading != true
                    ? ElevatedButton.icon(
                        onPressed: resetPassword,
                        icon: const Icon(Icons.check),
                        label: const Text('Reset Password'),
                      )
                    : const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  resetPassword() async {
    setState(() {
      isLoading = true;
    });

    String res = await AuthMethods().resetPassword(
      _emailController.text.trim(),
    );

    if (res == "Success") {
      // ignore: use_build_context_synchronously
      showSnackbar(
          context, "You can now reset password with the email received");

      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const SigninScreen(),
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
