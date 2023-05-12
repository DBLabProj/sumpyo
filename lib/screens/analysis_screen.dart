import 'package:flutter/material.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  final GlobalKey contentKey = GlobalKey();
  double titleFontSize = 20.0;
  double containerHeight = 100.0;
  double screenSize = 0.0;

  double getContentSize() {
    RenderBox calBox =
        contentKey.currentContext!.findRenderObject() as RenderBox;
    Size size = calBox.size;
    return size.height;
  }

  @override
  void initState() {
    super.initState();

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
        key: contentKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                alignment: Alignment.bottomLeft,
                height: titleFontSize * 4,
                child: Text(
                  '오늘의 분석이\n완료되었어요!',
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
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 2,
                            ),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width * 0.885,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            titleFontSize * 0.25,
                            titleFontSize * 0.35,
                            titleFontSize,
                            titleFontSize * 0.2,
                          ),
                          child: Text(
                            '오늘',
                            style: TextStyle(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Padding(
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
                                  '스트레스가 어쩌구\n관리가 필요한 머쩌구',
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
                                      Image.asset('assets/Haribo.png'),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: titleFontSize),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '하리보 전시회',
                                              style: TextStyle(
                                                fontSize: titleFontSize,
                                              ),
                                            ),
                                            const Text(
                                              '대충 하리보 전시회 설명',
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            TextButton(
                                              onPressed: () {},
                                              style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .primaryColor),
                                              child: const Text(
                                                '분석 결과 보기',
                                                style: TextStyle(
                                                  color: Colors.white,
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
