import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'book_list_page.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://rtvckcylsjtmyvjphnqr.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ0dmNrY3lsc2p0bXl2anBobnFyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE3MjY4NzYsImV4cCI6MjA0NzMwMjg3Nn0.k1yYNqZAMQD4xGSoalVahlPE-OdBug_eWH9T6hWxcUg',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Digital Library",
      home: BookListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
