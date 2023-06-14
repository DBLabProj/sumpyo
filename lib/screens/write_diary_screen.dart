import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:sumpyo/apis/api.dart';
import 'package:sumpyo/models/diary.dart';
import 'package:sumpyo/screens/home_screen.dart';

class writeDiaryScreen extends StatefulWidget {
  Function viewDiary;
  writeDiaryScreen({super.key, viewDiary}) : viewDiary = (viewDiary ?? () {});

  @override
  State<writeDiaryScreen> createState() => _writeDiaryScreenState();
}

class _writeDiaryScreenState extends State<writeDiaryScreen> {
  double safeareaHeight = 100;

  TextEditingController diaryDateController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  DateTime diaryDate = DateTime.now();
  upLoadDiary() async {
    if (contentController.text != "") {
      if (titleController.text == "") {
        titleController.text = DateFormat('M월 d일 일기').format(diaryDate);
      }
      uploadDiary diary = uploadDiary(
        1,
        user['user_id'],
        titleController.text,
        contentController.text,
        diaryDate,
      );

      try {
        var res = await http.post(Uri.parse(RestAPI.uploadDiary),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(diary));
        if (res.statusCode == 200) {
          var resDiary = jsonDecode(res.body);
          if (resDiary['result'] == 'Success') {
            Fluttertoast.showToast(msg: '일기가 성공적으로 등록되었습니다.');
            Future.delayed(const Duration(milliseconds: 500), () {
              widget.viewDiary(_selectedDate);
            });
          } else if (resDiary['result'] == 'Updated') {
            Fluttertoast.showToast(msg: '일기가 성공적으로 갱신되었습니다.');
            Future.delayed(const Duration(milliseconds: 500), () {
              widget.viewDiary(_selectedDate);
            });
          } else {
            Fluttertoast.showToast(msg: '일기 등록 중 오류가 발생했습니다.');
          }
        }
      } catch (e) {
        print(e.toString());
        Fluttertoast.showToast(msg: e.toString());
      }
    } else {
      Fluttertoast.showToast(msg: '일기 내용을 입력해주세요.');
    }
  }

  DateTime? tempPickedDate;
  DateTime _selectedDate = DateTime.now();
  _selectDate() async {
    DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      backgroundColor: ThemeData.light().scaffoldBackgroundColor,
      context: context,
      builder: (context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButton(
                      child: const Text('취소'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    CupertinoButton(
                      child: const Text('완료'),
                      onPressed: () {
                        Navigator.of(context).pop(tempPickedDate);
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 0,
                thickness: 1,
              ),
              Expanded(
                child: Container(
                  child: CupertinoDatePicker(
                    // dateOrder: DatePickerDateOrder(),
                    backgroundColor: ThemeData.light().scaffoldBackgroundColor,
                    minimumYear: 1900,
                    maximumYear: DateTime.now().year,
                    initialDateTime: DateTime.now(),
                    maximumDate: DateTime.now(),
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (DateTime dateTime) {
                      tempPickedDate = dateTime;
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        diaryDate = pickedDate;
        print(diaryDate);
        // convertDateTimeDisplay(diaryDateController.text);
      });
    }
  }

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
    final DateTime displayDate = displayFormater.parse(date);
    return diaryDateController.text = serverFormater.format(displayDate);
  }

  @override
  Widget build(BuildContext context) {
    safeareaHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        80;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Container(
            constraints: BoxConstraints(maxHeight: safeareaHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(20),
                  alignment: Alignment.bottomLeft,
                  height: 25 * 2.4,
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      _selectDate();
                    },
                    child: Row(
                      children: [
                        Text(
                          DateFormat('yyyy년 MM월 dd일').format(diaryDate),
                          style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const Icon(
                          Icons.open_in_new,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: writeDiary(
                    titleController: titleController,
                    contentController: contentController,
                    diaryDate: diaryDate,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width * 0.38,
        height: MediaQuery.of(context).size.height * 0.055,
        child: TextButton(
          style: ButtonStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0))),
              backgroundColor:
                  MaterialStatePropertyAll(Theme.of(context).primaryColor)),
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            upLoadDiary();
          },
          child: const Text(
            '등록하기',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------일기 작성----------------------------------
class writeDiary extends StatefulWidget {
  TextEditingController titleController;
  TextEditingController contentController;
  DateTime diaryDate;
  writeDiary({
    super.key,
    required this.titleController,
    required this.contentController,
    required this.diaryDate,
  });

  @override
  State<writeDiary> createState() => writeDiaryState();
}

class writeDiaryState extends State<writeDiary> {
  double titleFontSize = 20.0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.732,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        padding: EdgeInsets.fromLTRB(
            10,
            MediaQuery.of(context).size.height * 0.035,
            MediaQuery.of(context).size.width * 0.035,
            0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      height: MediaQuery.of(context).size.height * 0.035,
                      child: Text(
                        'Title',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextField(
                      controller: widget.titleController,
                      decoration: InputDecoration(
                        hintText:
                            '제목: ${DateFormat('yyyy.MM.dd').format(widget.diaryDate)} 일기',
                        fillColor: Colors.white,
                        filled: true,
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.03,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      height: MediaQuery.of(context).size.height * 0.035,
                      child: Text(
                        'Story',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.55,
                      child: TextFormField(
                        controller: widget.contentController,
                        minLines: null,
                        maxLines: null,
                        expands: true,
                        decoration: const InputDecoration(
                          hintText: '내용을 입력해주세요.',
                          fillColor: Colors.white,
                          filled: true,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
