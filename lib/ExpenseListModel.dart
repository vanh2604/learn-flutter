import 'dart:collection';
// ignore: import_of_legacy_library_into_null_safe
import 'package:scoped_model/scoped_model.dart';
import 'expense.dart';
import 'expenseDatabase.dart';

class ExpenseListModel extends Model {
  final List<Expense> _items = [];
  UnmodifiableListView<Expense> get items => UnmodifiableListView(_items);
  ExpenseListModel() {
    load();
  }
  double get totalExpense {
    double total = 0.0;
    for (Expense expense in _items) {
      total += expense.amount;
    }
    return total;
  }

  void load() {
    Future<List<Expense>> list = SQLiteDbProvider.db.getAllExpenses();
    list.then((dbItems) {
      for (Expense expense in dbItems) {
        _items.add(expense);
      }
      notifyListeners();
    });
  }

  Expense byId(int id) {
    return _items.firstWhere((Expense expense) {
      return expense.id == id;
    });
  }

  int getExpenseLength() {
    return _items.length;
  }

  void add(Expense expense) {
    SQLiteDbProvider.db.insert(expense).then((value) {
      _items.add(expense);
      notifyListeners();
    });
  }

  void update(Expense expense) {
    bool found = false;
    for (var i = 0; i < _items.length; i++) {
      if (_items[i].id == expense.id) {
        _items[i] = expense;
        found = true;
        SQLiteDbProvider.db.update(expense);
        break;
      }
    }
    if (found) {
      notifyListeners();
    }
  }

  void delete(Expense expense) {
    bool found = false;
    for (var i = 0; i < _items.length; i++) {
      if (_items[i].id == expense.id) {
        SQLiteDbProvider.db.delete(expense.id);
        _items.removeAt(i);
        found = true;
        break;
      }
    }
    if (found) {
      notifyListeners();
    }
  }
}
