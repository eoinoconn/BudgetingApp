import 'package:flutter/material.dart';
import 'setup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if setup has been performed
  bool isSetupComplete = await checkSetupComplete();

  runApp(MyApp(isSetupComplete: isSetupComplete));
}

class MyApp extends StatelessWidget {
  final bool isSetupComplete;
  const MyApp({Key? key, required this.isSetupComplete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: isSetupComplete ? const MainApp() : SetupPage(),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MainApp> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool isFormVisible = false;
  String description = '';
  double cost = 0.0;
  String selectedCurrency = 'EUR';
  String selectedCategory = 'Food & Drink';
  String selectedLocation = 'Thailand';
  DateTime selectedDate = DateTime.now();
  String notes = '';

  final List<String> currencyOptions = ['EUR', 'USD', 'THB'];
  final List<String> categoryOptions = ['Food & Drink', 'Transport'];
  final List<String> locationOptions = ['Thailand', 'Cambodia'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleFormVisibility() {
    setState(() {
      isFormVisible = !isFormVisible;
      if (isFormVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _submitForm() {
    if (cost < 0 || cost > 1000000000) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Invalid Cost'),
            content: const Text('Please enter a valid cost.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // Perform the desired action with the form data
      // For example, you can save the data to a database or send it to an API
      // Here, we simply print the form data
      print('Description: $description');
      print('Cost: $cost');
      print('Currency: $selectedCurrency');
      print('Category: $selectedCategory');
      print('Location: $selectedLocation');
      print('Date: $selectedDate');
      print('Notes: $notes');

      // display a green tick animation for 1 second
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
          content: Icon(Icons.check),
        ),
      );

      // Close the form
      _toggleFormVisibility();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense App'),
      ),
      body: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          height: isFormVisible ? MediaQuery.of(context).size.height * 0.8 : 0,
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  const Text(
                    'Add Expense',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Description'),
                    onChanged: (value) {
                      setState(() {
                        description = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Cost'),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      setState(() {
                        cost = double.tryParse(value) ?? 0.0;
                      });
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration:
                              const InputDecoration(labelText: 'Currency'),
                          value: selectedCurrency,
                          items: currencyOptions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCurrency = value!;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration:
                              const InputDecoration(labelText: 'Category'),
                          value: selectedCategory,
                          items: categoryOptions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.location_on),
                              labelText: 'Location'),
                          value: selectedLocation,
                          items: locationOptions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedLocation = value!;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                selectedDate = pickedDate;
                              });
                            }
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Date',
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today),
                                const SizedBox(width: 8.0),
                                Text(
                                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'), //date, month and year only
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Notes'),
                    maxLines: 3,
                    onChanged: (value) {
                      setState(() {
                        notes = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: _toggleFormVisibility,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 50.0,
        ),
      ),
    );
  }
}
