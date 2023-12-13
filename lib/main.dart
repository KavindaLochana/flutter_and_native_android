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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Native Data Test'),
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
  String _kotText = 'Nothing yet';
  static const platform = MethodChannel('main_channel');

  Future<void> _getNativeMessage() async {
    String nativeMessage;
    try {
      nativeMessage = await platform.invokeMethod('dataFlow');
    } on PlatformException catch (e) {
      nativeMessage = 'Failed to get native data: ${e.message}';
    }

    setState(() {
      _kotText = nativeMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(child: Text(_kotText)),
      floatingActionButton: FloatingActionButton(
        onPressed: _getNativeMessage,
        tooltip: 'Get data',
        child: const Icon(Icons.get_app),
      ),
    );
  }
}
