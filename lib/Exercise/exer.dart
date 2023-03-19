import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class calKcal extends StatefulWidget {
  calKcal({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _calKcalState createState() => _calKcalState();
}

class _calKcalState extends State<calKcal> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _calorieController = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _saveCalorie() async {
    if (_formKey.currentState!.validate()) {
      int calories = int.parse(_calorieController.text);
      DateTime now = DateTime.now(); // รับวันที่และเวลาปัจจุบัน

      // Save to Firestore
      await _firestore.collection('exer').add({
        'exer_cal': calories,
        'date': now, // เพิ่มวันที่และเวลาลงใน field "date"
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('บันทึกข้อมูลเรียบร้อยแล้ว')));
      _calorieController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20),
                Text(
                  'จำนวนแคลอรี่ที่เผาพลาญ',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 20),
                Container(
                  height: 51,
                  width: 260,
                  child: TextFormField(
                    controller: _calorieController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณากรอกจำนวนแคลอรี่';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'กรอกจำนวนแคลอรี่',
                      hintText: 'เช่น 100',
                      suffixText: 'Kcal',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(27),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveCalorie,
                  child: Text('บันทึก'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
