import 'package:flutter/material.dart';

class TabIconData {
  TabIconData({
    this.imagePath = '',
    this.index = 0,
    this.selectedImagePath = '',
    this.isSelected = false,
    this.animationController,
  });

  String imagePath;
  String selectedImagePath;
  bool isSelected;
  int index;

  AnimationController? animationController;

  static List<TabIconData> tabIconsList = <TabIconData>[
    TabIconData(
      imagePath: 'assets/notes_app/tab_1.png',
      selectedImagePath: 'assets/notes_app/tab_1s.png',
      index: 0,
      isSelected: true,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/notes_app/tab_2.png',
      selectedImagePath: 'assets/notes_app/tab_2s.png',
      index: 1,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/notes_app/tab_2.png',
      selectedImagePath: 'assets/notes_app/tab_2s.png',
      index: 2,
      isSelected: false,
      animationController: null,
    ),
  ];
}
