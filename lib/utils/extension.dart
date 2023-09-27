import 'package:flutter/cupertino.dart';

extension screenSize on BuildContext{
  get screenWidth=>MediaQuery.of(this).size.width;
  get screenheight=>MediaQuery.of(this).size.height;
}