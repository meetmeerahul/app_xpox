import 'package:app_xpox/screens/profile/widgets/logout_dialouge.dart';
import 'package:app_xpox/screens/profile/widgets/settings_dialouge.dart';
import 'package:app_xpox/utils/spacing.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => settingsDialouge(context, "About",
                  "App deveoped by Rahul P for accademic interest"),
              child: Row(
                children: [
                  const Icon(
                    Icons.info,
                    color: Colors.white,
                  ),
                  getHorizontalSpace(10),
                  Text(
                    "About",
                    style: text(),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => settingsDialouge(context, "Help",
                  "For any help or suggestions feel free to connect to meetmeerahul@gmail.com"),
              child: Row(
                children: [
                  const Icon(
                    Icons.help,
                    color: Colors.white,
                  ),
                  getHorizontalSpace(10),
                  Text(
                    "Help",
                    style: text(),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => settingsDialouge(context, "Terms and conditions",
                  "1. User Content Ownership: Users retain ownership of the content they post, granting the platform a non-exclusive license to display and distribute the content within the platform's services.\n\n2. Community Guidelines: Users must adhere to community guidelines, refraining from posting offensive, illegal, or harmful content.The platform reserves the right to remove or moderate content that violates these guidelines.\n\n3. Privacy and Data Usage: The platform collects user data to provide and improve services, outlining how data is collected, used, and shared in its privacy policy. Users can manage their privacy settings and control what information is shared.\n\n4. Intellectual Property: Users are responsible for ensuring they have the necessary rights to share content, respecting intellectual property laws. The platform respects copyright claims and may take down infringing content.\n\n5. Termination of Accounts: The platform can suspend or terminate accounts violating terms of use, and users can also choose to deactivate their accounts. Upon account termination, the platform's responsibilities regarding user content may change."),
              child: Row(
                children: [
                  const Icon(
                    Icons.list_alt,
                    color: Colors.white,
                  ),
                  getHorizontalSpace(10),
                  Text(
                    "Terms and conditions",
                    style: text(),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                settingsDialouge(context, "Privacy Policy", "privacy");
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.privacy_tip,
                    color: Colors.white,
                  ),
                  getHorizontalSpace(10),
                  Text(
                    "Privacy Policy",
                    style: text(),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => showLogoutDialog(context),
              child: Row(
                children: [
                  const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  getHorizontalSpace(10),
                  Text(
                    "Logout",
                    style: text(),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          getVerticalSpace(70),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getHorizontalSpace(20),
              const Image(
                image: AssetImage('assets/splashscreen.png'),
                height: 220,
                width: 250,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Developed by Rahul ❤️ ",
                style: text(),
              )
            ],
          )
        ],
      ),
    );
  }

  TextStyle text() {
    return const TextStyle(color: Colors.white, fontSize: 20);
  }
}
