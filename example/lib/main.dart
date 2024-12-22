import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:pressable_flutter/pressable_flutter.dart';

void main() {
  runApp(const MaterialApp(home: Home()));
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Pressable(
          effect: PressEffect.withRipple(
            rippleEffect: RippleEffect.background(
              color: Colors.amberAccent,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPress: () => log('onPress'),
          onLongPress: () => log('onLongPress'),
          child: Container(
            height: 50,
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            child: const Center(
              child: Text(
                'Click Me',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
