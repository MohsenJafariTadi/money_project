// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_app/main.dart';
import 'package:money_app/utils/extension.dart';
import 'package:money_app/models/money.dart';
import 'package:money_app/screens/home_screen.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../constant.dart';

class NewTranactionsScreen extends StatefulWidget {
  const NewTranactionsScreen({Key? key}) : super(key: key);

  static int groupid = 0;
  static TextEditingController descriptionController = TextEditingController();
  static TextEditingController priceController = TextEditingController();
  static bool isEditing = false;
  static int id = 0;
  static String date = 'تاریخ';
  @override
  State<NewTranactionsScreen> createState() => _NewTranactionsScreenState();
}

class _NewTranactionsScreenState extends State<NewTranactionsScreen> {
  Box<Money> hiveBox = Hive.box<Money>('moneyBox');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  NewTranactionsScreen.isEditing
                      ? 'ویرایش تراکنش'
                      : 'تراکنش جدید',
                  style: TextStyle(
                    fontSize: screenSize(context).screenWidth < 1004
                    ? 14
                    : screenSize(context).screenWidth * 0.015
                  ),
                ),
              ),
              MyTextFild(
                controller: NewTranactionsScreen.descriptionController,
                hintText: 'توضیحات',
              ),
              MyTextFild(
                controller: NewTranactionsScreen.priceController,
                hintText: 'مبلغ ',
                type: TextInputType.number,
              ),
              TypeAddDateWidget(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: kPurpleColor,
                  ),
                  onPressed: () {
                    Money item = Money(
                        id: Random().nextInt(9999),
                        title: NewTranactionsScreen.descriptionController.text,
                        price: NewTranactionsScreen.priceController.text,
                        date: NewTranactionsScreen.date,
                        isReceived:
                            NewTranactionsScreen.groupid == 1 ? true : false);
                    if (NewTranactionsScreen.isEditing) {
                      int index = 0;
                      MyApp.getData();
                      for (int i = 0; i < hiveBox.values.length; i++) {
                        if (hiveBox.values.elementAt(i).id ==
                            NewTranactionsScreen.id) {
                          index = i;
                        }
                      }
                      hiveBox.putAt(index, item);
                    } else {
                      // HomeScreen.moneys.add(item);
                      hiveBox.add(item);
                    }
                    Navigator.pop(context);
                  },
                  child: Text(NewTranactionsScreen.isEditing
                      ? 'ویرایش کردن'
                      : 'اضافه کردن'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TypeAddDateWidget extends StatefulWidget {
  const TypeAddDateWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<TypeAddDateWidget> createState() => _TypeAddDateWidgetState();
}

class _TypeAddDateWidgetState extends State<TypeAddDateWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: MyRadioButton(
              value: 1,
              groupValue: NewTranactionsScreen.groupid,
              onChanged: (value) {
                setState(() {
                  NewTranactionsScreen.groupid = value!;
                });
              },
              text: 'دریافتی'),
        ),
        SizedBox(width: 10),
        Expanded(
          child: MyRadioButton(
              value: 2,
              groupValue: NewTranactionsScreen.groupid,
              onChanged: (value) {
                setState(() {
                  NewTranactionsScreen.groupid = value!;
                });
              },
              text: 'پرداختی'),
        ),
        SizedBox(width: 10),
        Expanded(
          child: OutlinedButton(
            onPressed: () async {
              var pickedDate = await showPersianDatePicker(
                  context: context,
                  initialDate: Jalali.now(),
                  firstDate: Jalali(1402),
                  lastDate: Jalali(1499));
              setState(() {
                String year = pickedDate!.year.toString();
                String month = pickedDate.month.toString().length == 1
                    ? '0${pickedDate.month.toString()}'
                    : pickedDate.month.toString();
                String day = pickedDate.day.toString().length == 1
                    ? '0${pickedDate.day.toString()}'
                    : pickedDate.day.toString();
                NewTranactionsScreen.date = year + '/' + month + '/' + day;
              });
            },
            child: Text(
              NewTranactionsScreen.date,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MyRadioButton extends StatelessWidget {
  final int value;
  final int groupValue;
  final Function(int?) onChanged;
  final String text;
  const MyRadioButton({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.text,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Radio(
            activeColor: kPurpleColor,
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
          ),
        ),
        Text(text),
      ],
    );
  }
}

class MyTextFild extends StatelessWidget {
  final String hintText;
  final TextInputType type;
  final TextEditingController controller;
  const MyTextFild({
    Key? key,
    required this.hintText,
    this.type = TextInputType.text,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        keyboardType: type,
        cursorColor: Colors.black38,
        decoration: InputDecoration(
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: screenSize(context).screenWidth < 1004
                    ? 14
                    : screenSize(context).screenWidth * 0.015,
          )
        ),
      ),
    );
  }
}
