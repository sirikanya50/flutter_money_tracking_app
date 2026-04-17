import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // อย่าลืมติดตั้ง package นี้ใน pubspec.yaml
import 'package:flutter_money_tracking_app/views/welcome_ui.dart';

class SplashScreenUI extends StatefulWidget {
  const SplashScreenUI({super.key});

  @override
  State<SplashScreenUI> createState() => _SplashScreenUIState();
}

class _SplashScreenUIState extends State<SplashScreenUI> {
  @override
  void initState() {
    super.initState();
    // หน่วงเวลา 3 วินาที แล้วเปลี่ยนไปหน้า WelcomeUI
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeUI()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // กำหนดสีพื้นหลังให้ตรงกับในแบบ (สีเขียวแกมฟ้า)
      backgroundColor: Colors.pink[100], // เปลี่ยนเป็นสีที่ต้องการ
      body: Stack(
        children: [
          // ส่วนจัดวางข้อความตรงกลางหน้าจอ
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Money Tracking',
                  style: GoogleFonts.kanit(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'รายรับรายจ่ายของฉัน',
                  style: GoogleFonts.kanit(
                    fontSize: 22,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // ส่วนจัดวางข้อความด้านล่างสุดของหน้าจอ
          Positioned(
            bottom: 40, // ห่างจากขอบล่าง 40 px
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  'Created by 6619410050',
                  style: GoogleFonts.kanit(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '- SAU -',
                  style: GoogleFonts.kanit(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
