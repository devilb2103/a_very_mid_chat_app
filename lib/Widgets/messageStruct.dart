class messageStruct {
  final String sender;
  final String id;
  final String message;
  final String time;

  messageStruct(
      {required this.sender,
      required this.id,
      required this.message,
      required this.time});

  factory messageStruct.fromJson(Map<String, dynamic> msg) {
    return messageStruct(
      sender: msg['user'],
      id: msg['id'],
      message: msg['message'],
      time: msg["time"],
    );
  }
}
