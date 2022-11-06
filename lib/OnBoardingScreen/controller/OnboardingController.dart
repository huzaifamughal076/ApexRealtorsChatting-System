import 'package:apex_realtors_chatting_system/Screen/HomeScreen.dart';
import 'package:apex_realtors_chatting_system/Screen/LoginScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../model/onBoardingModel.dart';

class OnBoardingController extends GetxController{

var onPageIndex=0.obs;
bool  get isLastPage =>onPageIndex.value==onBoardingPages.length-1;
var pageController=PageController();

forward(){
  if(isLastPage){
    //go to Dashboard
    Get.offAll(LoginScreen());
  }
  else{

  pageController.nextPage(duration:300.milliseconds, curve: Curves.bounceOut);
  }
}

List<OnBoardingModel> onBoardingPages=[
OnBoardingModel(imageAsset: 'assets/images/Screen1.png',name:'Image Hola'),
OnBoardingModel(imageAsset: 'assets/images/llu_logo.png',name:'Image Second'),

];

}