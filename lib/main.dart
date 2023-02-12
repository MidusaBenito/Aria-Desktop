import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'splash_page.dart';
import 'utils.dart';
import 'login_page.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:window_manager/window_manager.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setTitle('Ariaquickpay');
    await windowManager.setTitleBarStyle(TitleBarStyle.normal);
    await windowManager.setBackgroundColor(Colors.transparent);
    await windowManager.setSize(const Size(855, 645));
    await windowManager.setMinimumSize(const Size(855, 645));
    await windowManager.center();
    await windowManager.show();
    await windowManager.setSkipTaskbar(false);
  });
  Stripe.publishableKey =
      "pk_live_51KhALyCldFfAXs7mYAyFcVHpAAx1vx5SA9UNazLXUR4CXgxzKWtfXsxsnGPqqN4TsswTQz4Y7Byjt7Eftlaicwat00Pt21ygLq";
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await UserSimplePreferences.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: myAnimatedScreen(),
    );
  }
}
