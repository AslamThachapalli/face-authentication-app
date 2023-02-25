import 'package:face_auth/authenticate_face/authenticate_face_view.dart';
import 'package:face_auth/register_face/register_face_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Face Authentication App',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xff345ea8),
        ),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: Color(0xff3b8ac3),
        ),
        scaffoldBackgroundColor: Color(0xffeedbcb),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: Color(0xff345ea8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              Color(0xff4ab4de),
            ),
          ),
        ),
      ),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Face Authentication'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomCard("Register Face", RegisterFaceView()),
                CustomCard("Redeem Token", AuthenticateFaceView()),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String _label;
  final Widget _viewPage;

  const CustomCard(this._label, this._viewPage);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.secondary,
        title: Text(
          _label,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => _viewPage));
        },
      ),
    );
  }
}
