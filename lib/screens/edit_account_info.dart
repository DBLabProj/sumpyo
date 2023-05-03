import 'package:flutter/material.dart';
import 'package:sumpyo/screens/signup_screen.dart';

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
                child: widget.isEditScreen
                    ? editInfoWidget(dataType: widget.dataType)
                    : manageData(
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

class editInfoWidget extends StatelessWidget {
  String dataType;
  editInfoWidget({
    super.key,
    required this.dataType,
  });

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
                '$dataType 변경',
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
                title: dataType,
              ),
              // 새로운 정보
              newInfo(
                title: dataType,
              ),
              // 제출 버튼
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
            ],
          ),
        ),
      ],
    );
  }
}

class newInfo extends StatefulWidget {
  String title;
  newInfo({
    super.key,
    required this.title,
  });

  @override
  State<newInfo> createState() => _newInfoState();
}

class _newInfoState extends State<newInfo> {
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  TextEditingController pwCheckController = TextEditingController();
  changeDomain(var value) {
    // print(value);
  }

  late Widget test;
  dataSet(String title) {
    if (title == "이메일") {
      setState(() {
        test = emailTextbox(
            emailController: emailController, changeDomain: changeDomain);
      });
    } else if (title == "아이디") {
      setState(() {
        test = TextFormField();
      });
    } else if (title == "휴대폰번호") {
      setState(
        () {
          test = phoneTextbox(
            phoneController: phoneController,
          );
        },
      );
    } else {
      test = signupPwBox(
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
                child: test,
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
