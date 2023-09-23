import 'package:app_test/person.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  bool creatingPerson = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Name',
                  ),
                  validator: (value) {
                    //
                    final val = value ?? '';
                    if (val.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: genderController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Gender',
                  ),
                  validator: (value) {
                    //
                    final val = value ?? '';
                    if (val.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: ageController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Age',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    //
                    try {
                      int.parse(value ?? '');
                    } catch (e) {
                      return 'Should be a number';
                    }
                    final val = value ?? '';
                    if (val.isEmpty) {
                      return 'Required';
                    }

                    return null;
                  },
                ),
                StreamBuilder(
                  stream: db.collection('group').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                    if (snapshot.hasData) {
                      final persons = snapshot.data!.docs
                          .map((e) => Person.fromFirestore(e))
                          .toList();
                      return ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final person = persons[index];
                          return Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  leading: const CircleAvatar(
                                      child: Icon(Icons.person)),
                                  title: Text(person.name),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          );
                        },
                        itemCount: persons.length,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createPerson,
        tooltip: 'Add',
        child: creatingPerson
            ? CircularProgressIndicator.adaptive()
            : const Icon(Icons.add),
      ),
    );
  }

  // logic
  Future _createPerson() async {
    //
    setState(() {
      creatingPerson = true;
    });
    if (formKey.currentState?.validate() ?? false) {
      final name = nameController.text;
      final gender = genderController.text;
      final age = int.tryParse(ageController.text) ?? 0;

      Person person = Person(
        name: name,
        gender: gender,
        age: age,
      );

      await db.collection('group').add(
            person.toFirestore(),
          );
    }
    setState(() {
      creatingPerson = false;
    });
  }
}
