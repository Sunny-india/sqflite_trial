import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqlite_trial/all_customers.dart';
import 'package:sqlite_trial/sql_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SQLHelper.getDatabase();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AllCustomers(),
    ),
  );
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
            middle: Text(
          'Hello Again',
          style: TextStyle(fontSize: 30),
        )),
        child: SafeArea(
          child: Container(
            height: 400,
            width: 400,
            color: CupertinoColors.activeOrange,
          ),
        ));
  }
}
