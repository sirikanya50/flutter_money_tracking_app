import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../services/supabase_service.dart';

class MoneyBalanceUI extends StatefulWidget {
  const MoneyBalanceUI({super.key});

  @override
  State<MoneyBalanceUI> createState() => _MoneyBalanceUIState();
}

class _MoneyBalanceUIState extends State<MoneyBalanceUI> {
  // สร้าง Stream เพื่อคอยดึงข้อมูลจาก Supabase แบบ Real-time
  final _transactionStream = Supabase.instance.client
      .from('money_records')
      .stream(primaryKey: ['id'])
      .order('created_at'); // เรียงลำดับข้อมูล (เดี๋ยวเรามา reverse ใน list)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _transactionStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data ?? [];
          final reversedData = data.reversed.toList();

          // คำนวณยอดเงิน
          double totalIn = 0;
          double totalOut = 0;
          for (var item in data) {
            if (item['money_type'] == 'IN') {
              totalIn += item['money_amount'];
            } else {
              totalOut += item['money_amount'];
            }
          }
          double balance = totalIn - totalOut;

          return Column(
            children: [
              // 1. Header ส่วนสรุปยอด (ส่งค่าที่คำนวณได้เข้าไป)
              _buildHeader(balance, totalIn, totalOut),

              const SizedBox(height: 20),
              Text(
                'เงินเข้า/เงินออก',
                style: GoogleFonts.kanit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // 2. ส่วนรายการ (ListView)
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: reversedData.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final item = reversedData[index];
                    bool isIncome = item['money_type'] == 'IN';

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isIncome ? Colors.green : Colors.red,
                        child: Icon(
                          isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        item['note_title'],
                        style: GoogleFonts.kanit(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        DateFormat(
                          'd MMMM yyyy',
                        ).format(DateTime.parse(item['created_at'])),
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: Text(
                        NumberFormat('#,###.00').format(item['money_amount']),
                        style: GoogleFonts.kanit(
                          color: isIncome ? Colors.green : Colors.red,
                          fontSize: 18,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Header ที่รับค่า dynamic
  Widget _buildHeader(double balance, double totalIn, double totalOut) {
    final fmt = NumberFormat('#,###.00');
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, bottom: 30, left: 20, right: 20),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 253, 173, 222), // สีพื้นหลังของ Header
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
                  SupabaseService.userProfilePath, // เรียกใช้ Path จาก Service
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  'ยอดเงินคงเหลือ',
                  style: GoogleFonts.kanit(color: Colors.white),
                ),
                Text(
                  fmt.format(balance),
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
                    _summaryItem('ยอดเงินเข้ารวม', fmt.format(totalIn)),
                    _summaryItem('ยอดเงินออกแบบรวม', fmt.format(totalOut)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}