// please_wait_screen.dart
import 'package:flutter/material.dart';

class PleaseWaitScreen extends StatelessWidget {
  const PleaseWaitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.hourglass_empty,
                size: 64,
                color: Colors.blueAccent,
              ),
              SizedBox(height: 20),
              Text(
                'Initializing…',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
