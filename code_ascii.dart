import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 65; 
  int _value = 0; 
  bool _locked = false; 
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _char => String.fromCharCode(_counter);

  
  bool get _isVowel => 'AEIOUaeiou'.contains(_char);

  
  Color get _charColor {
    if (_counter >= 65 && _counter <= 90) return Colors.cyan;
    if (_counter >= 97 && _counter <= 122) return Colors.green;
    return Colors.orange;
  }

  
  Color get _valueColor => _value >= 0 ? Colors.green : Colors.red;

  void _alert(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  void _changeCounter(int delta) {
    final n = _counter + delta;
    if (n < 65 || n > 122) {
      _alert('Limite atteinte : le code ASCII doit rester entre 65 et 122.');
      return;
    }
    setState(() => _counter = n);
    if (n == 65 || n == 122) {
      _alert('Limite atteinte : $n');
    }
  }

  void _changeValue(int delta) {
    final n = _value + delta;
    if (n < -10 || n > 10) return;
    setState(() {
      _value = n;
      if (n == 10 || n == -10) _locked = true; 
    });
    if (_locked) {
      _alert('Limite atteinte : boutons désactivés pendant 2 secondes.');
      _timer?.cancel();
      _timer = Timer(const Duration(seconds: 2), () {
        if (mounted) setState(() => _locked = false);
      });
    }
  }

 
  Widget _squareButton(IconData icon, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple.shade50,
        foregroundColor: Colors.deepPurple.shade900,
        elevation: 4,
        minimumSize: const Size(64, 64),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Icon(icon, size: 32),
    );
  }

 
  Widget _pillButton(IconData icon, VoidCallback? onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(110, 54),
        shape: const StadiumBorder(),
        elevation: 3,
      ),
      child: Icon(icon, size: 36, color: Colors.deepPurple),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF7FF),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade50,
       
        leading: const Icon(Icons.keyboard, size: 40),
        title: const Text('Aya Mejdoub '), 
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),

       
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             
              _squareButton(Icons.abc, () => _changeCounter(-1)),
              const SizedBox(width: 16),
              Text(
                "$_char ('$_counter')",
                style: TextStyle(
                  fontSize: 52,
                  color: _charColor,
                  fontWeight: _isVowel ? FontWeight.bold : FontWeight.normal,
                  decoration:
                      _isVowel ? TextDecoration.underline : TextDecoration.none,
                  decorationColor: _charColor,
                ),
              ),
              const SizedBox(width: 16),
             
              _squareButton(Icons.sort_by_alpha, () => _changeCounter(1)),
            ],
          ),

          const SizedBox(height: 110),

        
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             
              _pillButton(
                Icons.add,
                (_locked || _value >= 10) ? null : () => _changeValue(1),
              ),
              const SizedBox(width: 16),
              Text(
                '$_value',
                style: TextStyle(fontSize: 52, color: _valueColor),
              ),
              const SizedBox(width: 16),
              _pillButton(
                Icons.remove,
                (_locked || _value <= -10) ? null : () => _changeValue(-1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}