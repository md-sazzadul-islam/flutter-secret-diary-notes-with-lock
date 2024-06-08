import 'package:secret_diary/notes_app/app_theme.dart';
import 'package:flutter/material.dart';

class MenuView extends StatelessWidget {
  final String menuText;
  final IconData menuIcon;
  final Function? onClickAction;
  final AnimationController? animationController;
  final Animation<double>? animation;

  const MenuView(
      {Key? key,
      this.menuText: "",
      this.menuIcon: Icons.abc,
      this.onClickAction,
      this.animationController,
      this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
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
                              ), // <-- Text
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
