import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Provider Counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

class Counter with ChangeNotifier {
  int value = 0;

  // Method to return the milestone message and background color
  Map<String, dynamic> getMilestone() {
    if (value <= 12) {
      return {"message": "You're a child!", "color": Colors.lightBlue.shade100};
    } else if (value <= 19) {
      return {"message": "Teenager time!", "color": Colors.lightGreen.shade100};
    } else if (value <= 30) {
      return {"message": "You're a young adult!", "color": Colors.yellow.shade100};
    } else if (value <= 50) {
      return {"message": "You're an adult now!", "color": Colors.orange.shade100};
    } else {
      return {"message": "Golden years!", "color": Colors.grey.shade300};
    }
  }

  void increment() {
    value += 1;
    notifyListeners();
  }

  void decrement() {
    if (value > 0) {
      value -= 1;
      notifyListeners();
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'),
      ),
      body: Consumer<Counter>(
        builder: (context, counter, child) {
          // Fetch the milestone data (message and color)
          final milestone = counter.getMilestone();
          return Container(
            color: milestone["color"],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    milestone["message"],
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    'I am ${counter.value} years old',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      var counter = context.read<Counter>();
                      counter.increment();
                    },
                    child: const Text("Increase Age"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      var counter = context.read<Counter>();
                      counter.decrement();
                    },
                    child: const Text("Decrease Age"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
