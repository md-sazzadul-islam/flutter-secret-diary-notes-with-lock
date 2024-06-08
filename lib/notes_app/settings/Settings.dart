import 'package:secret_diary/Controllers/PasscodeController.dart';
import 'package:secret_diary/model/Passcode.dart';
import 'package:secret_diary/model/User.dart';
import 'package:secret_diary/notes_app/ui_view/custom_menu_view.dart';
import 'package:secret_diary/notes_app/ui_view/menu_view.dart';
import 'package:secret_diary/notes_app/ui_view/title_view.dart';
import 'package:secret_diary/notes_app/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:get/get.dart';
import '../../Controllers/UserController.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Settings_ extends StatefulWidget {
  const Settings_({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;
  @override
  _Settings_State createState() => _Settings_State();
}

class _Settings_State extends State<Settings_> with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  final userController = Get.put(UserController());
  final passcodeController = Get.put(PasscodeController());
  late String passcodeValue;
  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    addAllListData();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  createPassCode(input) {
    setState(() {
      passcodeValue = input;
    });
    // print(input);
    Navigator.of(context).pop();
    _passcodeComDialog(context);
  }

  passcode() {
    final controller = InputController();
    screenLockCreate(
      context: context,
      inputController: controller,
      onConfirmed: (matchedText) => createPassCode(matchedText),
      onCancelled: Navigator.of(context).pop,
      footer: TextButton(
        onPressed: () {
          // Release the confirmation state and return to the initial input state.
          controller.unsetConfirmed();
        },
        child: const Text('Reset input'),
      ),
    );
  }

  TextEditingController _nameFieldController = TextEditingController();
  _displayDialog(BuildContext context) async {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    _nameFieldController.text = userController.allUser.length > 0
        ? userController.allUser[0].name!
        : '';

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor:
                isLightMode ? AppTheme.spacer : AppTheme.nearlyBlack,
            title: Text('Enter Your Name',
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  color:
                      isLightMode ? AppTheme.nearlyBlack : AppTheme.nearlyWhite,
                )),
            content: TextField(
              style: TextStyle(
                  color: isLightMode
                      ? AppTheme.nearlyBlack
                      : AppTheme.nearlyWhite),
              controller: _nameFieldController,
              decoration: InputDecoration(
                hintText: "Name",
                hintStyle: TextStyle(
                  fontFamily: AppTheme.fontName,
                  color: isLightMode ? AppTheme.nearlyBlack : AppTheme.grey,
                ),
                enabledBorder: OutlineInputBorder(
                  // width: 0.0 produces a thin "hairline" border
                  borderSide: BorderSide(
                      color: isLightMode
                          ? AppTheme.nearlyBlack
                          : AppTheme.nearlyWhite,
                      width: 0.0),
                ),
                border: OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.person,
                  color:
                      isLightMode ? AppTheme.nearlyBlack : AppTheme.nearlyWhite,
                ),
              ),
            ),
            actions: [
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(
                      isLightMode ? AppTheme.deactivatedText : AppTheme.grey),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel',
                    style: TextStyle(
                      fontFamily: AppTheme.fontName,
                      color: AppTheme.nearlyWhite,
                    )),
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(
                      isLightMode ? AppTheme.grey : AppTheme.nearlyDarkBlue),
                ),
                onPressed: () {
                  print(userController.allUser.length);

                  if (userController.allUser.length > 0) {
                    int? getId = userController.allUser[0].id;
                    userController.updateUser(
                        User(id: getId, name: _nameFieldController.text));
                    Fluttertoast.showToast(
                        msg: "Name Update Successfull",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    userController
                        .addUser(User(name: _nameFieldController.text));
                    Fluttertoast.showToast(
                        msg: "Name Update Successfull",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                  Navigator.of(context).pop();
                },
                child: Text('Save',
                    style: TextStyle(
                      fontFamily: AppTheme.fontName,
                      color: AppTheme.nearlyWhite,
                    )),
              )
            ],
          );
        });
  }

  TextEditingController _emailFieldController = TextEditingController();

  _passcodeComDialog(BuildContext context) async {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    _emailFieldController.text = passcodeController.allPasscode.length > 0
        ? passcodeController.allPasscode[0].email!
        : '';
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor:
                isLightMode ? AppTheme.spacer : AppTheme.nearlyBlack,
            title: Text('Enter Your Email',
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  color:
                      isLightMode ? AppTheme.nearlyBlack : AppTheme.nearlyWhite,
                )),
            content: Container(
                height: 90,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      style: TextStyle(
                          color: isLightMode
                              ? AppTheme.nearlyBlack
                              : AppTheme.nearlyWhite),
                      controller: _emailFieldController,
                      decoration: InputDecoration(
                        hintText: "Recover Email Address",
                        hintStyle: TextStyle(
                          fontFamily: AppTheme.fontName,
                          color: isLightMode
                              ? AppTheme.nearlyBlack
                              : AppTheme.grey,
                        ),
                        enabledBorder: OutlineInputBorder(
                          // width: 0.0 produces a thin "hairline" border
                          borderSide: BorderSide(
                              color: isLightMode
                                  ? AppTheme.nearlyBlack
                                  : AppTheme.nearlyWhite,
                              width: 0.0),
                        ),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                          Icons.email,
                          color: isLightMode
                              ? AppTheme.nearlyBlack
                              : AppTheme.nearlyWhite,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                          "Note: If don't use email, passcode is not workable.",
                          style: TextStyle(
                            fontFamily: AppTheme.fontName,
                            fontSize: 10,
                            color: isLightMode
                                ? AppTheme.nearlyBlack
                                : AppTheme.deactivatedText,
                          )),
                    )
                  ],
                )),
            actions: [
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(
                      isLightMode ? AppTheme.deactivatedText : AppTheme.grey),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel',
                    style: TextStyle(
                      fontFamily: AppTheme.fontName,
                      color: AppTheme.nearlyWhite,
                    )),
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(
                      isLightMode ? AppTheme.grey : AppTheme.nearlyDarkBlue),
                ),
                onPressed: () {
                  // print(passcodeController.allPasscode.length);

                  if (passcodeController.allPasscode.length > 0) {
                    int? getId = passcodeController.allPasscode[0].id;
                    passcodeController.updatePasscode(Passcode(
                        id: getId,
                        email: _emailFieldController.text,
                        code: passcodeValue));
                    Fluttertoast.showToast(
                        msg: "Passcode Update Successfull",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    passcodeController.addPasscode(Passcode(
                        email: _emailFieldController.text,
                        code: passcodeValue));
                    Fluttertoast.showToast(
                        msg: "Passcode Add Successfully",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                  Navigator.of(context).pop();
                },
                child: Text('Save',
                    style: TextStyle(
                      fontFamily: AppTheme.fontName,
                      color: AppTheme.nearlyWhite,
                    )),
              )
            ],
          );
        });
  }

  void addAllListData() {
    const int count = 9;
    listViews.add(
      TitleView(
        titleTxt: 'Personal',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
                Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );
    listViews.add(
      MenuView(
        menuText: 'Your Name',
        menuIcon: Icons.supervised_user_circle,
        onClickAction: () => {_displayDialog(context)},
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
                Interval((1 / count) * 1, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );
    listViews.add(
      CustomMenuView(
        menuText: 'Passcode (PIN)',
        menuIcon: Icons.password,
        passcodeController: passcodeController,
        onClickAction: () => {passcode()},
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
                Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );
    // listViews.add(
    //   TitleView(
    //     titleTxt: 'My Data',
    //     animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    //         parent: widget.animationController!,
    //         curve:
    //             Interval((1 / count) * 3, 1.0, curve: Curves.fastOutSlowIn))),
    //     animationController: widget.animationController!,
    //   ),
    // );
    // listViews.add(
    //   MenuView(
    //     menuText: 'Delete All Data',
    //     menuIcon: Icons.delete_forever,
    //     animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    //         parent: widget.animationController!,
    //         curve:
    //             Interval((1 / count) * 4, 1.0, curve: Curves.fastOutSlowIn))),
    //     animationController: widget.animationController!,
    //   ),
    // );
    // listViews.add(
    //   TitleView(
    //     titleTxt: 'Others',
    //     animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    //         parent: widget.animationController!,
    //         curve:
    //             Interval((1 / count) * 5, 1.0, curve: Curves.fastOutSlowIn))),
    //     animationController: widget.animationController!,
    //   ),
    // );
    // listViews.add(
    //   MenuView(
    //     menuText: 'Share With Friends',
    //     menuIcon: Icons.access_alarm,
    //     animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    //         parent: widget.animationController!,
    //         curve:
    //             Interval((1 / count) * 6, 1.0, curve: Curves.fastOutSlowIn))),
    //     animationController: widget.animationController!,
    //   ),
    // );
    // listViews.add(
    //   MenuView(
    //     menuText: 'Help',
    //     menuIcon: Icons.help,
    //     animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    //         parent: widget.animationController!,
    //         curve:
    //             Interval((1 / count) * 7, 1.0, curve: Curves.fastOutSlowIn))),
    //     animationController: widget.animationController!,
    //   ),
    // );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: isLightMode ? AppTheme.white : AppTheme.nearlyBlack,
        // backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),
            getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController?.forward();
              return listViews[index];
            },
          );
        }
      },
    );
  }

  Widget getAppBarUI() {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController!,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: topBarAnimation!,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation!.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: isLightMode
                        ? AppTheme.spacer.withOpacity(topBarOpacity)
                        : AppTheme.darkerText.withOpacity(topBarOpacity),
                    // color: AppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                      bottomRight: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: isLightMode
                              ? AppTheme.deactivatedText
                                  .withOpacity(0.4 * topBarOpacity)
                              : AppTheme.lightText
                                  .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 15,
                            right: 16,
                            top: 12 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Settings',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: isLightMode
                                        ? AppTheme.darkerText
                                        : AppTheme.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
