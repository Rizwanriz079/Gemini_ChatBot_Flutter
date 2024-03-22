class Message {
  final bool isUser;
  final String message;
  final DateTime date;

  const Message({
    required this.isUser,
    required this.message,
    required this.date,
  });
}