import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../OnBoardingScreen/controller/OnboardingController.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final _controller = OnBoardingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Stack(
              children: [
                Positioned(
                  child: Container(
                    child: PageView.builder(
                        controller: _controller.pageController,
                        onPageChanged: _controller.onPageIndex,
                        itemCount: _controller.onBoardingPages.length,
                        itemBuilder: (context, index) {
                          return Container(
                            child: Image.asset(
                                _controller.onBoardingPages[index].imageAsset),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                          );
                        }),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: _controller.forward,
                          child: CircleAvatar(radius: 35, child: Obx(
                                  () {
                                return Text(_controller.isLastPage?'Start':'Next');
                              }
                          )),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )));
  }
}
