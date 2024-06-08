import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:intl/intl.dart';
import 'package:secret_diary/Controllers/NoteController.dart';
import 'package:secret_diary/model/Note.dart';
import 'package:secret_diary/notes_app/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NoteAdd extends StatefulWidget {
  const NoteAdd({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;
  @override
  _NoteAddState createState() => _NoteAddState();
}

class _NoteAddState extends State<NoteAdd> with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  final noteController = Get.put(NoteController());

  late String passcodeValue;

  TextEditingController _titleFieldController = TextEditingController();
  TextEditingController _noteFieldController = TextEditingController();
  TextEditingController _dateFieldController = TextEditingController();

  // TextEditingController _modeFieldController = TextEditingController();

  @override
  void initState() {
    _dateFieldController.text = DateFormat("yyyy-MM-dd").format(DateTime.now());
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

  void addAllListData() {
    const int count = 9;

    listViews.add(AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        var brightness = MediaQuery.of(context).platformBrightness;
        bool isLightMode = brightness == Brightness.light;
        Animation<double>? animation = Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(
                parent: widget.animationController!,
                curve: Interval((1 / count) * 0, 1.0,
                    curve: Curves.fastOutSlowIn)));
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation.value), 0.0),
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
                            // onClickAction!();
                          },
                          child: TextField(
                            style: TextStyle(
                                color: isLightMode
                                    ? AppTheme.nearlyBlack
                                    : AppTheme.nearlyWhite),
                            controller: _titleFieldController,
                            decoration: InputDecoration(
                              // hintText: "Title",
                              labelText: 'Title',
                              labelStyle: TextStyle(
                                fontFamily: AppTheme.fontName,
                                color: isLightMode
                                    ? AppTheme.nearlyBlack
                                    : AppTheme.nearlyWhite,
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
                                Icons.title,
                                color: isLightMode
                                    ? AppTheme.nearlyBlack
                                    : AppTheme.nearlyWhite,
                              ),
                            ),
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
    ));
    listViews.add(AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        var brightness = MediaQuery.of(context).platformBrightness;
        bool isLightMode = brightness == Brightness.light;
        Animation<double>? animation = Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(
                parent: widget.animationController!,
                curve: Interval((1 / count) * 1, 1.0,
                    curve: Curves.fastOutSlowIn)));
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation.value), 0.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 10),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 50,
                      // height: 50,
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
                            // onClickAction!();
                          },
                          child: TextField(
                            style: TextStyle(
                                color: isLightMode
                                    ? AppTheme.nearlyBlack
                                    : AppTheme.nearlyWhite),
                            controller: _noteFieldController,
                            maxLines: 10,
                            minLines: 4,
                            decoration: InputDecoration(
                              // hintText: "Note",
                              labelText: 'Note',
                              labelStyle: TextStyle(
                                fontFamily: AppTheme.fontName,
                                color: isLightMode
                                    ? AppTheme.nearlyBlack
                                    : AppTheme.nearlyWhite,
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
                                Icons.event_note,
                                color: isLightMode
                                    ? AppTheme.nearlyBlack
                                    : AppTheme.nearlyWhite,
                              ),
                            ),
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
    ));
    listViews.add(AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        var brightness = MediaQuery.of(context).platformBrightness;
        bool isLightMode = brightness == Brightness.light;
        Animation<double>? animation = Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(
                parent: widget.animationController!,
                curve: Interval((1 / count) * 2, 1.0,
                    curve: Curves.fastOutSlowIn)));
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation.value), 0.0),
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
                            // onClickAction!();
                          },
                          child: TextField(
                            style: TextStyle(
                                color: isLightMode
                                    ? AppTheme.nearlyBlack
                                    : AppTheme.nearlyWhite),
                            controller: _dateFieldController,
                            focusNode: AlwaysDisabledFocusNode(),
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  builder: (context, child) {
                                    return Theme(
                                      data: ThemeData.dark().copyWith(
                                        colorScheme: ColorScheme.dark(
                                          primary: AppTheme.nearlyDarkBlue,
                                          onPrimary:
                                              Colors.white, //kPrimaryColor,
                                          surface: AppTheme.nearlyDarkBlue,
                                          onSurface: Colors.black,
                                        ),
                                        dialogBackgroundColor: Colors.white,
                                      ),
                                      child: child!,
                                    );
                                  },
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100));
                              if (pickedDate != null) {
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                setState(() {
                                  _dateFieldController.text = formattedDate;
                                });
                              }
                            },
                            decoration: InputDecoration(
                              // hintText: "Date",
                              labelText: 'Date',
                              labelStyle: TextStyle(
                                fontFamily: AppTheme.fontName,
                                color: isLightMode
                                    ? AppTheme.nearlyBlack
                                    : AppTheme.nearlyWhite,
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
                                Icons.date_range_outlined,
                                color: isLightMode
                                    ? AppTheme.nearlyBlack
                                    : AppTheme.nearlyWhite,
                              ),
                            ),
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
    ));
    listViews.add(AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        var brightness = MediaQuery.of(context).platformBrightness;
        bool isLightMode = brightness == Brightness.light;
        Animation<double>? animation = Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(
                parent: widget.animationController!,
                curve: Interval((1 / count) * 2, 1.0,
                    curve: Curves.fastOutSlowIn)));
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation.value), 0.0),
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
                              // onClickAction!();
                            },
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(isLightMode
                                        ? AppTheme.grey
                                        : AppTheme.nearlyDarkBlue),
                              ),
                              onPressed: () {
                                if (_titleFieldController.text != '' &&
                                    _noteFieldController.text != '') {
                                  noteController.addNote(Note(
                                    title: _titleFieldController.text,
                                    note: _noteFieldController.text,
                                    date: _dateFieldController.text,
                                  ));

                                  Fluttertoast.showToast(
                                      msg: "Note Add Successfully",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.black,
                                      textColor: Colors.white,
                                      fontSize: 16.0);

                                  _titleFieldController.text = '';
                                  _noteFieldController.text = '';
                                  // _dateFieldController.text = '';
                                } else {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.warning,
                                    headerAnimationLoop: false,
                                    animType: AnimType.bottomSlide,
                                    title: 'Validation',
                                    desc:
                                        '1. Title field is required. \n\n2. Note field is required',
                                    buttonsTextStyle:
                                        const TextStyle(color: Colors.black),
                                    showCloseIcon: true,
                                    // btnCancelOnPress: () {},
                                    btnOkOnPress: () {},
                                  ).show();
                                }
                              },
                              child: Text('Save',
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    color: AppTheme.nearlyWhite,
                                  )),
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ));
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
                                  'Note',
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

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
