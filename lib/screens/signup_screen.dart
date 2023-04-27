import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:multi_masked_formatter/multi_masked_formatter.dart';
import 'package:sumpyo/models/user.dart';
import 'package:sumpyo/screens/signup_success_screen.dart';
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
  bool isSecondPage = false;
  var userNameController = TextEditingController();
  var domainName = 'google.com';
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var pwController = TextEditingController();
  var pwCheckController = TextEditingController();
  var birthdayController = DateTime.now();
  var genderController = '';

  changeBrithday(DateTime birthday) {
    birthdayController = birthday;
  }

  changeGender(int index) {
    if (index == 0) {
      setState(() {
        genderController = '남성';
      });
    } else {
      setState(() {
        genderController = '여성';
      });
    }
  }

  changeDomain(String domain) {
    setState(() {
      domainName = domain;
    });
  }

  changePage() {
    setState(() {
      isSecondPage = !isSecondPage;
    });
  }

  checkUsername() async {
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
    User userModel = User(
      1,
      userNameController.text.trim(),
      '${emailController.text.trim()}@${domainName.trim()}',
      phoneController.text.trim(),
      pwController.text.trim(),
      genderController,
      birthdayController,
    );
    print(userModel.toJson());
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
            pwController.clear();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => signupSuccessPage()));
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
                        child: isSecondPage
                            ? secondPage(
                                emailController: emailController,
                                changeDomain: changeDomain,
                                changeGender: changeGender,
                                changePage: changePage,
                                domain: domainName,
                                changeBrithday: changeBrithday,
                                phoneController: phoneController,
                                checkUsername: checkUsername,
                              )
                            : firstPage(
                                changePage: changePage,
                                idController: userNameController,
                                pwCheckController: pwController,
                                pwController: pwCheckController,
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

// 회원가입 제출
class submitSignUp extends StatelessWidget {
  String domain;
  Function checkUsername;
  submitSignUp({
    super.key,
    required this.domain,
    required this.checkUsername,
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
        // Navigator.push((context),
        // MaterialPageRoute(builder: (context) => const signUpPage()));
        checkUsername();
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

// 이메일
class emailTextbox extends StatefulWidget {
  var emailController;
  Function changeDomain;
  emailTextbox({
    super.key,
    required this.emailController,
    required this.changeDomain,
  });

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
                widget.changeDomain(value);
              });
            },
          ),
        ],
      ),
    );
  }
}

// 전화번호
class phoneTextbox extends StatefulWidget {
  TextEditingController phoneController;
  phoneTextbox({super.key, required this.phoneController});

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
            controller: widget.phoneController,
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

// 성별 버튼
class genderSelectButton extends StatefulWidget {
  Function genderChange;
  genderSelectButton({super.key, required this.genderChange});

  @override
  State<genderSelectButton> createState() => _genderSelectButtonState();
}

class _genderSelectButtonState extends State<genderSelectButton> {
  List<String> _genderList = ['남성', '여성'];
  String? _selectedValue;
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
          const Icon(Icons.wc),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.34,
            child: DropdownButton(
              isExpanded: true,
              underline: SizedBox.shrink(),
              value: _selectedValue != null ? _selectedValue : null,
              hint: Text('성별'),
              items: _genderList.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedValue = value!;
                  // widget.changeDomain(value);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 생일
class brithdaySelector extends StatefulWidget {
  Function changeBrithday;
  brithdaySelector({super.key, required this.changeBrithday});

  @override
  State<brithdaySelector> createState() => _brithdaySelectorState();
}

class _brithdaySelectorState extends State<brithdaySelector> {
  TextEditingController _BirthdayController =
      TextEditingController(text: '생년월일111');
  DateTime brithday = DateTime.now();
  // String _selectedDate = '';
  DateTime? tempPickedDate;
  DateTime _selectedDate = DateTime.now();
  _selectDate() async {
    DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      backgroundColor: ThemeData.light().scaffoldBackgroundColor,
      context: context,
      builder: (context) {
        return Container(
          height: 300,
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButton(
                      child: Text('취소'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    CupertinoButton(
                      child: Text('완료'),
                      onPressed: () {
                        Navigator.of(context).pop(tempPickedDate);
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ],
                ),
              ),
              Divider(
                height: 0,
                thickness: 1,
              ),
              Expanded(
                child: Container(
                  child: CupertinoDatePicker(
                    // dateOrder: DatePickerDateOrder(),
                    backgroundColor: ThemeData.light().scaffoldBackgroundColor,
                    minimumYear: 1900,
                    maximumYear: DateTime.now().year,
                    initialDateTime: DateTime.now(),
                    maximumDate: DateTime.now(),
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (DateTime dateTime) {
                      tempPickedDate = dateTime;
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _BirthdayController.text = pickedDate.toString();
        convertDateTimeDisplay(_BirthdayController.text);
      });
    }
  }

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
    final DateTime displayDate = displayFormater.parse(date);
    return _BirthdayController.text = serverFormater.format(displayDate);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.calendar_month),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              _selectDate();
            },
            child: TextFormField(
              enabled: false,
              decoration: InputDecoration(
                isDense: true,
              ),
              controller: _BirthdayController,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ],
    );
  }
}

class firstPage extends StatefulWidget {
  Function changePage;
  TextEditingController idController;
  TextEditingController pwController;
  TextEditingController pwCheckController;
  firstPage({
    super.key,
    required this.changePage,
    required this.idController,
    required this.pwController,
    required this.pwCheckController,
  });

  @override
  State<firstPage> createState() => _firstPageState();
}

class _firstPageState extends State<firstPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
          controller: widget.idController,
        ),
        loginTextbox(
          icon: const Icon(Icons.key),
          dataType: '비밀번호',
          controller: widget.pwController,
        ),
        loginTextbox(
          icon: const Icon(Icons.key),
          dataType: '비밀번호 확인',
          controller: widget.pwCheckController,
        ),
        TextButton(
          onPressed: () {
            widget.changePage();
          },
          child: const Text('다음'),
        ),
      ],
    );
  }
}

class secondPage extends StatefulWidget {
  String domain;
  Function changeDomain;
  TextEditingController emailController;
  Function changeGender;
  Function changePage;
  Function changeBrithday;
  Function checkUsername;
  TextEditingController phoneController;
  secondPage({
    super.key,
    required this.emailController,
    required this.changeDomain,
    required this.changeGender,
    required this.changePage,
    required this.domain,
    required this.changeBrithday,
    required this.phoneController,
    required this.checkUsername,
  });

  @override
  State<secondPage> createState() => _secondPageState();
}

class _secondPageState extends State<secondPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => widget.changePage(),
              child: const Text(
                '<',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Text(
              '회원가입',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w300,
                  color: Theme.of(context).primaryColor),
            ),
            const Text(
              '  ',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
          ],
        ),
        emailTextbox(
          emailController: widget.emailController,
          changeDomain: widget.changeDomain,
        ),
        phoneTextbox(
          phoneController: widget.phoneController,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: genderSelectButton(
                genderChange: widget.changeGender,
              ),
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: brithdaySelector(changeBrithday: widget.changeBrithday)),
          ],
        ),
        submitSignUp(
          domain: widget.domain,
          checkUsername: widget.checkUsername,
        )
      ],
    );
  }
}
