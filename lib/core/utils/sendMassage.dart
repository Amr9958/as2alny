// class Sendmassages{

//   Future<void> _sendMessage(String message) async {
//     if (message.isEmpty) return;

//     setState(() {
//       _messages.add("You: $message");

//       _isLoading = true;
//     });

//     final response = await GeminiService.getGeminiResponse(message);

//     setState(() {
//       _messages.add("Bot: ${response ?? 'Error'}");

//       _isLoading = false;
//     });
//   }

// }