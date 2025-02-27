import 'package:YogaAsana/main_screen.dart';
import 'package:YogaAsana/util/user.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

import 'Auth/login.dart';
import 'Class/repository/classroom_repository.dart';
import 'Class/stores/asanas_store.dart';
import 'Class/stores/classrooms_store.dart';
import 'Class/utils/log.dart';

// List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Log.init();

  // String email = prefs.getString('email');
  // String uid = prefs.getString('uid');
  // String displayName = prefs.getString('displayName');
  // String photoUrl = prefs.getString('photoUrl');

  // User user = User();
  // user.setUser({
  //   'email': email,
  //   'displayName': displayName,
  //   'uid': uid,
  //   'photoUrl': photoUrl,
  // });

  // try {
  //   cameras = await availableCameras();
  // } on CameraException catch (e) {
  //   print('Error: $e.code\nError Message: $e.message');
  // }
  runApp(MyApp(
    sharedPreferences: prefs,
          appVersion: packageInfo.version,
  ));

  // runApp(
  //   email != null && uid != null
  //       ? MyApp(
  //           email: user.email,
  //           uid: user.uid,
  //           displayName: user.displayName,
  //           photoUrl: user.photoUrl,
  //           sharedPreferences: prefs,
  //           appVersion: packageInfo.version,
  //           // cameras: cameras,
  //         )
  //       : MyApp(
          // sharedPreferences: prefs,
          // appVersion: packageInfo.version,
  //           // cameras: cameras,
  //         ),
  // );
}

const kClassroomKeyValueRepositoryKeyName = 'classrooms';

class MyApp extends StatelessWidget {
  // final String email;
  // final String uid;
  // final String displayName;
  // final String photoUrl;
  // final List<CameraDescription> cameras;
  final SharedPreferences sharedPreferences;
  final String appVersion;

  const MyApp({
    // this.email,
    // this.uid,
    // this.displayName,
    // this.photoUrl,
    // this.cameras,
    this.sharedPreferences,
    this.appVersion,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AsanasStore>(
          create: (_) => AsanasStore()..init(),
          lazy: false,
        ),
        Provider<ClassroomsStore>(
          create: (_) {
            final repository = ClassroomKeyValueRepository(
                kClassroomKeyValueRepositoryKeyName, sharedPreferences);

            return ClassroomsStore(repository)..init();
          },
          dispose: (_, store) => store.dispose(),
          lazy: false,
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'YogaAsana',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: FirstScreen(),
        // initialRoute: (email != null && uid != null) ? '/' : '/login',
        // routes: <String, WidgetBuilder>{
          // '/': (BuildContext context) => FirstScreen(),
          // '/': (BuildContext context) => MainScreen(
          //       email: email,
          //       uid: uid,
          //       displayName: displayName,
          //       photoUrl: photoUrl,
          //       cameras: cameras,
          //     ),
          // '/login': (BuildContext context) => Login(
          //       cameras: cameras,
          //     ),
          // 'register': (BuildContext context) => Register(),
          // 'profile': (BuildContext context) => Profile(
          //       email: email,
          //       uid: uid,
          //       displayName: displayName,
          //       photoUrl: photoUrl,
          //     ),
        // },
      ),
    );
  }
}


class FirstScreen extends StatefulWidget {
  @override
  FirstScreenState createState() => new FirstScreenState();
}

class FirstScreenState extends State<FirstScreen>
    with AfterLayoutMixin<FirstScreen> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new Splash()));
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new IntroScreen()));
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Text(''),
      ),
    );
  }
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 3,
      navigateAfterSeconds: MainScreen(),
      title: new Text(
        'YogaAsana',
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      image: new Image.asset('assets/images/1.png'),
      gradientBackground: new LinearGradient(
          colors: [Colors.red, Colors.yellow],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 100.0,
      loaderColor: Colors.red,
    );
  }
}

class IntroScreen extends StatefulWidget {
  @override
  IntroScreenState createState() => new IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
          title: "YogaAsana",
          description:
              "Welcome to YogaAsana app. YogaAsana app help improves mental and physical health...",
          pathImage: "assets/images/1.png",
          colorBegin: Colors.red,
          colorEnd: Colors.yellow,
          directionColorBegin: Alignment.topRight,
          directionColorEnd: Alignment.bottomLeft
          // backgroundColor: Color(0xfff5a623),
          ),
    );
    slides.add(
      new Slide(
        title: "Meditation",
        description:
            "Live happier and healthier by learning the fundamentals of meditation and mindfulness.",
        pathImage: "assets/images/9.png",
        colorBegin: Colors.red,
        colorEnd: Colors.yellow,
        directionColorBegin: Alignment.topRight,
        directionColorEnd: Alignment.bottomLeft
      ),
    );
    slides.add(
      new Slide(
        title: "Yoga Classes",
        description:
            "Yoga classes help in achieving daily yoga goals. You can create your own yoga classes.",
        pathImage: "assets/images/3.png",
        colorBegin: Colors.red,
        colorEnd: Colors.yellow,
        directionColorBegin: Alignment.topRight,
        directionColorEnd: Alignment.bottomLeft
      ),
    );
  }

  void onDonePress() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Splash()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      slides: this.slides,
      onTabChangeCompleted: this.onDonePress,
      onDonePress: this.onDonePress,
    );
  }
}
