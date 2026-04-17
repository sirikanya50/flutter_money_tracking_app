import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class MoneySummaryHeader extends StatelessWidget {
  final SupabaseService _service = SupabaseService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, double>>(
      stream: _service.getSummaryStream(),
      builder: (context, snapshot) {
        double balance = snapshot.data?['balance'] ?? 0.0;
        double totalIn = snapshot.data?['totalIn'] ?? 0.0;
        double totalOut = snapshot.data?['totalOut'] ?? 0.0;

        return Container(
          child: Column(
            children: [
              Text('ยอดเงินคงเหลือ'),
              Text(
                '${balance.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('ยอดเงินเข้ารวม: ${totalIn.toStringAsFixed(2)}'),
                  Text('ยอดเงินออกรวม: ${totalOut.toStringAsFixed(2)}'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}