import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:messaging_app/components/chat_bubble.dart";
import "package:messaging_app/components/my_textfield.dart";
import "package:messaging_app/services/auth/auth_service.dart";
import "package:messaging_app/services/chat/chat_service.dart";

class ChatPage extends StatelessWidget {
  // final String receiverEmail;
  // final String receiverID;

  // ChatPage({
  //   super.key,
  //   required this.receiverEmail,
  //   required this.receiverID,
  // });

  // final TextEditingController _messageController = TextEditingController();
  // final ChatService _chatService = ChatService(); 
  // final AuthService _authService = AuthService();

  final String receiverEmail;
  final String receiverID;
  final AuthService _authService = AuthService();
  late final ChatService _chatService;
  final TextEditingController _messageController = TextEditingController();


  ChatPage({super.key, required this.receiverEmail, required this.receiverID}) {
    _chatService = ChatService(_authService);
  }
  
  void sendMessage() async {
    if(_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(receiverID, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receiverEmail),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0),
      body: Column(children: [
        Expanded(child: _buildMessageList()),
        _buildUserInput(),
      ],)
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(receiverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        return ListView(
          children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

    // build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // is current user
    bool isCurrentUser = data["senderID"] == _authService.getCurrentUser()!.uid;

    // align message to the right if sender is the current user, otherwise left
    var alignment = 
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(
            message: data["message"],
            isCurrentUser: isCurrentUser,
          )
        ],
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Row(
        children: [
          // textfield should take up most of the space
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: "Type a message",
              obscureText: false, 
            ), // MyTextField
          ), // Expanded
      
          // send button
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(Icons.arrow_upward),
              color: Colors.white,
            ),
          ), // IconButton
        ],
      ),
    ); // Row
  }
}