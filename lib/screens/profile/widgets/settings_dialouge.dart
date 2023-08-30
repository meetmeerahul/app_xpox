import 'package:app_xpox/utils/spacing.dart';
import 'package:flutter/material.dart';

settingsDialouge(BuildContext context, String title, String content) {
  Widget backBtn = TextButton(
    child: const Text(
      "Back",
    ),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.white,
    title: Text(title, style: const TextStyle(color: Colors.black)),
    content: SingleChildScrollView(
        child: content != "privacy"
            ? Text(
                content,
                style: const TextStyle(color: Colors.black),
              )
            : showPrivacyPolicy()),
    actions: [
      backBtn,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showPrivacyPolicy() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "1. Introduction\n",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      getVerticalSpace(5),
      const Text(
          'Thank you for using XpoX (the "App"),\ndeveloped by rahulp2318@gmail.com ("we", "us", or "our").This Privacy Policy is designed to help you understand how we collect, use, and safeguard the information you provide to us through the App.'),
      getVerticalSpace(10),
      const Text('2. Information We Collect',
          style: TextStyle(fontWeight: FontWeight.bold)),
      getVerticalSpace(10),
      const Text(
          "2.1. Camera Access\nThe App may request access to your device's camera to provide features that require image or video capture. We do not store or transmit any media captured through the camera without your explicit consent."),
      getVerticalSpace(10),
      const Text(
          "2.2. Internet Access\nThe App may require internet access to function properly. We collect limited technical information, such as device identifiers, IP addresses, and browsing activity, solely for the purpose of improving App functionality and user experience."),
      getVerticalSpace(10),
      const Text(
          "2.3. Storage Access\nThe App may require access to your device's storage to save user-generated content or app-related data. We do not access or retrieve personal files from your device without your permission."),
      getVerticalSpace(10),
      const Text("3. How We Use Your Information",
          style: TextStyle(fontWeight: FontWeight.bold)),
      getVerticalSpace(10),
      const Text(
          "3.1. Camera Data\nCamera data collected by the App is used solely for the purpose of providing features that require image or video capture, such as [list specific features]. We do not share or distribute this data to third parties unless required by law."),
      getVerticalSpace(10),
      const Text(
          "3.2. Internet Data\nInternet-related data, such as device identifiers and IP addresses, may be used to analyze trends, administer the App, track user engagement, and gather demographic information. This information is anonymized and aggregated for analytical purposes."),
      getVerticalSpace(10),
      const Text(
          "3.3. Storage Data\nData stored on your device through the App remains under your control. We do not access, retrieve, or share personal files without your explicit consent."),
      getVerticalSpace(10),
      const Text(
          "3.4. Network Information\nNetwork information is utilized to ensure seamless connectivity and optimize App performance. It is not used for any other purposes."),
      getVerticalSpace(10),
      const Text("4. Third-Party Services",
          style: TextStyle(fontWeight: FontWeight.bold)),
      getVerticalSpace(10),
      const Text(
          "The App may integrate with third-party services or APIs to enhance its functionality. These third parties may collect and process your data according to their own privacy policies. We encourage you to review the privacy policies of these third parties before using their services through the App."),
    ],
  );
}
