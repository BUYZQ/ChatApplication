import 'package:flutter/material.dart';

class MessageTextField extends StatefulWidget {
  final TextEditingController messageController;
  final Function() sendMessage;

  const MessageTextField({
    super.key,
    required this.messageController,
    required this.sendMessage,
  });

  @override
  State<MessageTextField> createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 6,
      onChanged: (value) {
        setState(() {
          widget.messageController.text;
        });
      },
      controller: widget.messageController,
      decoration: InputDecoration(
        fillColor: Colors.white,
        hintText: 'Сообщение',
        suffixIcon: widget.messageController.text.trim.call().isNotEmpty
            ? IconButton(
                onPressed: widget.sendMessage,
                icon: const Icon(Icons.send),
              )
            : null,
      ),
    );
  }
}
