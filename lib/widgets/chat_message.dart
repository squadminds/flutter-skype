import 'package:chat_app/model/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts_improved/flutter_tts_improved.dart';
import 'package:intl/intl.dart';

class ChatMessage extends StatefulWidget {
  final Message message;
  bool isSender = true;

  ChatMessage(this.message, {this.isSender});

  @override
  _ChatMessageState createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage>
    with SingleTickerProviderStateMixin {
  FlutterTtsImproved tts = new FlutterTtsImproved();
  AnimationController _animationController;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            widget.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            padding: widget.isSender
                ? EdgeInsets.only(
                    top: 10.0, left: 10.0, right: 10.0, bottom: 10.0)
                : EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
            decoration: BoxDecoration(
                color: widget.isSender
                    ? Theme.of(context).primaryColorLight
                    : Colors.pinkAccent,
                borderRadius: widget.isSender
                    ? BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0),
                        bottomLeft: Radius.circular(15.0))
                    : BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(widget.message.text,
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    widget.isSender
                        ? Container(height: 8.0)
                        : IconButton(
                            icon: Icon(
                                _isPlaying ? Icons.pause : Icons.play_arrow),
                            onPressed: () {
                              _speak(widget.message.text);
                            },
                          ),
                    Text(DateFormat.jm()
                        .format(widget.message.dateTime)
                        .toString()),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future _speak(String text) async {
    await tts.setLanguage("en-US");
    await tts.setPitch(1.0);
    await tts.setVolume(1.0);
    await tts.speak(text);

    tts.setStartHandler(() {
      setState(() {
        _isPlaying = true;
        _animationController.forward();
      });
    });

    tts.setCompletionHandler(() {
      setState(() {
        _isPlaying = false;
        _animationController.reverse();
      });
    });
  }
}
