import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/clients/client_list_screen.dart';

void main() {
  runApp(const ProviderScope(child: KleenApp()));
}

class KleenApp extends StatelessWidget {
  const KleenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kleen',
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const ClientListScreen(),
    );
  }
}