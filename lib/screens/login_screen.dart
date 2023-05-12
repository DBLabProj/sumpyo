import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sumpyo/apis/api.dart';
import 'package:sumpyo/main.dart';
import 'package:sumpyo/models/user.dart';
import 'package:sumpyo/screens/signup_screen.dart';
import 'package:sumpyo/widgets/loginWidget.dart';
import 'package:http/http.dart' as http;

class loginScreen extends StatefulWidget {
  // Function kill;
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  TextEditingController idController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  dynamic userInfo = '';

  static const storage = FlutterSecureStorage();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    userInfo = await storage.read(key: 'login');
    // user의 정보가 있다면 로그인 후 들어가는 첫 페이지로 넘어가게 합니다.
    if (userInfo != null) {
      var user = jsonDecode(userInfo);
      idController.text = user['user_id'];
      pwController.text = user['user_passwd'];
      login();
    } else {
      print('로그인이 필요합니다');
    }
  }

  login() async {
    if (idController.text.trim().isNotEmpty) {
      loginUser user = loginUser(idController.text, pwController.text);
      try {
        var res = await http.post(Uri.parse(RestAPI.login),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(user.toJson()));
        if (res.statusCode == 200) {
          var resSignup = jsonDecode(res.body);
          if (resSignup['result'] == 'Success') {
            var account = jsonEncode({
              'user_id': idController.text,
              'user_passwd': pwController.text
            });
            await storage.write(key: 'login', value: account);
            print(storage.read(key: 'login'));
            Fluttertoast.showToast(msg: 'login successfully');
            setState(() {
              idController.clear();
              pwController.clear();
            });
            Navigator.push(
                context, MaterialPageRoute(builder: (content) => const App()));
          } else if (resSignup['result'] == 'Failed.') {
            Fluttertoast.showToast(msg: '아이디와 비밀번호를 확인해주세요.');
          } else {
            Fluttertoast.showToast(msg: 'Error occurred. Please try again');
          }
        }
      } catch (e) {
        print(e.toString());
        Fluttertoast.showToast(msg: e.toString());
      }
    } else {
      Fluttertoast.showToast(msg: '아이디를 입력해주세요.');
    }
  }

  @override
  Widget build(BuildContext context) {
    double areaWidth = MediaQuery.of(context).size.width * 0.9;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      // 키보드 나왔을 때 처리 화면 가려지는 거 방지용
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(children: [
          const loginBackground(),
          Padding(
            padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.05,
              MediaQuery.of(context).size.height * 0.25,
              MediaQuery.of(context).size.width * 0.05,
              MediaQuery.of(context).size.height * 0.1,
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              color: Colors.white,
              child: GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '로그인',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w300,
                            color: Theme.of(context).primaryColor),
                      ),
                      loginTextbox(
                        icon: const Icon(Icons.account_circle_outlined),
                        dataType: '아이디',
                        controller: idController,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      loginTextbox(
                        icon: const Icon(Icons.key),
                        dataType: '비밀번호',
                        controller: pwController,
                      ),
                      const loginToolBox(),
                      loginButton(
                        login: login,
                        parentWidth: areaWidth,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class loginToolBox extends StatefulWidget {
  const loginToolBox({super.key});

  @override
  State<loginToolBox> createState() => _loginToolBoxState();
}

class _loginToolBoxState extends State<loginToolBox> {
  bool? rememberMe = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: rememberMe,
              onChanged: ((value) {
                setState(() {
                  rememberMe = value;
                });
              }),
            ),
            const Text('정보 기억하기'),
          ],
        ),
        Row(
          children: const [
            Text('아이디 찾기'),
            Text('|'),
            Text('패스워드 찾기'),
          ],
        ),
      ],
    );
  }
}

class loginButton extends StatefulWidget {
  Function login;
  double parentWidth;
  loginButton({
    super.key,
    required this.parentWidth,
    required this.login,
  });

  @override
  State<loginButton> createState() => _loginButtonState();
}

class _loginButtonState extends State<loginButton> {
  @override
  Widget build(BuildContext context) {
    double buttonWidth = widget.parentWidth * 0.75;
    return Column(
      children: [
        SizedBox(
          width: buttonWidth,
          child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  backgroundColor:
                      MaterialStatePropertyAll(Theme.of(context).primaryColor)),
              onPressed: () {
                widget.login();
              },
              child: const Text(
                '로그인',
                style: TextStyle(),
              )),
        ),
        SizedBox(
          width: buttonWidth,
          child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                        color: Theme.of(context).primaryColor, width: 2)),
              ),
              backgroundColor: const MaterialStatePropertyAll(Colors.white),
            ),
            onPressed: () {
              Navigator.push((context),
                  MaterialPageRoute(builder: (context) => const signUpPage()));
            },
            child: Text(
              '회원가입',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
