import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sumpyo/apis/api.dart';
import 'package:sumpyo/models/diary.dart';
import 'package:sumpyo/screens/home_screen.dart';

garbage() {}

class noticeScreen extends StatefulWidget {
  Function viewDiary;
  noticeScreen({super.key, this.viewDiary = garbage});

  @override
  State<noticeScreen> createState() => _noticeScreenState();
}

class _noticeScreenState extends State<noticeScreen> {
  double titleFontSize = 20.0;
  double containerHeight = 100.0;
  double screenSize = 0.0;
  String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String TopTitle = '아직 오늘 일기가 없어요!\n일기를 작성해보세요!';

  @override
  void initState() {
    super.initState();
    if (postedDiarys.containsKey(today)) {
      // setState(() {
      TopTitle = '오늘의 분석이\n완료되었습니다!';
      // });
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        containerHeight = getRecommendCardSize();
      });
    });
  }

  double getRecommendCardSize() {
    return screenSize - (titleFontSize * 4 + 40);
  }

  @override
  Widget build(BuildContext context) {
    var diaryKeys = postedDiarys.keys.toList();
    screenSize = MediaQuery.of(context).size.height -
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                alignment: Alignment.bottomLeft,
                height: titleFontSize * 4,
                child: Text(
                  TopTitle,
                  style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Container(
                constraints: BoxConstraints(minHeight: containerHeight),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width * 0.1,
                    MediaQuery.of(context).size.width * 0.1,
                    MediaQuery.of(context).size.width * 0.1,
                    0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: diaryKeys.length,
                        itemBuilder: (context, index) {
                          Diary target = postedDiarys[diaryKeys[index]]!;
                          return Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      width: 2,
                                    ),
                                  ),
                                ),
                                width:
                                    MediaQuery.of(context).size.width * 0.885,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    titleFontSize * 0.25,
                                    titleFontSize * 0.35,
                                    titleFontSize,
                                    titleFontSize * 0.2,
                                  ),
                                  child: Text(
                                    DateFormat('yy년 MM월 dd일')
                                        .format(target.diary_date),
                                    style: TextStyle(
                                      fontSize: titleFontSize,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              recommendCard(
                                  emotion: target.diary_emotion,
                                  leisureName: target.diary_leisure,
                                  leisureDescription: target.leisure_ment,
                                  targetDate: target.diary_date,
                                  viewDiary: widget.viewDiary,
                                  titleFontSize: titleFontSize,
                                  img_path: target.img_path),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class recommendCard extends StatelessWidget {
  recommendCard(
      {super.key,
      required this.emotion,
      required this.titleFontSize,
      this.leisureName = '하리보 전시회',
      this.leisureDescription = '대충 하리보 전시회 설명',
      // this.annotation = '스트레스가 어쩌/구\n관리가 필요한 머쩌구',
      this.imageLocation = 'assets/Haribo.png',
      this.img_path = 'default.png',
      this.viewDiary = garbage,
      targetDate})
      : targetDate = (targetDate ?? DateTime.now());
  String img_path;
  Function viewDiary;
  final double titleFontSize;
  String leisureName;
  String leisureDescription;
  String imageLocation;
  DateTime targetDate;
  String emotion;
  String annotation = '';
  setAnnotation() {
    switch (emotion) {
      case '행복':
        annotation = '행복이 느껴지는 하루에요!\n$leisureName을 해보는 거 어때요?';
        break;
      case '슬픔':
        annotation = '슬픔이 느껴지는 하루에요!\n$leisureName을 해보는 거 어때요?';
        break;
      case '분노':
        annotation = '분노가 느껴지는 하루에요!\n$leisureName을 해보는 거 어때요?';
        break;
      case '당황':
        annotation = '당황이 느껴지는 하루에요!\n$leisureName을 해보는 거 어때요?';
        break;
      case '혐오':
        annotation = '혐오가 느껴지는 하루에요!\n$leisureName을 해보는 거 어때요?';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    setAnnotation();
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: titleFontSize,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(titleFontSize),
          ),
          color: Theme.of(context).primaryColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              blurRadius: 5.0,
              spreadRadius: 1.0,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(titleFontSize),
              child: Text(
                annotation,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(titleFontSize),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(titleFontSize),
                child: Row(
                  children: [
                    Image.network(
                      '${RestAPI.imgPath}$img_path',
                      width: 84,
                      height: 118,
                      fit: BoxFit.fill,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: titleFontSize),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            leisureName,
                            style: TextStyle(
                              fontSize: titleFontSize,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Text(
                              leisureDescription,
                              maxLines: 3,
                              style: const TextStyle(
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.height * 0.035,
                            child: TextButton(
                              onPressed: () {
                                viewDiary(targetDate);
                              },
                              style: TextButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor),
                              child: const Text(
                                '분석 결과 보기',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
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
          ],
        ),
      ),
    );
  }
}
