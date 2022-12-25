import 'package:chat_app/src/common_widgets/loading/loading_widget.dart';
import 'package:chat_app/src/constants/dimensions_custom.dart';
import 'package:chat_app/src/provider/user_provider/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.idRoom, required this.friendName});
  final String idRoom;
  final String friendName;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _content = TextEditingController();
  final Stream<QuerySnapshot> _messageStream =
      FirebaseFirestore.instance.collection('messages').snapshots();

  void _onGoBack() {
    Navigator.of(context).pop();
  }

  void _onSend() {
    print(widget.idRoom);
    print(widget.friendName);
    FirebaseFirestore.instance.collection('chat').doc(widget.idRoom).set({
      'id': widget.idRoom,
      'content': _content.text,
      'receiver': widget.friendName,
      'sender': Provider.of<UserModel>(context, listen: false).getUserName,
      'time_created': DateTime.now(),
    }, SetOptions(merge: true));
    FirebaseFirestore.instance.collection('messages').add({
      'chat_id': widget.idRoom,
      'content': _content.text,
      'receiver': widget.friendName,
      'sender': Provider.of<UserModel>(context, listen: false).getUserName,
      'time_created': DateTime.now(),
    });
    _content.text = '';
  }

  bool checkIsUser(String name) {
    if (name == Provider.of<UserModel>(context).getUserName) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 0,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide()),
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: DimensionsCustom.calculateWidth(4),
                  vertical: DimensionsCustom.calculateHeight(2)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: DimensionsCustom.calculateWidth(1)),
                          child: GestureDetector(
                            onTap: _onGoBack,
                            child: Icon(
                              Icons.arrow_back,
                              size: DimensionsCustom.calculateWidth(6),
                              color: Colors.blue.shade300,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: DimensionsCustom.calculateWidth(1)),
                          child: Icon(
                            Icons.account_circle,
                            size: DimensionsCustom.calculateWidth(8),
                            color: Colors.blue.shade300,
                          ),
                        ),
                        Text(widget.friendName,
                            style: TextStyle(
                                fontSize: DimensionsCustom.calculateWidth(5),
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: DimensionsCustom.calculateWidth(1)),
                        child: Icon(
                          Icons.camera,
                          color: Colors.blue.shade300,
                          size: DimensionsCustom.calculateWidth(7),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: DimensionsCustom.calculateWidth(1)),
                        child: Icon(
                          Icons.phone,
                          color: Colors.blue.shade300,
                          size: DimensionsCustom.calculateWidth(7),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: DimensionsCustom.calculateWidth(1)),
                        child: Icon(
                          Icons.info,
                          color: Colors.blue.shade300,
                          size: DimensionsCustom.calculateWidth(7),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: _messageStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const LoadingWidget();
                      }
                      return ListView.builder(
                        reverse: true,
                        itemCount: snapshot.data?.docs.length ?? 0,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> data = snapshot.data!.docs[index]
                              .data()! as Map<String, dynamic>;
                          return Row(
                            mainAxisAlignment: checkIsUser(data['sender'])
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Container(
                                // color: checkIsUser(data['sender'])
                                //     ? Colors.blue
                                //     : Colors.white60,
                                decoration: BoxDecoration(
                                    color: checkIsUser(data['sender'])
                                        ? Colors.blue
                                        : Colors.white60,
                                    borderRadius: BorderRadius.circular(
                                        DimensionsCustom.calculateWidth(2))),

                                constraints: BoxConstraints(
                                    maxWidth:
                                        DimensionsCustom.widthScreen * 0.75),
                                padding: EdgeInsets.symmetric(
                                    vertical:
                                        DimensionsCustom.calculateHeight(1),
                                    horizontal:
                                        DimensionsCustom.calculateWidth(2)),
                                margin: EdgeInsets.symmetric(
                                    vertical:
                                        DimensionsCustom.calculateHeight(1),
                                    horizontal:
                                        DimensionsCustom.calculateWidth(4)),
                                child: Text(
                                  data['content'],
                                  style: TextStyle(
                                      fontSize:
                                          DimensionsCustom.calculateWidth(4.5),
                                      color: checkIsUser(data['sender'])
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              )
                            ],
                          );
                        },
                      );
                    })),
            Container(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide()),
              ),
              padding: EdgeInsets.symmetric(
                  vertical: DimensionsCustom.calculateHeight(1),
                  horizontal: DimensionsCustom.calculateWidth(4)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: DimensionsCustom.calculateWidth(2)),
                      child: TextField(
                        controller: _content,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: DimensionsCustom.calculateWidth(4),
                                vertical:
                                    DimensionsCustom.calculateHeight(1.5)),
                            hintText: 'Enter some thing',
                            border: const OutlineInputBorder(
                                borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(56),
                                    right: Radius.circular(56)))),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _onSend,
                    icon: Icon(
                      Icons.send,
                      size: DimensionsCustom.calculateWidth(6),
                      color: Colors.blue.shade400,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
