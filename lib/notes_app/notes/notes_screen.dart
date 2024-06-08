import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:secret_diary/Controllers/NoteController.dart';
import 'package:secret_diary/model/Note.dart';
import 'package:secret_diary/notes_app/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  var noteController = Get.put(NoteController());
  String? dateFiter;

  TextEditingController _titleFieldController = TextEditingController();
  TextEditingController _noteFieldController = TextEditingController();
  TextEditingController _dateFieldController = TextEditingController();
  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    // addAllListData();

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
    noteController.fetchAllNote();
    noteController = Get.put(NoteController());
    // dateFiter = DateFormat("yyyy-MM-dd").format(DateTime.now());
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
          return noteController.allNote.isNotEmpty
              ? ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.only(
                    top: AppBar().preferredSize.height +
                        MediaQuery.of(context).padding.top +
                        30,
                    bottom: 62 + MediaQuery.of(context).padding.bottom,
                  ),
                  scrollDirection: Axis.vertical,
                  itemCount: (noteController.allNote.length == 0
                      ? 1
                      : noteController.allNote.length),
                  itemBuilder: (BuildContext context, int index) {
                    final int count = noteController.allNote.length > 10
                        ? 10
                        : noteController.allNote.length;
                    final Animation<double> animation =
                        Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: widget.animationController!,
                                curve: Interval((1 / count) * index, 1.0,
                                    curve: Curves.fastOutSlowIn)));
                    widget.animationController?.forward();
                    var brightness = MediaQuery.of(context).platformBrightness;
                    bool isLightMode = brightness == Brightness.light;
                    return AnimatedBuilder(
                      animation: widget.animationController!,
                      builder: (BuildContext context, Widget? child) {
                        var outputDate;
                        if (noteController.allNote[index].date != '') {
                          DateTime parseDate = new DateFormat("yyyy-MM-dd")
                              .parse(noteController.allNote[index].date!);
                          var inputDate = DateTime.parse(parseDate.toString());
                          var outputFormat = DateFormat('dd-MM-yy');
                          outputDate = outputFormat.format(inputDate);
                        } else {
                          outputDate = '';
                        }
                        return FadeTransition(
                          opacity: animation,
                          child: new Transform(
                            transform: new Matrix4.translationValues(
                                0.0, 30 * (1.0 - animation.value), 0.0),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 24, right: 24, top: -0, bottom: 0),
                                  child: InkWell(
                                    onTap: () {
                                      AwesomeDialog(
                                        context: context,
                                        headerAnimationLoop: false,
                                        dialogType: DialogType.noHeader,
                                        title: noteController
                                            .allNote[index].title!,
                                        desc:
                                            noteController.allNote[index].note!,
                                      ).show();
                                    },
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, bottom: 16),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: AppTheme.white,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8.0),
                                                  bottomLeft:
                                                      Radius.circular(8.0),
                                                  bottomRight:
                                                      Radius.circular(8.0),
                                                  topRight:
                                                      Radius.circular(8.0)),
                                              boxShadow: <BoxShadow>[
                                                BoxShadow(
                                                    color: AppTheme.grey
                                                        .withOpacity(0.4),
                                                    offset: Offset(1.1, 1.1),
                                                    blurRadius: 10.0),
                                              ],
                                            ),
                                            child: Stack(
                                              alignment: Alignment.topLeft,
                                              children: <Widget>[
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(8.0)),
                                                  child: SizedBox(
                                                    height: 74,
                                                    width: 100,
                                                    child: AspectRatio(
                                                      aspectRatio: 1.6,
                                                      child: Image.asset(
                                                          "assets/notes_app/back.png"),
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            left: 100,
                                                            right: 16,
                                                            top: 16,
                                                          ),
                                                          child: Text(
                                                            noteController
                                                                        .allNote[
                                                                            index]
                                                                        .title!
                                                                        .length >
                                                                    25
                                                                ? noteController
                                                                        .allNote[
                                                                            index]
                                                                        .title!
                                                                        .substring(
                                                                            0,
                                                                            25) +
                                                                    '...'
                                                                : noteController
                                                                    .allNote[
                                                                        index]
                                                                    .title!,
                                                            // noteController.allNote[index].title!,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  AppTheme
                                                                      .fontName,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 14,
                                                              letterSpacing:
                                                                  0.0,
                                                              color: AppTheme
                                                                  .nearlyDarkBlue,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        left: 100,
                                                        bottom: 12,
                                                        top: 4,
                                                        right: 16,
                                                      ),
                                                      child: Text(
                                                        noteController
                                                                    .allNote[
                                                                        index]
                                                                    .note!
                                                                    .length >
                                                                80
                                                            ? noteController
                                                                    .allNote[
                                                                        index]
                                                                    .note!
                                                                    .substring(
                                                                        0, 80) +
                                                                '...'
                                                            : noteController
                                                                .allNote[index]
                                                                .note!,
                                                        // noteController.allNote[index].note!,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              AppTheme.fontName,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 10,
                                                          letterSpacing: 0.0,
                                                          color: AppTheme.grey
                                                              .withOpacity(0.5),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: -16,
                                          left: 0,
                                          child: SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: Image.asset(
                                                "assets/notes_app/pencil.png"),
                                          ),
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    80,
                                                right: 0,
                                                top: 16,
                                              ),
                                              child: Container(
                                                height: 25,
                                                width: 25,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.redAccent,
                                                        spreadRadius: 1),
                                                  ],
                                                ),
                                                child: InkWell(
                                                  onTap: () {
                                                    AwesomeDialog(
                                                      context: context,
                                                      dialogType:
                                                          DialogType.question,
                                                      animType:
                                                          AnimType.rightSlide,
                                                      headerAnimationLoop: true,
                                                      title: 'Delete',
                                                      desc:
                                                          'Are you sure you want to delete?',
                                                      btnOkOnPress: () {
                                                        noteController
                                                            .deleteNote(
                                                                noteController
                                                                    .allNote[
                                                                        index]
                                                                    .id!);
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Data Delete Successfull.",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .CENTER,
                                                            timeInSecForIosWeb:
                                                                1,
                                                            backgroundColor:
                                                                Colors.black,
                                                            textColor:
                                                                Colors.white,
                                                            fontSize: 16.0);
                                                        setState(() {
                                                          noteController = Get.put(
                                                              NoteController());
                                                        });
                                                      },
                                                      btnCancelOnPress: () {},
                                                    ).show();
                                                  },
                                                  child: Icon(
                                                    Icons.delete_forever,
                                                    color: AppTheme.grey,
                                                    size: 18,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    80,
                                                right: 0,
                                                top: 10,
                                              ),
                                              child: Container(
                                                height: 25,
                                                width: 25,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color:
                                                            Colors.orangeAccent,
                                                        spreadRadius: 1),
                                                  ],
                                                ),
                                                child: InkWell(
                                                  onTap: () {
                                                    _noteFieldController.text =
                                                        noteController
                                                            .allNote[index]
                                                            .note!;
                                                    _titleFieldController.text =
                                                        noteController
                                                            .allNote[index]
                                                            .title!;
                                                    _dateFieldController.text =
                                                        noteController
                                                            .allNote[index]
                                                            .date!;
                                                    late AwesomeDialog dialog;
                                                    dialog = AwesomeDialog(
                                                      context: context,
                                                      animType: AnimType.scale,
                                                      dialogType:
                                                          DialogType.noHeader,
                                                      // keyboardAware: true,
                                                      body: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                          children: <Widget>[
                                                            Text(
                                                              'Note Edit',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline6,
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Material(
                                                              elevation: 0,
                                                              color: Colors
                                                                  .blueGrey
                                                                  .withAlpha(
                                                                      40),
                                                              child: TextField(
                                                                style: TextStyle(
                                                                    color: AppTheme
                                                                        .nearlyBlack),
                                                                controller:
                                                                    _titleFieldController,
                                                                decoration:
                                                                    InputDecoration(
                                                                  // hintText: "Title",
                                                                  labelText:
                                                                      'Title',
                                                                  labelStyle:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        AppTheme
                                                                            .fontName,
                                                                    color: AppTheme
                                                                        .nearlyBlack,
                                                                  ),
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    // width: 0.0 produces a thin "hairline" border
                                                                    borderSide: BorderSide(
                                                                        color: AppTheme
                                                                            .nearlyBlack,
                                                                        width:
                                                                            0.0),
                                                                  ),
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                  prefixIcon:
                                                                      Icon(
                                                                    Icons.title,
                                                                    color: AppTheme
                                                                        .nearlyBlack,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Material(
                                                              elevation: 0,
                                                              color: Colors
                                                                  .blueGrey
                                                                  .withAlpha(
                                                                      40),
                                                              child: TextField(
                                                                style: TextStyle(
                                                                    color: AppTheme
                                                                        .nearlyBlack),
                                                                controller:
                                                                    _noteFieldController,
                                                                maxLines: 10,
                                                                minLines: 4,
                                                                decoration:
                                                                    InputDecoration(
                                                                  // hintText: "Note",
                                                                  labelText:
                                                                      'Note',
                                                                  labelStyle:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        AppTheme
                                                                            .fontName,
                                                                    color: AppTheme
                                                                        .nearlyBlack,
                                                                  ),
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    // width: 0.0 produces a thin "hairline" border
                                                                    borderSide: BorderSide(
                                                                        color: AppTheme
                                                                            .nearlyBlack,
                                                                        width:
                                                                            0.0),
                                                                  ),
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                  prefixIcon:
                                                                      Icon(
                                                                    Icons
                                                                        .event_note,
                                                                    color: AppTheme
                                                                        .nearlyBlack,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Material(
                                                              elevation: 0,
                                                              color: Colors
                                                                  .blueGrey
                                                                  .withAlpha(
                                                                      40),
                                                              child: TextField(
                                                                style: TextStyle(
                                                                    color: AppTheme
                                                                        .nearlyBlack),
                                                                controller:
                                                                    _dateFieldController,
                                                                focusNode:
                                                                    AlwaysDisabledFocusNode(),
                                                                onTap:
                                                                    () async {
                                                                  DateTime?
                                                                      pickedDate =
                                                                      await showDatePicker(
                                                                          context:
                                                                              context,
                                                                          builder: (context,
                                                                              child) {
                                                                            return Theme(
                                                                              data: ThemeData.dark().copyWith(
                                                                                colorScheme: ColorScheme.dark(
                                                                                  primary: AppTheme.nearlyDarkBlue,
                                                                                  onPrimary: Colors.white, //kPrimaryColor,
                                                                                  surface: AppTheme.nearlyDarkBlue,
                                                                                  onSurface: Colors.black,
                                                                                ),
                                                                                dialogBackgroundColor: Colors.white,
                                                                              ),
                                                                              child: child!,
                                                                            );
                                                                          },
                                                                          initialDate: DateTime
                                                                              .now(),
                                                                          firstDate: DateTime(
                                                                              2000),
                                                                          lastDate:
                                                                              DateTime(2100));
                                                                  if (pickedDate !=
                                                                      null) {
                                                                    String
                                                                        formattedDate =
                                                                        DateFormat('yyyy-MM-dd')
                                                                            .format(pickedDate);
                                                                    setState(
                                                                        () {
                                                                      _dateFieldController
                                                                              .text =
                                                                          formattedDate;
                                                                    });
                                                                  }
                                                                },
                                                                decoration:
                                                                    InputDecoration(
                                                                  // hintText: "Date",
                                                                  labelText:
                                                                      'Date',
                                                                  labelStyle:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        AppTheme
                                                                            .fontName,
                                                                    color: AppTheme
                                                                        .nearlyBlack,
                                                                  ),
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    // width: 0.0 produces a thin "hairline" border
                                                                    borderSide: BorderSide(
                                                                        color: AppTheme
                                                                            .nearlyBlack,
                                                                        width:
                                                                            0.0),
                                                                  ),
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                  prefixIcon:
                                                                      Icon(
                                                                    Icons
                                                                        .date_range_outlined,
                                                                    color: AppTheme
                                                                        .nearlyBlack,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            AnimatedButton(
                                                              isFixedHeight:
                                                                  false,
                                                              color: AppTheme
                                                                  .nearlyDarkBlue,
                                                              text: 'Save',
                                                              pressEvent: () {
                                                                if (_titleFieldController
                                                                            .text !=
                                                                        '' &&
                                                                    _noteFieldController
                                                                            .text !=
                                                                        '') {
                                                                  noteController
                                                                      .updateNote(
                                                                          Note(
                                                                    id: noteController
                                                                        .allNote[
                                                                            index]
                                                                        .id!,
                                                                    title:
                                                                        _titleFieldController
                                                                            .text,
                                                                    note: _noteFieldController
                                                                        .text,
                                                                    date: _dateFieldController
                                                                        .text,
                                                                  ));

                                                                  Fluttertoast.showToast(
                                                                      msg:
                                                                          "Passcode Update Successfully",
                                                                      toastLength:
                                                                          Toast
                                                                              .LENGTH_SHORT,
                                                                      gravity: ToastGravity
                                                                          .CENTER,
                                                                      timeInSecForIosWeb:
                                                                          1,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .black,
                                                                      textColor:
                                                                          Colors
                                                                              .white,
                                                                      fontSize:
                                                                          16.0);

                                                                  _titleFieldController
                                                                      .text = '';
                                                                  _noteFieldController
                                                                      .text = '';
                                                                  // _dateFieldController.text = '';
                                                                  dialog
                                                                      .dismiss();
                                                                  setState(() {
                                                                    noteController
                                                                        .fetchAllNote();
                                                                    noteController =
                                                                        Get.put(
                                                                            NoteController());
                                                                  });
                                                                } else {
                                                                  AwesomeDialog(
                                                                    context:
                                                                        context,
                                                                    dialogType:
                                                                        DialogType
                                                                            .warning,
                                                                    headerAnimationLoop:
                                                                        false,
                                                                    animType:
                                                                        AnimType
                                                                            .bottomSlide,
                                                                    title:
                                                                        'Validation',
                                                                    desc:
                                                                        '1. Title field is required. \n\n2. Note field is required',
                                                                    buttonsTextStyle:
                                                                        const TextStyle(
                                                                            color:
                                                                                Colors.black),
                                                                    showCloseIcon:
                                                                        true,
                                                                    // btnCancelOnPress: () {},
                                                                    btnOkOnPress:
                                                                        () {},
                                                                  ).show();
                                                                }
                                                              },
                                                            ),
                                                            AnimatedButton(
                                                              isFixedHeight:
                                                                  false,
                                                              text: 'Close',
                                                              pressEvent: () {
                                                                dialog
                                                                    .dismiss();
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )..show();
                                                  },
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: AppTheme.grey,
                                                    size: 18,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Positioned(
                                          top: -2,
                                          left: 27,
                                          // right: 60,
                                          child: Text(
                                            // "8:20\nPM",
                                            outputDate,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontName,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 10,
                                              letterSpacing: 0.0,
                                              color: AppTheme.nearlyDarkBlue
                                                  .withOpacity(0.5),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  })
              : ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.only(
                    top: AppBar().preferredSize.height +
                        MediaQuery.of(context).padding.top +
                        30,
                    bottom: 62 + MediaQuery.of(context).padding.bottom,
                  ),
                  scrollDirection: Axis.vertical,
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    var brightness = MediaQuery.of(context).platformBrightness;
                    bool isLightMode = brightness == Brightness.light;
                    final int count = 1;
                    final Animation<double> animation =
                        Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: widget.animationController!,
                                curve: Interval((1 / count) * index, 1.0,
                                    curve: Curves.fastOutSlowIn)));
                    widget.animationController?.forward();
                    return AnimatedBuilder(
                      animation: widget.animationController!,
                      builder: (BuildContext context, Widget? child) {
                        return FadeTransition(
                          opacity: animation,
                          child: new Transform(
                              transform: new Matrix4.translationValues(
                                  0.0, 30 * (1.0 - animation.value), 0.0),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height - 200,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Lottie.asset(
                                      'assets/lottie/no-data.json',
                                    ),
                                    Text(
                                      'No Data Found',
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                        color: isLightMode
                                            ? AppTheme.deactivatedText
                                            : AppTheme.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        );
                      },
                    );
                  });
        }
      },
    );
  }

  Widget getAppBarUI() {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    DateTime? parseDate;
    if (dateFiter != null) {
      parseDate = new DateFormat("yyyy-MM-dd").parse(dateFiter!);
    } else {
      parseDate = DateTime.now();
    }

    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd MMM yy');
    String outputDate = outputFormat.format(inputDate);
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
                                  'My Notes',
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
                            InkWell(
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
                                    initialDate: parseDate != null
                                        ? parseDate
                                        : DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100));
                                if (pickedDate != null) {
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(pickedDate);
                                  noteController.fetchWhereNote(formattedDate);
                                  setState(() {
                                    dateFiter = formattedDate;
                                    noteController = Get.put(NoteController());
                                  });
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 8,
                                  right: 8,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Icon(
                                        Icons.calendar_today,
                                        color: isLightMode
                                            ? AppTheme.grey
                                            : AppTheme.nearlyWhite,
                                        size: 18,
                                      ),
                                    ),
                                    Text(
                                      dateFiter != null ? outputDate : "All",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18,
                                        letterSpacing: -0.2,
                                        color: isLightMode
                                            ? AppTheme.darkerText
                                            : AppTheme.nearlyWhite,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
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
