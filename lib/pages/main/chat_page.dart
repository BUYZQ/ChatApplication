import 'package:chat_app_example/services/firestore/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../components/message_text_field.dart';

class ChatPage extends StatefulWidget {
  final String username;
  final String uid;
  final String? imageUrl;

  const ChatPage({
    super.key,
    required this.username,
    required this.uid,
    required this.imageUrl,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Container(
                color: theme.scaffoldBackgroundColor,
                width: double.infinity,
                height: 60,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.keyboard_arrow_left,
                        size: 35,
                        color: theme.textTheme.displaySmall?.color,
                      ),
                    ),
                    widget.imageUrl == null
                        ? Icon(
                            Icons.person,
                            size: 35,
                            color: theme.textTheme.displaySmall?.color,
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              widget.imageUrl!,
                              height: 50,
                              width: 50,
                              fit: BoxFit.fill,
                            ),
                          ),
                    const SizedBox(width: 10),
                    Text(widget.username,
                        style: TextStyle(
                          fontSize: 18,
                          color: theme.textTheme.displaySmall?.color,
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _chatService.getMessages(
                    _firebaseAuth.currentUser!.uid,
                    widget.uid,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Загрузить сообщения не удалось'),
                      );
                    }
                    List<dynamic> messages = snapshot.data!.docs;
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = messages[index];
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        String message = data['message'];
                        bool isCurrentUser =
                            data['senderId'] == _firebaseAuth.currentUser!.uid;
                        Timestamp time = data['timestamp'];
                        return Row(
                          mainAxisAlignment: isCurrentUser
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                margin: EdgeInsets.only(
                                  top: 4,
                                  left: isCurrentUser ? 130 : 4,
                                  right: isCurrentUser ? 4 : 130,
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: isCurrentUser
                                        ? Colors.deepPurpleAccent
                                        : Colors.blueGrey),
                                child: Text(message, softWrap: true),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MessageTextField(
                  messageController: _messageController,
                  sendMessage: sendMessage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.uid,
        widget.username,
        _messageController.text,
      );
    }
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _messageController.clear();
  }
}
