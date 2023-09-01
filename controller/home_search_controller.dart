import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeConteroller extends GetxController {
  static final searchPageID = "searchPageID";
  static HomeConteroller get to => Get.put(HomeConteroller());

  PageController pageController = PageController(initialPage: 0);
  int currentPage = 0;



  void changeCurrentPage(int index){
    currentPage = index;
    update([searchPageID]);
  }
}