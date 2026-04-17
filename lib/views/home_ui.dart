import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_money_tracking_app/views/money_balance_ui.dart';
import 'package:flutter_money_tracking_app/views/money_in_ui.dart';
import 'package:flutter_money_tracking_app/views/money_out_ui.dart';

class HomeUI extends StatefulWidget {
  const HomeUI({super.key});

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  // 1. สร้างตัวแปรเก็บลำดับหน้าจอที่เลือก (เริ่มที่หน้า Balance คือลำดับที่ 1)
  int _selectedIndex = 1;

  // 2. รายการหน้าจอที่จะสลับไปมา
  final List<Widget> _pages = [
    const MoneyInUI(),
    const MoneyBalanceUI(),
    const MoneyOutUI(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 3. แสดงหน้าจอตาม Index ที่เลือก
      body: _pages[_selectedIndex],

      // 4. แถบเมนูด้านล่าง
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 253, 173, 222), 
        currentIndex: _selectedIndex, // บอกว่าตอนนี้เลือกเมนูไหนอยู่
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // เปลี่ยนหน้าเมื่อกดไอคอน
          });
        },
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false, 
        showUnselectedLabels: false, 
        selectedItemColor: const Color(
          0xFF004D40,
        ), 
        unselectedItemColor: Colors.white.withOpacity(
          0.8,
        ), 
        iconSize: 30,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.download_outlined), // ไอคอนเงินเข้า
            activeIcon: Icon(Icons.download), // ไอคอนเงินเข้าแบบหนาเมื่อเลือก
            label: 'Money In',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined), 
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload_outlined), 
            activeIcon: Icon(Icons.upload), 
            label: 'Money Out',
          ),
        ],
      ),
    );
  }
}