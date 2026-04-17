class MoneyRecord {
  final int? id;
  final String noteTitle;
  final double moneyAmount;
  final String moneyType; // ค่าจะเป็น 'IN' หรือ 'OUT'
  final DateTime? createdAt;

  MoneyRecord({
    this.id,
    required this.noteTitle,
    required this.moneyAmount,
    required this.moneyType,
    this.createdAt,
  });

  // แปลงข้อมูลจาก Map (จาก Supabase) มาเป็น Object ใน Flutter
  factory MoneyRecord.fromJson(Map<String, dynamic> json) {
    return MoneyRecord(
      id: json['id'],
      noteTitle: json['note_title'],
      moneyAmount: (json['money_amount'] as num).toDouble(),
      moneyType: json['money_type'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  // แปลงจาก Object ใน Flutter ไปเป็น Map เพื่อส่งขึ้นไปบันทึกใน Supabase
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'note_title': noteTitle,
      'money_amount': moneyAmount,
      'money_type': moneyType,
    };
  }
}