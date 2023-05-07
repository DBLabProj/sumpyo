import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sumpyo/models/diary.dart';

class writeDiaryScreen extends StatelessWidget {
  writeDiaryScreen({super.key});
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  DateTime diaryDate = DateTime.now();

  upLoadDiary() {
    uploadDiary diary = uploadDiary(
      1,
      '1',
      titleController.text,
      contentController.text,
      diaryDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              alignment: Alignment.bottomLeft,
              height: 25 * 2.4,
              child: Text(
                DateFormat('yyyy년 MM월 dd일').format(diaryDate),
                style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Flexible(
              child: writeDiary(
                titleController: titleController,
                contentController: contentController,
              ),
            ),
          ],
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
          onPressed: () {},
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
  writeDiary({
    super.key,
    required this.titleController,
    required this.contentController,
  });

  @override
  State<writeDiary> createState() => writeDiaryState();
}

class writeDiaryState extends State<writeDiary> {
  double titleFontSize = 20.0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.732,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      padding: EdgeInsets.fromLTRB(
          10,
          MediaQuery.of(context).size.width * 0.035,
          MediaQuery.of(context).size.width * 0.035,
          0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.885,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    height: titleFontSize * 2,
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
                    decoration: const InputDecoration(
                      hintText: '제목: 2023.04.06 일기',
                      fillColor: Colors.white,
                      filled: true,
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.885,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    height: titleFontSize * 2,
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
    );
  }
}
