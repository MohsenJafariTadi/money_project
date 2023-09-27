// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:money_app/utils/calculate.dart';
import 'package:money_app/utils/extension.dart';
import 'package:money_app/widgets/chart_widget.dart';
import 'dart:ffi';

class InfoScreen extends StatefulWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0, top: 15.0, left: 5),
              child: Text(
                'مدیریت تراکنش ها به تومان ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenSize(context).screenWidth < 1004
                      ? 14
                      : screenSize(context).screenWidth * 0.01,
                ),
              ),
            ),
            MonyInfoWidget(
              firstText: ' : دریافتی امروز',
              firstPrice: Calculate.dToday().toString(),
              secondText: ' : پرداختی امروز',
              secondPrice: Calculate.pToday().toString(),
            ),
            MonyInfoWidget(
              firstText: ' : دریافتی این ماه',
              firstPrice: Calculate.dMonth().toString(),
              secondText: ': پرداختی این ماه',
              secondPrice: Calculate.pMonth().toString(),
            ),
            MonyInfoWidget(
              firstText: ' : دریافتی این سال',
              firstPrice: Calculate.dYear().toString(),
              secondText: ' : پرداختی این سال',
              secondPrice: Calculate.pYear().toString(),
            ),
            SizedBox(height: 20),
            Calculate.dYear() == 0 && Calculate.pYear() == 0
                ? Container()
                : Container(
                    padding: EdgeInsets.all(30),
                    height: 200,
                    child: BarChartWidget(),
                  ),
          ],
        ),
      )),
    );
  }
}

class MonyInfoWidget extends StatelessWidget {
  final String firstText;
  final String secondText;
  final String firstPrice;
  final String secondPrice;
  const MonyInfoWidget({
    Key? key,
    required this.firstText,
    required this.secondText,
    required this.firstPrice,
    required this.secondPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0, top: 20.0, left: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
              child: Text(
            secondPrice,
            textAlign: TextAlign.right,
            style: TextStyle(
                fontSize: screenSize(context).screenWidth < 1004
                    ? 14
                    : screenSize(context).screenWidth * 0.01),
          )),
          Expanded(
            child: Text(
              secondText,
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: screenSize(context).screenWidth < 1004
                      ? 14
                      : screenSize(context).screenWidth * 0.01),
            ),
          ),
          Expanded(
              child: Text(
            firstPrice,
            textAlign: TextAlign.right,
            style: TextStyle(
                fontSize: screenSize(context).screenWidth < 1004
                    ? 14
                    : screenSize(context).screenWidth * 0.01),
          )),
          Expanded(
            child: Text(
              firstText,
              style: TextStyle(
                  fontSize: screenSize(context).screenWidth < 1004
                      ? 14
                      : screenSize(context).screenWidth * 0.01),
            ),
          ),
        ],
      ),
    );
  }
}
