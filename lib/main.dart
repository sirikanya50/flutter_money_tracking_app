import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_money_tracking_app/views/splash_screen_ui.dart'; 
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('th', null);

  // 1. เริ่มการเชื่อมต่อกับ Supabase
  await Supabase.initialize(
    url: 'https://ssuvodwaerkoahcqnxvz.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNzdXZvZHdhZXJrb2FoY3FueHZ6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY0MTMwNTYsImV4cCI6MjA5MTk4OTA1Nn0._NfDXAjRC3OsRAWmJZS0Rv8R1N-f7_WRFab8EueRIeM',
  );
  runApp(const MaterialApp(
    home: SplashScreenUI(),
    debugShowCheckedModeBanner: false,
  ));
}

