import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_masked_formatter/multi_masked_formatter.dart';
import 'package:sumpyo/models/user.dart';
import 'package:sumpyo/widgets/loginWidget.dart';
import 'package:http/http.dart' as http;

import '../apis/api.dart';

class signUpPage extends StatefulWidget {
  const signUpPage({super.key});

  @override
  State<signUpPage> createState() => _signUppageState();
}

class _signUppageState extends State<signUpPage> {
  var formKey = GlobalKey<FormState>();

  var userNameController = TextEditingController();
  var emailInputed = '';
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordCheckController = TextEditingController();
  var ageController = TextEditingController();
  var genderController = TextEditingController();

  checkUserEmail() async {
    try {
      var response = await http.post(Uri.parse(API.validateName),
          body: {'user_name': userNameController.text.trim()});

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);

        if (responseBody['existName'] == true) {
          Fluttertoast.showToast(
            msg: "이미 존재하는 사용자 이름입니다.",
          );
        } else {
          saveInfo();
        }
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  saveInfo() async {
    User userModel = User(1, userNameController.text.trim(), emailInputed,
        phoneController.text.trim(), passwordController.text.trim());
    try {
      var res =
          await http.post(Uri.parse(API.signUp), body: userModel.toJson());
      if (res.statusCode == 200) {
        var resSignup = jsonDecode(res.body);
        if (resSignup['success'] == true) {
          Fluttertoast.showToast(msg: 'Signup successfully');
          setState(() {
            userNameController.clear();
            emailController.clear();
            passwordController.clear();
          });
        } else {
          Fluttertoast.showToast(msg: 'Error occurred. Please try again');
        }
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));
    double contentHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        // backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: contentHeight,
            child: Stack(
              children: [
                const loginBackground(),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width * 0.05,
                      MediaQuery.of(context).size.height * 0.21,
                      MediaQuery.of(context).size.width * 0.05,
                      MediaQuery.of(context).size.height * 0.05),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    color: Colors.white,
                    child: GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              '회원가입',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w300,
                                  color: Theme.of(context).primaryColor),
                            ),
                            loginTextbox(
                              icon: const Icon(Icons.account_circle_outlined),
                              dataType: '아이디',
                            ),
                            emailTextbox(
                              emailController: emailController,
                            ),
                            const phoneTextbox(),
                            loginTextbox(
                              icon: const Icon(Icons.key),
                              dataType: '비밀번호',
                            ),
                            loginTextbox(
                              icon: const Icon(Icons.key),
                              dataType: '비밀번호 확인',
                            ),
                            const submitSignUp()
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class submitSignUp extends StatelessWidget {
  const submitSignUp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side:
                  BorderSide(color: Theme.of(context).primaryColor, width: 2)),
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
    );
  }
}

class emailTextbox extends StatefulWidget {
  var emailController;
  emailTextbox({super.key, required this.emailController});

  @override
  State<emailTextbox> createState() => _emailTextboxState();
}

class _emailTextboxState extends State<emailTextbox> {
  final List<String> _emailList = ['google.com', 'naver.com', 'hanmail.net'];
  String _selectedValue = 'google.com';
  @override
  Widget build(BuildContext context) {
    String email = widget.emailController.text + '@' + _selectedValue;
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom:
                  BorderSide(width: 1.5, color: Colors.grey.withOpacity(0.4)))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(Icons.email_outlined),
          Flexible(
            child: TextFormField(
              controller: widget.emailController,
              inputFormatters: [
                FilteringTextInputFormatter(RegExp("[a-z|0-9]"), allow: true),
              ],
              decoration: const InputDecoration(
                  hintText: '이메일', border: InputBorder.none, labelText: '이메일'),
            ),
          ),
          const Icon(Icons.alternate_email),
          DropdownButton(
            value: _selectedValue,
            items: _emailList.map((value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedValue = value!;
              });
            },
          ),
        ],
      ),
    );
  }
}

class phoneTextbox extends StatefulWidget {
  const phoneTextbox({super.key});

  @override
  State<phoneTextbox> createState() => _phoneTextboxState();
}

class _phoneTextboxState extends State<phoneTextbox> {
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
          const Icon(Icons.phone_android_rounded),
          Flexible(
              child: TextField(
            inputFormatters: [
              MultiMaskedTextInputFormatter(
                  masks: ['xxx-xxxx-xxxx', 'xxx-xxx-xxxx'], separator: '-'),
            ],
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                labelText: '휴대전화', border: InputBorder.none),
          )),
        ],
      ),
    );
  }
}
