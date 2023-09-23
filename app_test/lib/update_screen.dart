import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updatePerson,
        child: Icon(Icons.edit),
      ),
    );
  }

  Future _updatePerson() async {
    //
  }
}
