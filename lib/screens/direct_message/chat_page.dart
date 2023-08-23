import 'package:app_xpox/resourses/firestore_methods.dart';
import 'package:app_xpox/resourses/local_notifications.dart';
import 'package:app_xpox/screens/direct_message/user_list_screen.dart';
import 'package:app_xpox/utils/spacing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controller/auth_controller.dart';
import '../../utils/utils.dart';

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  var receiver;
  var sender;

  ChatScreen({
    Key? key,
    required this.receiver,
    required this.sender,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late DocumentSnapshot<Map<String, dynamic>> receiverSnapshot;

  late DocumentSnapshot<Map<String, dynamic>> senderSnapshot;

  final TextEditingController _messageController = TextEditingController();

  final emojiController = Get.put(LoadingController());

  bool isLoading = false;

  var receiverData = {};
  var senderData = {};

  bool showEmoji = false;

  void sendMessageToStorage() async {
    if (_messageController.text.isNotEmpty) {
      await FirestoreMethods().sendMessage(
          message: _messageController.text,
          receiverId: receiverData['uid'],
          senderId: senderData['uid']);
      _messageController.clear();
    }

    LocalNotificationService.sendNotifications(
        _messageController.text,
        "New Message from ${senderData['username']} ",
        receiverData['fcmToken']);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSenderData();
    getReceiverData();
  }

  @override
  Widget build(BuildContext context) {
    print(receiverData['username']);
    print(senderData['username']);

    print("restarted");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          receiverData['username'],
          style: const TextStyle(color: Colors.white),
        ),
        leading: Row(
          children: [
            IconButton(
              onPressed: () {
                Get.off(
                  const UserListScreen(),
                );
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            CircleAvatar(
              radius: 0, // Adjust the radius as needed
              backgroundImage: NetworkImage(receiverData['photoUrl']),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _showMessagesList(),
          ),
          _messageInput(),
          Obx(
            () => emojiController.isShowing.value == true
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * .35,
                    child: EmojiPicker(
                      textEditingController:
                          _messageController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                      config: const Config(
                        columns: 7,
                        emojiSizeMax: 32 *
                            (1.0), // Issue: https://github.com/flutter/flutter/issues/28894
                      ),
                    ),
                  )
                : const Text(''),
          )
        ],
      ),
    );
  }

  Widget _showMessagesList() {
    return StreamBuilder(
      stream: FirestoreMethods()
          .getMessages(senderData['uid'], receiverData['uid']),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          showSnackbar(context, snapshot.error.toString());
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    // DateTime dateTime = data['timeStamp'].toDate();
    // print(dateTime);

    var alignment =
        (data['receiverId'] == FirebaseAuth.instance.currentUser!.uid)
            ? Alignment.topLeft
            : Alignment.topRight;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment:
              data['senderId'] == FirebaseAuth.instance.currentUser!.uid
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          children: [
            data['senderId'] == FirebaseAuth.instance.currentUser!.uid
                ? const Text(
                    'You',
                    style: TextStyle(color: Colors.white),
                  )
                : Text(
                    receiverData['username'],
                    style: const TextStyle(color: Colors.white),
                  ),
            getVerticalSpace(5),
            chatBubble(
              data['message'],
            ),
            getVerticalSpace(5),
            Text(
              DateFormat.MMMd('en_US').add_jm().format(
                    data['timeStamp'].toDate(),
                  ),
              style: const TextStyle(color: Colors.white, fontSize: 12),
            )
          ],
        ),
      ),
    );
  }

  Widget _messageInput() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            autofocus: false,
            style: const TextStyle(color: Colors.white),
            controller: _messageController,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              prefixIcon: GestureDetector(
                onTap: () {
                  emojiController.isShowing.value =
                      !emojiController.isShowing.value;
                },
                child: const Icon(
                  Icons.emoji_emotions,
                ),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              labelText: "Type Message",
              labelStyle: const TextStyle(
                color: Colors.white,
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)
                      // Border color
                      ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white54, width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
              suffixIcon: GestureDetector(
                onTap: () => {sendMessageToStorage()},
                child: const Icon(Icons.send),
              ),
            ),
          ),
        )
      ],
    );
  }

  getReceiverData() async {
    print("getSenderdata");

    setState(() {
      isLoading = true;
    });
    try {
      receiverSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.receiver)
          .get();

      print(receiverSnapshot);

      setState(() {
        receiverData = receiverSnapshot.data()!;
      });
    } catch (e) {
      showSnackbar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  getSenderData() async {
    print("getReiverdata");

    setState(() {
      isLoading = true;
    });
    try {
      senderSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.sender)
          .get();

      print(senderSnapshot);

      setState(() {
        senderData = senderSnapshot.data()!;
      });
    } catch (e) {
      showSnackbar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  Widget chatBubble(data) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.blue,
      ),
      child: Text(
        data,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }


}
