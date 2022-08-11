class messageStruct {
  final String sender;
  final String id;
  final String message;

  messageStruct(
      {required this.sender, required this.id, required this.message});

  factory messageStruct.fromJson(Map<String, dynamic> msg) {
    return messageStruct(
      sender: msg['user'],
      id: msg['id'],
      message: msg['message'],
    );
  }
}
