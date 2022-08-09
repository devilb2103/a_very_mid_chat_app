class messageStruct {
  final String sender;
  final String message;

  messageStruct({required this.sender, required this.message});

  factory messageStruct.fromJson(Map<String, dynamic> msg) {
    return messageStruct(
      sender: msg['user'],
      message: msg['message'],
    );
  }
}
