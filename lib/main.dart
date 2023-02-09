import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:pharma_trax_scanner/Widgets/about_pharma.dart';
import 'package:pharma_trax_scanner/providers/auth_provider.dart';
import 'package:pharma_trax_scanner/screens/check_digit_page.dart';
import 'package:pharma_trax_scanner/screens/home_screen.dart';
import 'package:pharma_trax_scanner/Widgets/line_level_hardware.dart';
import 'package:pharma_trax_scanner/Widgets/how_it_works.dart';
import 'package:pharma_trax_scanner/Widgets/line_equipment.dart';
import 'package:pharma_trax_scanner/Widgets/custom_page_route.dart';
import 'package:pharma_trax_scanner/screens/scan_history.dart';
import 'package:pharma_trax_scanner/screens/signinpage.dart';
import 'package:pharma_trax_scanner/screens/update_database.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SharedPreferences pref = await SharedPreferences.getInstance();
  bool? checkData = pref.getBool('isLogin');
  runApp(
    MyApp(
      isLoginOrNMot: checkData,
    ),
  );
}

class MyApp extends StatelessWidget {
  bool? isLoginOrNMot;
  MyApp({Key? key, this.isLoginOrNMot}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
      ],
      child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Pharma Trax Scanner',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          // home: Signinpage.isAuth ? const HomePage(): const Signinpage(),
          // home: const HomePage(),
          home: isLoginOrNMot == true ? HomePage() : Signinpage(),
          onGenerateRoute: (route) => onGenerateRoute(route),
          //this is routes

          routes: {
            '/signin_page': (ctx) => const Signinpage(),
            //  '/home_screen': (ctx) => const HomePage(),
            //   '/scan_history': (ctx) => const ScanHistory(),
            //   '/update_database': (ctx) => const UpdateDatabase(),
            //   '/line_level_hardware': (ctx) => const LineLevelHardware(),
            //   '/line_equipment': (ctx) => const Line_equipment(),
            //   '/how_it_works': (ctx) => const How_it_works(),
            //   '/About_pharma': (context) => About_pharma()
          }),
    );
  }

  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/scan_history':
        return CustomPageRoute(child: ScanHistory(), settings: settings);
      case '/check_digit':
        return CustomPageRoute(child: CheckDigitPage(), settings: settings);
      case '/update_database':
        return CustomPageRoute(child: UpdateDatabase(), settings: settings);
      case '/line_level_hardware':
        return CustomPageRoute(child: LineLevelHardware(), settings: settings);
      case '/line_equipment':
        return CustomPageRoute(child: Line_equipment(), settings: settings);
      case '/how_it_works':
        return CustomPageRoute(child: How_it_works(), settings: settings);
      case '/about_pharma':
        return CustomPageRoute(child: About_pharma(), settings: settings);
      case '/home_screen':
      default:
        return CustomPageRoute(child: HomePage(), settings: settings);
    }
  }
}


// class CheckUser extends StatelessWidget {
//    CheckUser({super.key});
// SharedPreferences? prefs;
//   @override
//   Widget build(BuildContext context) {


//    bool logindata =  prefs!.getBool('isLogin') ;
 
//     //  AuthProvider provider = Provider.of<AuthProvider>(context);

//     return provider.isLoginorNot == false ? Signinpage():HomePage();
//   }
// }

