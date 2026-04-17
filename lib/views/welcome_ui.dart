import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_money_tracking_app/views/home_ui.dart'; 

class WelcomeUI extends StatefulWidget {
  const WelcomeUI({super.key});

  @override
  State<WelcomeUI> createState() => _WelcomeUIState();
}

class _WelcomeUIState extends State<WelcomeUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 253, 173, 222), // สีชมพูอ่อน
              Colors.white, 
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Image.asset(
                  'assets/images/man_icon.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // ส่วนเนื้อหาด้านล่าง
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'บันทึก\nรายรับรายจ่าย',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.kanit(
                      fontSize: 32,
                      color: Colors.red[300], // สีเทาเข้ม
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // ปุ่ม "เริ่มใช้งานแอปพลิเคชัน" (Custom Button)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeUI(),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          color: Colors.red[300], // สีแดงเข้ม
                          borderRadius: BorderRadius.circular(
                            30,
                          ), 
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5), // เงาด้านล่างปุ่ม
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'เริ่มใช้งานแอปพลิเคชัน',
                            style: GoogleFonts.kanit(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}