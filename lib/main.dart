import 'package:flutter/material.dart';
import 'ProductApp.dart';
import 'Database.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp(products: SQLiteDbProvider.db.getAllProducts()));
}
