import 'package:app_xpox/resourses/firestore_methods.dart';
import 'package:app_xpox/screens/bottom_nav/bottom_nav_screen.dart';
import 'package:app_xpox/utils/spacing.dart';
import 'package:app_xpox/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../providers/user_provider.dart';

class EditPostScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final snap;
  const EditPostScreen({super.key, required this.snap});

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final TextEditingController _descriptionController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _descriptionController.text = widget.snap['description'];
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

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
        actions: [
          TextButton(
            onPressed: () => {
              updateCaption(
                  widget.snap['postId'].toString(), _descriptionController.text)
            },
            child: const Text(
              'Update Caption',
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _isLoading ? const LinearProgressIndicator() : Container(),
            getVerticalSpace(100),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.snap['postUrl']),
                        fit: BoxFit.fill,
                        alignment: FractionalOffset.topCenter,
                      ),
                    ),
                  ),
                ),
                getVerticalSpace(30),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    maxLines: 5,
                    controller: _descriptionController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        hintText: "Edit the caption",
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Colors.white,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Colors.white,
                          ),
                        )),
                  ),
                ),
              ],
            ),
            getVerticalSpace(20),
          ],
        ),
      ),
    );
  }

  updateCaption(String postId, String text) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods()
          .updateData(_descriptionController.text, postId);
      if (res == "Success") {
        setState(() {
          _isLoading = false;
        });

        // ignore: use_build_context_synchronously
        showSnackbar(context, "Caption Updated!!");
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => BottomNavScreen()),
            (route) => false);
      } else {
        setState(() {
          _isLoading = false;
        });

        // ignore: use_build_context_synchronously
        showSnackbar(context, res);
      }
    } catch (err) {
      showSnackbar(
        context,
        err.toString(),
      );
    }
  }
}
