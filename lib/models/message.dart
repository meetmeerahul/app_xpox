// ignore_for_file: public_member_api_docs, sort_constructors_first

class Message {
  final String senderId;
  final String receiverId;
  final String timeStamp;
  final String message;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.timeStamp,
    required this.message,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'receiverId': receiverId,
      'timeStamp': timeStamp,
      'message': message,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
      timeStamp: map['timeStamp'] as String,
      message: map['message'] as String,
    );
  }
}
