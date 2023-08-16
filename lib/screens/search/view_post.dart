import 'package:app_xpox/utils/spacing.dart';
import 'package:flutter/material.dart';

class ViewPost extends StatelessWidget {
  final String postUrl;
  const ViewPost({super.key, required this.postUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "View Photo",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              getVerticalSpace(MediaQuery.of(context).size.height * .01),
              Image(
                //  fit: BoxFit.contain,
                image: NetworkImage(postUrl),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
