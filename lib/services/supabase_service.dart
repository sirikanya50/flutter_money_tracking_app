import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/money_record.dart';

class SupabaseService {
  final _client = Supabase.instance.client;

  // 1. ตัวแปรส่วนกลางสำหรับชื่อผู้ใช้ (เปลี่ยนที่นี่ที่เดียว เปลี่ยนทุกหน้า)
  static String userName = "Sirikanya Raksapol";
  static String userProfilePath = 'assets/images/man.png';

  // 2. ดึงข้อมูลรายการทั้งหมดแบบ Stream
  Stream<List<MoneyRecord>> getTransactionStream() {
    return _client
        .from('money_records')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .map((data) => data.map((json) => MoneyRecord.fromJson(json)).toList());
  }

  // 3. ฟังก์ชันคำนวณยอดเงินรวม (In, Out, Balance)
  Stream<Map<String, double>> getSummaryStream() {
    return getTransactionStream().map((records) {
      double totalIn = 0;
      double totalOut = 0;
      for (var record in records) {
        if (record.moneyType == 'IN')
          totalIn += record.moneyAmount;
        else
          totalOut += record.moneyAmount;
      }
      return {
        'totalIn': totalIn,
        'totalOut': totalOut,
        'balance': totalIn - totalOut,
      };
    });
  }

  Future<void> insertTransaction(MoneyRecord record) async {
    await _client.from('money_records').insert(record.toJson());
  }
}