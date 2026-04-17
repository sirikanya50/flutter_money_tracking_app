import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../services/supabase_service.dart';
import '../models/money_record.dart';

class MoneyInUI extends StatefulWidget {
  const MoneyInUI({super.key});
  @override
  State<MoneyInUI> createState() => _MoneyInUIState();
}

class _MoneyInUIState extends State<MoneyInUI> {
  final SupabaseService _service = SupabaseService();
  final _detailController = TextEditingController();
  final _amountController = TextEditingController();

  void _onSave() async {
    final amount = double.tryParse(_amountController.text);
    // Validate UI
    if (_detailController.text.isEmpty || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณากรอกข้อมูลให้ครบถ้วน'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await _service.insertTransaction(
      MoneyRecord(
        noteTitle: _detailController.text,
        moneyAmount: amount,
        moneyType: 'IN',
      ),
    );

    // แจ้งผลและเคลียร์ข้อมูล
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('บันทึกสำเร็จ')));
    _detailController.clear();
    _amountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(), // ส่วนหัวที่ดึงชื่อจาก Static และยอดจาก Stream
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  Text(
                    DateFormat(
                      'วันที่ d MMMM yyyy',
                      'th',
                    ).format(DateTime.now()),
                    style: GoogleFonts.kanit(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ), // แสดงวันเวลาปัจจุบัน
                  const SizedBox(height: 10),
                  Text(
                    'เงินเข้า',
                    style: GoogleFonts.kanit(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildInput("รายการเงินเข้า", "DETAIL", _detailController),
                  const SizedBox(height: 20),
                  _buildInput(
                    "จำนวนเงินเข้า",
                    "0.00",
                    _amountController,
                    isNum: true,
                  ),
                  const SizedBox(height: 40),
                  _buildSaveButton(
                    "บันทึกเงินเข้า",
                    _onSave,
                    Colors.lightGreenAccent,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return StreamBuilder<Map<String, double>>(
      stream: _service.getSummaryStream(),
      builder: (context, snapshot) {
        final data =
            snapshot.data ?? {'totalIn': 0.0, 'totalOut': 0.0, 'balance': 0.0};
        return Container(
          padding: const EdgeInsets.only(
            top: 50,
            bottom: 30,
            left: 20,
            right: 20,
          ),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 253, 173, 222),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    SupabaseService.userName,
                    style: GoogleFonts.kanit(color: Colors.white, fontSize: 22),
                  ),
                  const Spacer(),
                  CircleAvatar(
                    backgroundImage: AssetImage(
                      SupabaseService
                          .userProfilePath, // เรียกใช้ Path จาก Service
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              _buildBalanceCard(data), // การ์ดแสดงยอดเงินแบบซ้อนกัน
            ],
          ),
        );
      },
    );
  }

  Widget _buildBalanceCard(Map<String, double> data) {
    final fmt = NumberFormat("#,###.00");
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text('ยอดเงินคงเหลือ', style: GoogleFonts.kanit(color: Colors.white)),
          Text(
            fmt.format(data['balance']),
            style: GoogleFonts.kanit(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _summaryText('ยอดเงินเข้ารวม', fmt.format(data['totalIn'])),
              _summaryText('ยอดเงินออกแบบรวม', fmt.format(data['totalOut'])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryText(String label, String val) => Column(
        children: [
          Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 12)),
          Text(
            val,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );

  Widget _buildInput(
    String label,
    String hint,
    TextEditingController ctrl, {
    bool isNum = false,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: isNum ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black54),
        ),
      ),
    );
  }

  Widget _buildSaveButton(String text, VoidCallback press, Color color) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: press,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: Text(
          text,
          style: GoogleFonts.kanit(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
