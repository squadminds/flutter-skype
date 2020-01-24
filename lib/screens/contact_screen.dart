import 'package:chat_app/model/message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../messages_list.dart';
import 'contact_chat_screen.dart';
import '../model/contact.dart';

class ContactsScreen extends StatelessWidget {

  final List<Contact> contacts = [
    Contact('Barinder', "Helllo",contactID: 1),
    Contact('Vivek', "hello hy",contactID: 2)
  ];

  @override
  Widget build(BuildContext context) {

    List<Message> messageList = Provider.of<MessageList>(context).messages;

    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
      ),
      body: ListView.builder(itemBuilder: (BuildContext context, int index) {
        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ContactChatScreen(contact: contacts[index],)),
            );
          },
          leading: CircleAvatar(child: Text(contacts[index].name[0]),),
          title: Text(contacts[index].name),
          subtitle: Text(contacts[index].lastMessage),
        );
      }, itemCount: contacts.length,),
    );
  }

  String lastMessage(List<Message> messages,int contactId){

    if(messages.isNotEmpty) {
       return messages
          .lastWhere((m) => m.senderId == contactId).text;
    }else{
       return "";
    }
  }
}
