import 'package:chat_app/src/constants/dimensions_custom.dart';
import 'package:chat_app/src/provider/user_provider/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final Stream<QuerySnapshot> _conversationStream =
      FirebaseFirestore.instance.collection('chat').snapshots();

  String getNameFriend(String receiver, String sender) {
    if (receiver == Provider.of<UserModel>(context).getUserName) {
      return sender;
    }
    return receiver;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _conversationStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return ListView.builder(
          itemCount: snapshot.data?.docs.length ?? 0,
          itemBuilder: (context, index) {
            Map<String, dynamic> data =
                snapshot.data!.docs[index].data()! as Map<String, dynamic>;
            print((data['time_created']));
            return Container(
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white70)),
                  color: Colors.white),
              padding: EdgeInsets.symmetric(
                  horizontal: DimensionsCustom.calculateWidth(4),
                  vertical: DimensionsCustom.calculateHeight(2)),
              child: Row(
                children: [
                  Icon(
                    Icons.account_circle,
                    color: Colors.blue.shade300,
                    size: DimensionsCustom.calculateWidth(10),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: DimensionsCustom.calculateWidth(2)),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getNameFriend(data['receiver'], data['sender']),
                              style: TextStyle(
                                  fontSize:
                                      DimensionsCustom.calculateWidth(4.5),
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              data['content'],
                              style: TextStyle(
                                fontSize: DimensionsCustom.calculateWidth(3.5),
                              ),
                            )
                          ]),
                    ),
                  ),
                  Flexible(
                    child: Text(data['time_created'].toString(),
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: DimensionsCustom.calculateWidth(3),
                            fontWeight: FontWeight.normal,
                            color: Colors.black)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
