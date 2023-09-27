// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/parser.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_app/main.dart';
import 'package:money_app/screens/main_screen.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:money_app/utils/extension.dart';
import 'package:money_app/constant.dart';
import 'package:money_app/models/money.dart';
import 'package:money_app/screens/new_transactions_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static List<Money> moneys = [];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  Box<Money> hiveBox = Hive.box<Money>('moneyBox');
  @override
  void initState() {
    // TODO: implement initState
    MyApp.getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: fabWidget(),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              HeaderWidget(),
              // EmptyWidget(),

              Expanded(
                child: HomeScreen.moneys.isEmpty
                    ? EmptyWidget()
                    : ListView.builder(
                        // scrollDirection: Axis.vertical,
                        itemCount: HomeScreen.moneys.length,
                        itemBuilder: ((context, index) {
                          return GestureDetector(
                            //Edit
                            onTap: () {
                              NewTranactionsScreen.date =
                                  HomeScreen.moneys[index].date;
                              NewTranactionsScreen.descriptionController.text =
                                  HomeScreen.moneys[index].title;
                              NewTranactionsScreen.priceController.text =
                                  HomeScreen.moneys[index].price;
                              NewTranactionsScreen.groupid =
                                  HomeScreen.moneys[index].isReceived ? 1 : 2;
                              NewTranactionsScreen.isEditing = true;
                              NewTranactionsScreen.id =
                                  HomeScreen.moneys[index].id;
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return NewTranactionsScreen();
                              })).then((value) {
                                MyApp.getData();
                                setState(() {});
                              });
                            },
                            onLongPress: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                        'ایا مایلید حذف بشود',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      actionsAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('نه')),
                                        TextButton(
                                            onPressed: () {
                                              hiveBox.deleteAt(index);
                                              MyApp.getData();
                                              setState(() {});
                                              Navigator.pop(context);
                                            },
                                            child: Text('بله')),
                                      ],
                                    );
                                  });
                            },
                            child: MyListTileWidget(
                              index: index,
                            ),
                          );
                        })),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget fabWidget() {
    return FloatingActionButton(
      backgroundColor: kPurpleColor,
      elevation: 0,
      onPressed: () {
        NewTranactionsScreen.date = 'تاریخ';
        NewTranactionsScreen.descriptionController.text = '';
        NewTranactionsScreen.descriptionController.text = '';
        NewTranactionsScreen.groupid = 0;
        NewTranactionsScreen.isEditing = false;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) {
            return NewTranactionsScreen();
          }),
        ).then((value) {
          MyApp.getData();
          setState(() {});
        });
      },
      child: Icon(Icons.add),
    );
  }

  Widget HeaderWidget() {
    return Padding(
      padding: const EdgeInsets.only(right: 20, top: 20, left: 5),
      child: Row(
        children: [
          Expanded(
            child: SearchBarAnimation(
              hintText: '...  جستجو کنید',
              buttonElevation: 0,
              textEditingController: searchController,
              isOriginalAnimation: false,
              trailingWidget: Icon(
                Icons.search,
                color: Colors.black,
              ),
              secondaryButtonWidget: Icon(
                Icons.cancel_rounded,
                color: Colors.black,
              ),
              buttonWidget: Icon(
                Icons.search,
                color: Colors.black,
              ),
              onCollapseComplete: () {
                MyApp.getData();
                searchController.text = '';
                setState(() {});
              },
              onFieldSubmitted: (String text) {
                List<Money> result = hiveBox.values
                    .where((values) =>
                        values.title.contains(text) ||
                        values.date.contains(text))
                    .toList();
                HomeScreen.moneys.clear();
                setState(
                  () {
                    for (var values in result) {
                      HomeScreen.moneys.add(values);
                    }
                  },
                );
              },
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            ' تراکنش ها ',
            style: TextStyle(
                fontSize: screenSize(context).screenWidth < 1004
                    ? 18
                    : screenSize(context).screenWidth * 0.015),
          ),
        ],
      ),
    );
  }
}

class MyListTileWidget extends StatelessWidget {
  final int index;
  const MyListTileWidget({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var listmony = HomeScreen.moneys[index];
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(

        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: listmony.isReceived ? kGreenColor : kRedColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
                child: Icon(
              listmony.isReceived ? Icons.add : Icons.remove,
              color: Colors.white,
              size: 30,
            )),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
            ),
            child: Text(
              listmony.title,
               style: TextStyle(
                fontSize: screenSize(context).screenWidth < 1004
                    ? 14
                    : screenSize(context).screenWidth * 0.015),
            ),
          ),
          Spacer(),
          Column(
            
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
             
                children: [
                  Text(
                    'تومان ',
                    style: TextStyle(fontSize: screenSize(context).screenWidth < 1004
                    ? 14
                    : screenSize(context).screenWidth * 0.015, color: kRedColor),
                  ),
                  Text(
                    listmony.price,
                    style: TextStyle(fontSize: screenSize(context).screenWidth < 1004
                    ? 14
                    : screenSize(context).screenWidth * 0.015, color: kRedColor),
                  ),
                ],
              ),
              Text(
                listmony.date,
                style: TextStyle(fontSize: screenSize(context).screenWidth < 1004
                    ? 12
                    : screenSize(context).screenWidth * 0.01,),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image(
          height: 400,
          image: AssetImage('assets/images/empty.png'),
        ),
        Text(' !تراکنشی موجود نیست'),
      ],
    );
  }
}
