import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Native Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Check your battery level'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _kotText = 'Tap the button';
  String _batteryLevel = '!';
  static const platform = MethodChannel('main_channel');

// main method to get data from kotlin side
  Future<void> _getNativeMessage() async {
    String nativeMessage;
    String nativeBatLevel;
    try {
      nativeMessage = await platform.invokeMethod('dataFlow');
      final batResult = await platform.invokeMethod<int>('btLevel');
      nativeBatLevel = '$batResult %';
    } on PlatformException catch (e) {
      nativeMessage = 'Failed to get native data: ${e.message}';
      nativeBatLevel = 'Failed to get battery data: ${e.message}';
    }

    setState(() {
      _kotText = nativeMessage;
      _batteryLevel = nativeBatLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          textAlign: TextAlign.center,
        ),
      ),
      body: Container(
          width: double.infinity,
          color: Colors.green,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_kotText),
              Card(
                margin: const EdgeInsets.all(15.0),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    _batteryLevel,
                    style: const TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: _getNativeMessage,
        tooltip: 'Get data',
        child: const Icon(Icons.battery_alert_sharp),
      ),
    );
  }
}
