import 'package:chat_app/src/common_widgets/loading/loading_widget.dart';
import 'package:chat_app/src/constants/dimensions_custom.dart';
import 'package:chat_app/src/constants/routes_constant.dart';
import 'package:chat_app/src/features/chat/models/chat_argument_model.dart';
import 'package:chat_app/src/provider/user_provider/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key});

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  void _onPressUser(String userName) {
    Navigator.of(context).pushNamed(RouteConstant.routeChat,
        arguments: ChatArgumentModel(userName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark),
      ),
      body: SafeArea(
          child: Padding(
        padding:
            EdgeInsets.symmetric(vertical: DimensionsCustom.calculateHeight(2)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: DimensionsCustom.calculateWidth(4)),
                child: Text(
                  "Danh sách người dùng",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: DimensionsCustom.calculateWidth(5)),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _usersStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingWidget();
                  }
                  return Consumer<UserModel>(
                    builder: (context, value, child) {
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> data = snapshot.data!.docs[index]
                              .data() as Map<String, dynamic>;
                          return GestureDetector(
                            onTap: () {
                              _onPressUser(data['full_name']);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal:
                                      DimensionsCustom.calculateWidth(4),
                                  vertical:
                                      DimensionsCustom.calculateHeight(2)),
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      DimensionsCustom.calculateHeight(1.5),
                                  horizontal:
                                      DimensionsCustom.calculateWidth(4)),
                              decoration: BoxDecoration(
                                  color: Colors.blue.shade500,
                                  borderRadius: BorderRadius.circular(
                                      DimensionsCustom.calculateWidth(8))),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.account_circle_outlined,
                                    size: DimensionsCustom.calculateWidth(6),
                                    color: Colors.white,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            DimensionsCustom.calculateWidth(2)),
                                    child: Text(
                                      data['full_name'],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              DimensionsCustom.calculateWidth(
                                                  4.5)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: snapshot.data!.docs
                            .where((element) =>
                                element['full_name'] != value.getUserName)
                            .length,
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      )),
    );
  }
}
