import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  ui.FragmentProgram? program;

  Ticker? ticker;

  double time = 0.0;

  @override
  void initState() {
    super.initState();
    ticker = createTicker((elapsed) {
      time = elapsed.inMilliseconds / 3000;
      setState(() {});
    })
      ..start();
  }

  @override
  void dispose() {
    ticker?.stop();
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    // for flutter <3.4 uncomment these lines
    // final data = await rootBundle.load("assets/fire.sprv");
    // program = await ui.FragmentProgram.compile(spirv: data.buffer);
    // line below is only for flutter 3.4
    program = await ui.FragmentProgram.fromAsset("seasimple.glsl");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // child: Container(
        //   transformAlignment: FractionalOffset.center,
        //   transform: Matrix4.rotationZ(pi),
        child: SizedBox(
          width: 256,
          height: 256,
          child: program == null
              ? null
              : ShaderMask(
                  child: Stack(
                    children: const [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          'SEA',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 96,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  shaderCallback: (rect) => program!.shader(
                    floatUniforms: Float32List.fromList(
                      [time, 256, 256],
                    ),
                  ),

                  // : CustomPaint(
                  //     painter: CustomPainting(
                  //       program!.shader(
                  //         floatUniforms: Float32List.fromList([time, 256, 256]),
                  //       ),
                  //     ),
                  // painter: CustomPainting(
                  //     LinearGradient(colors: [Colors.red, Colors.green])
                  //         .createShader(Offset.zero & Size(256, 256))),
                ),
        ),
      ),
      // ),
    );
  }
}

class CustomPainting extends CustomPainter {
  Shader shader;

  CustomPainting(this.shader);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
