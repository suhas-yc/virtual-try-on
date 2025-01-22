import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:virtual_try_on/check_size_page.dart';
import 'package:virtual_try_on/virtual_try_on_page.dart';

List<CameraDescription>? cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();
  runApp(const CameraApp());
}

class CameraApp extends StatefulWidget {
  const CameraApp({Key? key}) : super(key: key);

  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  CameraController? controller;
  late Future<void> initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    controller = CameraController(
      cameras![0],
      ResolutionPreset.max,
    );
    controller!.setFlashMode(FlashMode.off);
    initializeControllerFuture = controller!.initialize();
    initializeControllerFuture.then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // primarySwatch: Colors.grey,
        // fontFamily: 'Poppins',
        fontFamily: 'Inter',
        primaryColor: const Color(0xFF001E1D),
        canvasColor: const Color(0xFFE9E4E5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF001E1D),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xFF001E1D),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor:
                WidgetStateProperty.all<Color>(const Color(0xFF001E1D)),
            fixedSize: WidgetStateProperty.all<Size>(const Size(200, 70)),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50))),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
            side: WidgetStateProperty.all<BorderSide>(const BorderSide(
              width: 1,
              // color: Color(0xFF001E1D),
              color: Colors.transparent,
            )),
            foregroundColor:
                WidgetStateProperty.all<Color>(const Color(0xFF001E1D)),
            fixedSize: WidgetStateProperty.all<Size>(const Size(200, 70)),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFFD96566),
        ),
      ),
      // home: MyHomePage(title: 'Virtual try on', controller: controller),
      initialRoute: '/home',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/home': (context) => MyHomePage(
            title: 'Virtual try on',
            controller: controller,
            initializeControllerFuture: initializeControllerFuture),
        // When navigating to the "/second" route, build the SecondScreen widget.
        // '/second': (context) => const SecondScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
    required this.controller,
    required this.initializeControllerFuture,
  }) : super(key: key);

  final String title;
  final CameraController? controller;
  final Future<void> initializeControllerFuture;

  @override
  State<MyHomePage> createState() =>
      // ignore: no_logic_in_create_state
      _MyHomePageState(controller, initializeControllerFuture);
}

class _MyHomePageState extends State<MyHomePage> {
  CameraController? controller;
  Future<void> initializeControllerFuture;
  _MyHomePageState(this.controller, this.initializeControllerFuture);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                          text: TextSpan(
                        style: const TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          const TextSpan(text: 'A new and improved '),
                          TextSpan(
                            text: 'shopping ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          const TextSpan(text: 'experience.'),
                        ],
                      ))
                      // child: Text(
                      //   'A new and improved shopping experience.',
                      //   style: TextStyle(
                      //     fontSize: 60,
                      //     fontWeight: FontWeight.w400,
                      //   ),
                      // ),
                      ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ElevatedButton(
                    // style: ElevatedButton.styleFrom(
                    //   minimumSize: Size.fromHeight(40),
                    // ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CheckSizePage(
                                  controller: controller,
                                  initializeControllerFuture:
                                      initializeControllerFuture,
                                )),
                      );
                    },
                    child: const Text("Check size"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        // primary: Theme.of(context).primaryColor,
                        ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VirtualTryOnPage(
                                  controller: controller,
                                  initializeControllerFuture:
                                      initializeControllerFuture,
                                )),
                      );
                    },
                    child: const Text("Shop now"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
