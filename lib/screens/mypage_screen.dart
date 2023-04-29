import 'package:flutter/material.dart';

class myPage extends StatefulWidget {
  const myPage({
    super.key,
  });

  @override
  State<myPage> createState() => _mypage_screState();
}

class _mypage_screState extends State<myPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      // 키보드 나왔을 때 처리 화면 가려지는 거 방지용
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              // color: Theme.of(context).primaryColor,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(25),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.person_pin,
                        color: Colors.white,
                        size: 50,
                      ),
                      Text(
                        '샤프님은',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        '일반 회원이에요',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Container(
              color: Colors.red,
              margin: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.height * 0.05,
                  MediaQuery.of(context).size.height * 0.20,
                  MediaQuery.of(context).size.height * 0.05,
                  MediaQuery.of(context).size.height * 0.05),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      child: Row(
                        children: [
                          const recordInfo(cnt: 52, title: '총 일기'),
                          VerticalDivider(
                              thickness: 1,
                              width: 1,
                              color: Theme.of(context).dividerColor),
                          const recordInfo(cnt: 7, title: '뭐 할까'),
                          const recordInfo(cnt: 10, title: '뭐 하징'),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Card(
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                              ),
                              padding:
                                  const EdgeInsets.fromLTRB(30, 15, 30, 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    '프리미엄 회원 되기',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '광고 제거, 다이어리 스티커 제공',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Card(
                      child: Column(
                        children: [
                          const changeInfo(
                            ico: Icons.person_outline_outlined,
                            info: "아이디 변경",
                          ),
                          Divider(
                            thickness: 1,
                            height: 1,
                            color: Theme.of(context).dividerColor,
                          ),
                          const changeInfo(
                            ico: Icons.email_outlined,
                            info: "이메일변경",
                          ),
                          Divider(
                            thickness: 1,
                            height: 1,
                            color: Theme.of(context).dividerColor,
                          ),
                          const changeInfo(
                            ico: Icons.local_phone_outlined,
                            info: "휴대폰번호 변경",
                          ),
                          Divider(
                            thickness: 1,
                            height: 1,
                            color: Theme.of(context).dividerColor,
                          ),
                          const changeInfo(
                            ico: Icons.vpn_key_outlined,
                            info: "패스워드 변경",
                          ),
                          Divider(
                            thickness: 1,
                            height: 1,
                            color: Theme.of(context).dividerColor,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Card(
                      child: Column(
                        children: [
                          const changeInfo(
                            ico: Icons.backup_outlined,
                            info: "데이터 백업하기",
                          ),
                          Divider(
                            thickness: 1,
                            height: 1,
                            color: Theme.of(context).dividerColor,
                          ),
                          const changeInfo(
                            ico: Icons.cloud_download_outlined,
                            info: "데이터 복원하기",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Card(
                      child: Column(
                        children: const [
                          changeInfo(
                            ico: Icons.library_books_outlined,
                            info: "데이터 내보내기",
                          ),
                        ],
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
  }
}

class recordInfo extends StatelessWidget {
  final int cnt;
  final String title;
  const recordInfo({
    super.key,
    required this.cnt,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Text(
              '$cnt',
              style: const TextStyle(
                  color: Color.fromRGBO(124, 124, 124, 1), fontSize: 20),
            ),
            Text(
              title,
              style: const TextStyle(
                  color: Color.fromRGBO(124, 124, 124, 1), fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}

class changeInfo extends StatelessWidget {
  final String info;
  final IconData ico;
  const changeInfo({
    super.key,
    required this.info,
    required this.ico,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(info);
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(1, 255, 255, 255),
        ),
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Icon(
              ico,
              size: 30,
              color: const Color.fromRGBO(124, 124, 124, 1),
            ),
            Text(
              info,
              style: const TextStyle(
                  color: Color.fromRGBO(124, 124, 124, 1), fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
