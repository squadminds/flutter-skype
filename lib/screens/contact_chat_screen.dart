import 'package:chat_app/model/contact.dart';
import 'package:chat_app/model/message.dart';
import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../messages_list.dart';

class ContactChatScreen extends StatefulWidget {
  final Contact contact;

  const ContactChatScreen({Key key, this.contact}) : super(key: key);

  @override
  _ContactChatScreenState createState() => _ContactChatScreenState();
}

class _ContactChatScreenState extends State<ContactChatScreen> {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    getMessages(Provider.of<MessageList>(context,listen: false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.contact.name),
        ),
        body: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                key: UniqueKey(),
                padding: EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (_, int index) {
                  return _messages[index];
                },
                itemCount: _messages.length,
              ),
            ),
            Divider(height: 1.0),
            _buildTextComposer()
          ],
        ),
    );
  }

  void getMessages(MessageList messageList) {

    List<Message> filteredSend = messageList.message.where((m) => m.senderId == widget.contact.contactID ||
        m.receiver == widget.contact.contactID ).toList();

    for (int i = 0; i < filteredSend.length; i++) {
      _messages.add(ChatMessage(
        filteredSend[i],
        isSender: filteredSend[i].receiver == widget.contact.contactID ? false : true,
      ));
    }
  }

  void _handleSubmitted(String text) {
    _textController.clear();

    String msg = text.trim();

    Message message = Message(
        senderId: widget.contact.contactID,
        receiver: widget.contact.contactID == 1 ? 2 : 1,
        text: msg,
        dateTime: DateTime.now());

    ChatMessage chatMessage = ChatMessage(message,isSender: true); //chat widget

    setState(() {
      _messages.insert(0, chatMessage);
    });

    Provider.of<MessageList>(context, listen: false).addMessage(message);
  }

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              minLines: 1,
              maxLines: 3,
              controller: _textController,
              onSubmitted: _handleSubmitted,
              textInputAction: TextInputAction.go,
              decoration: InputDecoration.collapsed(hintText: "Send a message"),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
                icon: Icon(
                  Icons.send,
                  color: Theme.of(context).primaryColorLight,
                ),
                onPressed: () => _handleSubmitted(_textController.text)),
          ),
        ],
      ),
    );
  }
}
