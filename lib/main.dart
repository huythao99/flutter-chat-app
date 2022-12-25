import 'package:chat_app/src/features/auth/login/login_screen.dart';
import 'package:chat_app/src/features/auth/signup/signup_screen.dart';
import 'package:chat_app/src/features/chat/chat_screen.dart';
import 'package:chat_app/src/features/chat/models/chat_argument_model.dart';
import 'package:chat_app/src/features/error/error_page.dart';
import 'package:chat_app/src/features/home/home_screen.dart';
import 'package:chat_app/src/provider/user_provider/user_model.dart';
import 'package:chat_app/src/utils/string_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/src/constants/routes_constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => UserModel(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  bool authenticated = false;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        setState(() {
          authenticated = false;
        });
      } else {
        setState(() {
          authenticated = true;
        });
        Provider.of<UserModel>(context, listen: false).updateUser(user);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        late Widget page;
        if (authenticated) {
          switch (settings.name) {
            case RouteConstant.routeHome:
              page = const HomeScreen();
              break;
            case RouteConstant.routeChat:
              final args = settings.arguments as ChatArgumentModel;
              String idRoom = StringHelper.sortID(
                  Provider.of<UserModel>(context, listen: false).getUserName ??
                      '',
                  args.idReceiver);

              page = ChatScreen(
                idRoom: idRoom,
                friendName: args.idReceiver,
              );
              break;
            default:
              page = const ErrorPage();
              break;
          }
        } else {
          switch (settings.name) {
            case RouteConstant.routeLogin:
              page = const LoginScreen();
              break;
            case RouteConstant.routeSignup:
              page = const SignupScreen();
              break;

            default:
              page = const ErrorPage();
              break;
          }
        }

        return MaterialPageRoute<dynamic>(
          builder: (context) {
            return page;
          },
          settings: settings,
        );
      },
      debugShowCheckedModeBanner: false,
      home: !authenticated ? const LoginScreen() : const HomeScreen(),
    );
  }
}
