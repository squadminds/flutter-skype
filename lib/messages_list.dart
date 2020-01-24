import 'package:flutter/material.dart';
import 'package:chat_app/model/message.dart';

class MessageList with ChangeNotifier{

  List<Message> messages = [];

  void addMessage(Message message){
    messages.insert(0, message);
    notifyListeners();
  }

  List<Message> get message{
    return messages;
  }


}