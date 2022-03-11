import 'package:flutter/material.dart';
import 'ExpenseApp.dart';
import 'ExpenseListModel.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:scoped_model/scoped_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final expenses = ExpenseListModel();
  runApp(ScopedModel<ExpenseListModel>(
    model: expenses,
    child: const ExpenseApp(),
  ));
}
