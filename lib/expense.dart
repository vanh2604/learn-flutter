import 'package:intl/intl.dart';

class Expense {
  final int id;
  final double amount;
  final DateTime date;
  final String category;
  Expense(this.id, this.amount, this.date, this.category);
  static final columns = ['id', 'amount', 'date', 'category'];

  String get formattedDate {
    var formattedDate = DateFormat('yyyy-MM-dd').format(date);
    return formattedDate;
  }

  factory Expense.fromMap(Map<dynamic, dynamic> data) {
    return Expense(
      data['id'],
      data['amount'],
      DateTime.parse(data['date']),
      data['category'],
    );
  }
  Map<String, dynamic> toMap() => {
        "id": id,
        "amount": amount,
        "date": date.toString(),
        "category": category,
      };
}
