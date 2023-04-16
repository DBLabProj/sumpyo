import 'package:flutter/material.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  @override
  Widget build(BuildContext context) {
    double areaWidth = MediaQuery.of(context).size.width * 0.9;
    return Scaffold(
      // 키보드 나왔을 때 처리 화면 가려지는 거 방지용
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            // color: Theme.of(context).primaryColor,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(25)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/logo.png'),
                    const Text(
                      '숨표',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.05,
                MediaQuery.of(context).size.height * 0.21,
                MediaQuery.of(context).size.width * 0.05,
                MediaQuery.of(context).size.height * 0.1),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              color: Colors.white,
              child: GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
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
                          dataType: '아이디'),
                      const SizedBox(
                        height: 30,
                      ),
                      loginTextbox(
                          icon: const Icon(Icons.key), dataType: '비밀번호'),
                      const loginToolBox(),
                      loginButton(
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

class loginTextbox extends StatefulWidget {
  Icon icon;
  String dataType;
  loginTextbox({super.key, required this.icon, required this.dataType});

  @override
  State<loginTextbox> createState() => _loginTextboxState();
}

class _loginTextboxState extends State<loginTextbox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom:
                  BorderSide(width: 1.5, color: Colors.grey.withOpacity(0.4)))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          widget.icon,
          Flexible(
            child: TextField(
              obscureText: widget.dataType != '아이디' ? true : false,
              decoration: InputDecoration(
                  labelText: widget.dataType, border: InputBorder.none),
            ),
          ),
        ],
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
        Checkbox(
            value: rememberMe,
            onChanged: ((value) {
              setState(() {
                rememberMe = value;
              });
            })),
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
  double parentWidth;
  loginButton({super.key, required this.parentWidth});

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
              onPressed: () {},
              child: const Text(
                '로고인',
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
            onPressed: () {},
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
