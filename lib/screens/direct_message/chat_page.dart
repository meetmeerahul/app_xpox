import 'package:app_xpox/resourses/firestore_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  bool isLoading = false;

  var receiverData = {};
  var senderData = {};

  void sendMessageToStorage() async {
    if (_messageController.text.isNotEmpty) {
      await FirestoreMethods().sendMessage(
          message: _messageController.text,
          receiverId: receiverData['uid'],
          senderId: senderData['uid']);
      _messageController.clear();
    }
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: _showMessagesList(),
          ),
          _messageInput(),
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
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    var alignment = (data['senderId'] == FirebaseAuth.instance.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        children: [
          Text(senderData['username'],
              style: const TextStyle(color: Colors.white)),
          Text(
            data['message'],
            style: const TextStyle(color: Colors.white),
          )
        ],
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
              prefixIcon: const Icon(
                Icons.message,
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
                onTap: () => sendMessageToStorage(),
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
}
