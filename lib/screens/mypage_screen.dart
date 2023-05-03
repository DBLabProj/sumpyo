import 'package:flutter/material.dart';
import 'package:sumpyo/screens/edit_account_info.dart';
import 'package:sumpyo/screens/manageData.dart';

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
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                // color: Theme.of(context).primaryColor,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(25),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.height * 0.05,
                    MediaQuery.of(context).size.height * 0.025,
                    MediaQuery.of(context).size.height * 0.05,
                    MediaQuery.of(context).size.height * 0.05),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.account_circle,
                            color: Colors.white,
                            size: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              children: const [
                                Text(
                                  '샤프님은',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  '일반 회원이에요',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      child: Row(
                        children: [
                          recordInfo(
                            cnt: 52,
                            title: '총 일기',
                          ),
                          recordInfo(
                            cnt: 7,
                            title: '더미 1',
                          ),
                          recordInfo(
                            cnt: 10,
                            title: '더미 2',
                            isRight: true,
                          ),
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
                                      fontSize: 12,
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
                          changeInfo(
                            ico: Icons.person_outline_outlined,
                            info: "아이디",
                          ),
                          changeInfo(
                            ico: Icons.email_outlined,
                            info: "이메일",
                          ),
                          changeInfo(
                            ico: Icons.local_phone_outlined,
                            info: "휴대폰번호",
                          ),
                          changeInfo(
                            ico: Icons.vpn_key_outlined,
                            info: "패스워드",
                            isBottoom: true,
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
                          dataIO(
                            ico: Icons.backup_outlined,
                            info: "데이터 백업하기",
                          ),
                          dataIO(
                            ico: Icons.cloud_download_outlined,
                            info: "데이터 복원하기",
                            isBottoom: true,
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
                          dataIO(
                            ico: Icons.library_books_outlined,
                            info: "데이터 내보내기",
                            isBottoom: true,
                          ),
                        ],
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

class recordInfo extends StatelessWidget {
  final int cnt;
  final String title;
  bool isRight;
  recordInfo({
    super.key,
    required this.cnt,
    required this.title,
    this.isRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
              right: !isRight
                  ? BorderSide(color: Theme.of(context).dividerColor)
                  : BorderSide.none),
          color: const Color.fromARGB(1, 255, 255, 255),
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Text(
              '$cnt',
              style: const TextStyle(
                color: Color.fromRGBO(124, 124, 124, 1),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                color: Color.fromRGBO(124, 124, 124, 1),
                fontSize: 15,
              ),
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
  bool isBottoom;
  changeInfo({
    super.key,
    required this.info,
    required this.ico,
    this.isBottoom = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => editAccount(
              dataType: info,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
              bottom: !isBottoom
                  ? BorderSide(
                      color: Theme.of(context).dividerColor,
                    )
                  : BorderSide.none),
          color: const Color.fromARGB(1, 255, 255, 255),
        ),
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Icon(
              ico,
              size: 30,
              color: const Color.fromRGBO(124, 124, 124, 1),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Row(
                children: [
                  Text(
                    '$info 변경',
                    style: const TextStyle(
                      color: Color.fromRGBO(124, 124, 124, 1),
                      fontSize: 17,
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

class dataIO extends StatelessWidget {
  final String info;
  final IconData ico;
  bool isBottoom;
  dataIO({
    super.key,
    required this.info,
    required this.ico,
    this.isBottoom = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ManageData(
              dataType: info,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
              bottom: !isBottoom
                  ? BorderSide(
                      color: Theme.of(context).dividerColor,
                    )
                  : BorderSide.none),
          color: const Color.fromARGB(1, 255, 255, 255),
        ),
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Icon(
              ico,
              size: 30,
              color: const Color.fromRGBO(124, 124, 124, 1),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Text(
                info,
                style: const TextStyle(
                  color: Color.fromRGBO(124, 124, 124, 1),
                  fontSize: 17,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
