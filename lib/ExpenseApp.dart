// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:scoped_model/scoped_model.dart';
import "ExpenseListModel.dart";
import 'expense.dart';

class ExpenseApp extends StatelessWidget {
  const ExpenseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Expense",
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: "Expense app"),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: ScopedModelDescendant<ExpenseListModel>(
          builder: (context, child, expenses) {
            return ListView.separated(
              itemCount: expenses.items == null ? 1 : expenses.items.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ListTile(
                      title: Text(
                    "Total expenses: " + expenses.totalExpense.toString(),
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ));
                } else {
                  index = index - 1;
                  return Dismissible(
                      key: Key(expenses.items[index].id.toString()),
                      onDismissed: (direction) {
                        expenses.delete(expenses.items[index]);
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("Item with id, " +
                                expenses.items[index].id.toString() +
                                " is dismissed")));
                      },
                      child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FormPage(
                                          id: expenses.items[index].id,
                                          expenses: expenses,
                                        )));
                          },
                          leading: const Icon(Icons.monetization_on),
                          trailing: const Icon(Icons.keyboard_arrow_right),
                          title: Text(
                            expenses.items[index].category +
                                ": " +
                                expenses.items[index].amount.toString() +
                                " \nspent on " +
                                expenses.items[index].formattedDate,
                            style: const TextStyle(
                                fontSize: 18, fontStyle: FontStyle.italic),
                          )));
                }
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            );
          },
        ),
        floatingActionButton: ScopedModelDescendant<ExpenseListModel>(
            builder: (context, child, expenses) {
          return FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ScopedModelDescendant<ExpenseListModel>(
                              builder: (context, child, expenses) {
                            return FormPage(
                              id: 0,
                              expenses: expenses,
                            );
                          })));
              // expenses.add(new Expense(
              // 2, 1000, DateTime.parse('2019-04-01 11:00:00'), 'Food')
              // print(expenses.items.length);
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          );
        }));
  }
}

class FormPage extends StatefulWidget {
  const FormPage({Key? key, required this.id, required this.expenses})
      : super(key: key);
  final int id;
  final ExpenseListModel expenses;

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  double _amount = 0.0;
  DateTime _date = DateTime.now();
  String _category = "";

  final dateController = TextEditingController();

  void _submit() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      if (widget.id == 0) {
        widget.expenses.add(Expense(
            widget.expenses.getExpenseLength() + 1, _amount, _date, _category));
      } else {
        widget.expenses.update(Expense(widget.id, _amount, _date, _category));
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Enter expense details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                style: const TextStyle(fontSize: 22),
                decoration: const InputDecoration(
                    icon: Icon(Icons.monetization_on),
                    labelText: 'Amount',
                    labelStyle: TextStyle(fontSize: 18)),
                validator: (val) {
                  Pattern pattern = r'^[1-9]\d*(\.\d+)?$';
                  RegExp regex = RegExp(pattern.toString());
                  if (!regex.hasMatch(val!)) {
                    return 'Enter a valid number';
                  } else {
                    return null;
                  }
                },
                initialValue: widget.id == 0
                    ? ''
                    : widget.expenses.byId(widget.id).amount.toString(),
                onSaved: (val) => _amount = double.parse(val!),
              ),
              TextFormField(
                style: const TextStyle(fontSize: 22),
                decoration: const InputDecoration(
                  icon: Icon(Icons.calendar_today),
                  hintText: 'Enter date',
                  labelText: 'Date',
                  labelStyle: TextStyle(fontSize: 18),
                ),
                // validator: (val) {
                //   Pattern pattern =
                //       r'^((?:19|20)\d\d)[- /.](0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])$';
                //   RegExp regex = RegExp(pattern.toString());
                //   if (!regex.hasMatch(val!)) {
                //     return 'Enter a valid date';
                //   } else {
                //     return null;
                //   }
                // },
                initialValue: widget.id == 0
                    ? ""
                    : widget.expenses.byId(widget.id).formattedDate,
                onSaved: (val) => _date = DateTime.parse(val!),
                // onTap: () async {
                //   FocusScope.of(context).requestFocus(FocusNode());

                //   final date = await showDatePicker(
                //       context: context,
                //       initialDate: DateTime.now(),
                //       firstDate: DateTime(1900),
                //       lastDate: DateTime(2100));

                //   dateController.text = DateFormat('yyyy-MM-dd').format(date!);
                // },
                keyboardType: TextInputType.datetime,
              ),
              TextFormField(
                style: const TextStyle(fontSize: 22),
                decoration: const InputDecoration(
                    icon: Icon(Icons.category),
                    labelText: 'Category',
                    labelStyle: TextStyle(fontSize: 18)),
                onSaved: (val) => _category = val!,
                initialValue: widget.id == 0
                    ? ''
                    : widget.expenses.byId(widget.id).category.toString(),
              ),
              RaisedButton(
                onPressed: _submit,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
