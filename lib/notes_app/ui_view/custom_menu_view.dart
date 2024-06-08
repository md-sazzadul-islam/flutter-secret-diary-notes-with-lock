import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:secret_diary/Controllers/PasscodeController.dart';
import 'package:secret_diary/notes_app/app_theme.dart';
import 'package:flutter/material.dart';

class CustomMenuView extends StatelessWidget {
  final String menuText;
  final IconData menuIcon;
  final PasscodeController? passcodeController;
  final Function? onClickAction;
  final AnimationController? animationController;
  final Animation<double>? animation;

  const CustomMenuView(
      {Key? key,
      this.menuText: "",
      this.menuIcon: Icons.abc,
      this.passcodeController,
      this.onClickAction,
      this.animationController,
      this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    var cCode = passcodeController!.allPasscode.length > 0
        ? passcodeController!.allPasscode[0].code!
        : '';
    int? iid = passcodeController!.allPasscode.length > 0
        ? passcodeController!.allPasscode[0].id!
        : null;
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation!.value), 0.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 10),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 50,
                      height: 50,
                      child: Material(
                        borderRadius: BorderRadius.circular(5),
                        color: isLightMode
                            ? AppTheme.darkerText.withOpacity(0.07)
                            : AppTheme.spacer.withOpacity(0.07),
                        child: InkWell(
                          splashColor: isLightMode
                              ? AppTheme.nearlyDarkBlue
                              : AppTheme.spacer,
                          onTap: () {
                            onClickAction!();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: 40,
                                child: Icon(
                                  menuIcon,
                                  color: isLightMode
                                      ? AppTheme.nearlyBlack
                                      : AppTheme.white,
                                  size: 18,
                                ),
                              ),
                              Text(
                                menuText,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  letterSpacing: 0.5,
                                  color: isLightMode
                                      ? AppTheme.nearlyBlack
                                      : AppTheme.white,
                                ),
                              ),
                              iid != null
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3 -
                                              10),
                                      child: SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: InkWell(
                                          splashColor:
                                              Colors.white.withOpacity(0.1),
                                          highlightColor: AppTheme.white,
                                          focusColor: AppTheme.nearlyBlack,
                                          onTap: () {
                                            AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.question,
                                              animType: AnimType.rightSlide,
                                              headerAnimationLoop: true,
                                              title: 'Remove',
                                              desc:
                                                  'Are you sure you want to remove your passcode?',
                                              btnOkOnPress: () {
                                                if (iid != null) {
                                                  screenLock(
                                                    context: context,
                                                    correctString: cCode,
                                                    canCancel: false,
                                                    onValidate: (value) async {
                                                      if (value == cCode) {
                                                        if (iid != null) {
                                                          passcodeController!
                                                              .deletePasscode(
                                                                  iid);
                                                        }
                                                        return true;
                                                      }
                                                      return false;
                                                    },
                                                  );
                                                }
                                              },
                                              btnCancelOnPress: () {},
                                            ).show();
                                          },
                                          child: Icon(
                                            Icons.delete_forever,
                                            color: isLightMode
                                                ? AppTheme.nearlyBlack
                                                : AppTheme.white,
                                            size: 18,
                                          ),
                                        ),
                                      ))
                                  : SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
