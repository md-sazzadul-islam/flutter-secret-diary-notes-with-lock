import 'package:get/get.dart';
import 'package:secret_diary/Controllers/PasscodeController.dart';
import 'package:secret_diary/model/tabIcon_data.dart';
import 'package:secret_diary/notes_app/notes/note_add.dart';
import 'package:secret_diary/notes_app/settings/Settings.dart';
import 'package:secret_diary/notes_app/notes/notes_screen.dart';
import 'package:flutter/material.dart';
import 'bottom_navigation_view/bottom_bar_view.dart';
import 'app_theme.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

class NotesAppHomeScreen extends StatefulWidget {
  @override
  _NotesAppHomeScreenState createState() => _NotesAppHomeScreenState();
}

class _NotesAppHomeScreenState extends State<NotesAppHomeScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  AnimationController? animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;
  final passcodeController = Get.put(PasscodeController());
  late String code;
  Widget tabBody = Container(
    color: AppTheme.background,
  );
  int cycleState = 0;
  @override
  void initState() {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = NotesScreen(animationController: animationController);
    super.initState();
    Future.delayed(Duration(seconds: 1), () async {
      code = passcodeController.allPasscode.length > 0
          ? passcodeController.allPasscode[0].code!
          : '';
      if (code != '') {
        passcode(code);
        setState(() {
          cycleState = 1;
        });
      }
    });
    WidgetsBinding.instance.addObserver(this);
  }

  void passcode(String c_code) {
    screenLock(
      context: context,
      correctString: c_code,
      canCancel: false,
      onValidate: (value) async {
        if (value == c_code) {
          cycleState = 0;
          return true;
        }
        return false;
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (cycleState == 0) {
        code = passcodeController.allPasscode.length > 0
            ? passcodeController.allPasscode[0].code!
            : '';
        if (code != '') {
          passcode(code);
          setState(() {
            cycleState = 1;
          });
        }
      }
    } else {
      // cycleState = 0;
    }
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  tabBody,
                  bottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {},
          changeIndex: (int index) {
            // if (index == 0) {
            //   animationController?.reverse().then<dynamic>((data) {
            //     if (!mounted) {
            //       return;
            //     }
            //     setState(() {
            //       tabBody =
            //           MyDiaryScreen(animationController: animationController);
            //     });
            //   });
            if (index == 0) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      NotesScreen(animationController: animationController);
                });
              });
            } else if (index == 1) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = Settings_(animationController: animationController);
                });
              });
            } else if (index == 2) {
              animationController?.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = NoteAdd(animationController: animationController);
                });
              });
            }
          },
        ),
      ],
    );
  }
}
