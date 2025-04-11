import 'package:get/get.dart';

void showSnackBar(String title,String msg){
   Get.snackbar(title, msg,snackPosition: SnackPosition.BOTTOM,duration: Duration(seconds: 3));
}