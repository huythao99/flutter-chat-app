import 'package:chat_app/src/common_widgets/options/option_widget.dart';
import 'package:chat_app/src/constants/dimensions_custom.dart';
import 'package:chat_app/src/constants/routes_constant.dart';
import 'package:chat_app/src/provider/user_provider/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 0,
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: DimensionsCustom.calculateHeight(2)),
                  child: Consumer<UserModel>(
                    builder: (context, value, child) {
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.account_circle,
                              size: DimensionsCustom.calculateWidth(24),
                              color: Colors.blue.shade300,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      DimensionsCustom.calculateHeight(1)),
                              child: Text(
                                value.getUserName ?? '',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize:
                                        DimensionsCustom.calculateWidth(5.5),
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ]);
                    },
                  ),
                ),
                // dark mode
                OptionWidget(
                    onPress: () {},
                    title: "Ch??? ????? t???i",
                    optionIcon: Icons.dark_mode_outlined,
                    optionColor: Colors.black87),

                // online
                OptionWidget(
                    onPress: () {},
                    title: "Tr???ng th??i ho???t ?????ng",
                    optionIcon: Icons.bubble_chart_outlined,
                    optionColor: Colors.lightGreen),
                OptionWidget(
                    onPress: () {},
                    title: "Quy???n ri??ng t?? v?? an to??n",
                    optionIcon: Icons.home_outlined,
                    optionColor: Colors.lightGreen),
                OptionWidget(
                    onPress: () {},
                    title: "Avatar",
                    optionIcon: Icons.image_rounded,
                    optionColor: Colors.purple),
                OptionWidget(
                    onPress: () {},
                    title: "B??o c??o s??? c??? k??? thu???t",
                    optionIcon: Icons.warning_rounded,
                    optionColor: Colors.orange.shade400),
                OptionWidget(
                    onPress: () {},
                    title: "Tr??? gi??p",
                    optionIcon: Icons.info_outline,
                    optionColor: Colors.blue.shade300),
                OptionWidget(
                    onPress: () {},
                    title: "Chu??ng th??ng b??o",
                    optionIcon: Icons.notifications_rounded,
                    optionColor: Colors.purple),
                OptionWidget(
                    onPress: () {},
                    title: "C???p nh???t ???ng d???ng",
                    optionIcon: Icons.download_rounded,
                    optionColor: Colors.blue.shade300),
                // logout
                OptionWidget(
                    onPress: () async {
                      await FirebaseAuth.instance.signOut();
                      if (context.mounted) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            RouteConstant.routeLogin, (route) => false);
                      }
                    },
                    title: "????ng xu???t",
                    optionIcon: Icons.logout_outlined,
                    optionColor: Colors.grey),
              ],
            ),
          ),
        ));
  }
}
