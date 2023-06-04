import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sumpyo/apis/api.dart';
import 'package:sumpyo/screens/signup_screen.dart';
import 'package:http/http.dart' as http;

class editAccount extends StatefulWidget {
  String dataType;
  bool isEditScreen;

  editAccount({
    super.key,
    required this.dataType,
    this.isEditScreen = true,
  });

  @override
  State<editAccount> createState() => _editAccountState();
}

class _editAccountState extends State<editAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(30),
              decoration: const BoxDecoration(),
              child: Column(
                children: const [
                  Icon(
                    Icons.account_circle,
                    color: Colors.white,
                    size: 50,
                  ),
                  Text(
                    '샤프',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 5.0,
                      spreadRadius: 1,
                      offset: const Offset(0, -1),
                    )
                  ],
                ),
                child: editInfoWidget(
                  dataType: widget.dataType,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class manageData extends StatelessWidget {
  String dataType;
  manageData({
    super.key,
    required this.dataType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(25),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.navigate_before_rounded,
                  size: 30,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                dataType,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 50,
            vertical: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        dataType == "데이터 백업하기" ? "백업하기" : "복원하기",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class editInfoWidget extends StatefulWidget {
  String dataType;
  editInfoWidget({
    super.key,
    required this.dataType,
  });

  @override
  State<editInfoWidget> createState() => _editInfoWidgetState();
}

class _editInfoWidgetState extends State<editInfoWidget> {
  final storage = const FlutterSecureStorage();
  TextEditingController controller = TextEditingController();
  String userId = '';
  String colName = '';
  String value = '';
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _asyncMethod();
    });
    super.initState();
  }

  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    var userInfo = await storage.read(key: 'account');
    // user의 정보가 있다면 로그인 후 들어가는 첫 페이지로 넘어가게 합니다.
    if (userInfo != null) {
      var user = jsonDecode(userInfo);
      userId = user['user_id']!;
    } else {
      print('로그인이 필요합니다');
    }
  }

  changeUserInfo(String userId, String colName, String value) async {
    if (colName.isEmpty || value.isEmpty) {
      Fluttertoast.showToast(msg: '값을 입력해주세요.');
    } else {
      var res = await http.post(Uri.parse(RestAPI.changeUserInfo),
          body: jsonEncode(
              {'userId': userId, 'changeCol': colName, 'changeValue': value}),
          headers: {'Content-Type': 'application/json'});
      if (res.statusCode == 200) {
        var re = jsonDecode(res.body);
        if (re['result'] == 'Success') {
          Fluttertoast.showToast(
              msg: '닉네임이 $value로 성공적으로 변경되었습니다.', textColor: Colors.redAccent);
          Navigator.pop(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // dataType 변경 및 뒤로 가기 버튼
        Padding(
          padding: const EdgeInsets.all(25),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.navigate_before_rounded,
                  size: 30,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                '${widget.dataType} 변경',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        // 기존 정보 및 새로운 값 입력
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 50,
            vertical: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 기존 정보
              existingInfo(
                title: widget.dataType,
              ),
              // 새로운 정보
              newInfo(
                controller: controller,
                title: widget.dataType,
              ),
              // 제출 버튼
              GestureDetector(
                onTap: () {
                  switch (widget.dataType) {
                    case '닉네임':
                      colName = 'user_nickname';
                      break;
                    case '이메일':
                      colName = 'user_email';
                      break;
                    case '휴대전화':
                      colName = 'user_phone';
                      break;
                    case '비밀번호':
                      colName = 'user_passwd';
                      break;
                    default:
                      break;
                  }
                  changeUserInfo(userId, colName, controller.text);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "변경하기",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
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
      ],
    );
  }
}

class newInfo extends StatefulWidget {
  TextEditingController controller;
  String title;
  newInfo({
    super.key,
    required this.title,
    required this.controller,
  });

  @override
  State<newInfo> createState() => _newInfoState();
}

class _newInfoState extends State<newInfo> {
  late Widget inputBox;
  dataSet(String title) {
    if (title == "이메일") {
      setState(() {
        inputBox = const emailTextbox(
            // emailController: emailController,
            // changeDomain: changeDomain
            );
      });
    } else if (title == "닉네임") {
      setState(() {
        inputBox = signupNickBox(
          controller: widget.controller,
        );
      });
    } else if (title == "휴대폰번호") {
      setState(
        () {
          inputBox = phoneTextbox(
            phoneController: widget.controller,
          );
        },
      );
    } else {
      inputBox = signupPwBox(
        pwController: pwController,
        pwCheckController: pwCheckController,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    dataSet(widget.title);
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '새로운 ${widget.title}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: inputBox,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class existingInfo extends StatelessWidget {
  String title;
  existingInfo({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "기존 $title",
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const Text(
            "샤프",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
