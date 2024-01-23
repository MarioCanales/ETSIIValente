import 'package:flutter/material.dart';

import 'design_window.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thevenin-Norton Solver',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedMeshes = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thevenin-Norton solver'),
      ),
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            //Add DropdownButton
            DropdownButton<int>(
              value: selectedMeshes,
              onChanged: (int? newValue) {
                setState(() {
                  selectedMeshes = newValue!;
                });
              },
              items: [2,3,4].map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value ramas')
                );
              }).toList(),
            ),
            // Button to go
            const SizedBox(width: 20), // some spacing
            ElevatedButton(
                onPressed: () {
                  print('Selected meshes: $selectedMeshes'); // Used to debug
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DesignWindow(selectedMeshes: selectedMeshes),
                      ),
                  );
                },
                child: const Text('Start designing'))
          ],
        )
      ),
    );
  }
}
