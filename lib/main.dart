import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: CardFormWidget(),
  ));
}

class CardFormWidget extends StatefulWidget {
  @override
  _CardFormWidgetState createState() => _CardFormWidgetState();
}

class _CardFormWidgetState extends State<CardFormWidget>
    with SingleTickerProviderStateMixin {
  String description = '';
  double cost = 0.0;
  String currency = 'EUR';
  String category = 'Food & Drink';
  String location = 'Thailand';
  DateTime date = DateTime.now();
  String notes = '';

  bool isFormVisible = false;

  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  List<String> currencyOptions = ['EUR', 'USD', 'THB'];
  List<String> categoryOptions = ['Food & Drink', 'Transport'];
  List<String> locationOptions = ['Thailand', 'Cambodia'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showForm() {
    setState(() {
      isFormVisible = true;
    });
    _animationController.forward();
  }

  void _hideForm() {
    _animationController.reverse().then((value) {
      setState(() {
        isFormVisible = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isFormVisible ? null : _showForm,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 48.0,
          color: Colors.blue,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Visibility(
              visible: isFormVisible,
              child: SlideTransition(
                position: _offsetAnimation,
                child: Card(
                  elevation: 4.0,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: _hideForm,
                            ),
                          ],
                        ),
                        Text(
                          'Add Expense',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Description',
                          ),
                          onChanged: (value) {
                            setState(() {
                              description = value;
                            });
                          },
                        ),
                        SizedBox(height: 16.0),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Cost',
                          ),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          onChanged: (value) {
                            setState(() {
                              cost = double.tryParse(value) ?? 0.0;
                            });
                          },
                        ),
                        SizedBox(height: 16.0),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: 'Currency',
                                ),
                                value: currency,
                                items: currencyOptions.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    currency = value!;
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 16.0),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: 'Category',
                                ),
                                value: category,
                                items: categoryOptions.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    category = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: 'Location',
                                ),
                                value: location,
                                items: locationOptions.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    location = value!;
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 16.0),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  final DateTime? selectedDate =
                                      await showDatePicker(
                                    context: context,
                                    initialDate: date,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );
                                  if (selectedDate != null) {
                                    setState(() {
                                      date = selectedDate;
                                    });
                                  }
                                },
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    labelText: 'Date',
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.calendar_today),
                                      SizedBox(width: 8.0),
                                      Text(date.toString()),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Notes',
                          ),
                          maxLines: 3,
                          onChanged: (value) {
                            setState(() {
                              notes = value;
                            });
                          },
                        ),
                        SizedBox(height: 16.0),
                        ElevatedButton(
                          child: Text('Submit'),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Card Information'),
                                  content: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Description: $description'),
                                      Text('Cost: $cost'),
                                      Text('Currency: $currency'),
                                      Text('Category: $category'),
                                      Text('Location: $location'),
                                      Text('Date: ${date.toLocal()}'),
                                      Text('Notes: $notes'),
                                    ],
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
