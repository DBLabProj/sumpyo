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

var userIdController = TextEditingController();
var domainName = 'google.com';
var emailController = TextEditingController();
var phoneController = TextEditingController();
var nicknameController = TextEditingController();
var pwController = TextEditingController();
var pwCheckController = TextEditingController();
var birthdayController = DateTime.now();
var genderController = '';
changeBrithday(DateTime birthday) {
  birthdayController = birthday;
}

changeGender(int index) {
  index == 0 ? genderController = '남성' : genderController = '여성';
}

changeDomain(String domain) {
  domainName = domain;
}

class signUpPage extends StatefulWidget {
  const signUpPage({super.key});

  @override
  State<signUpPage> createState() => _signUppageState();
}

class _signUppageState extends State<signUpPage> {
  var formKey = GlobalKey<FormState>();
  bool isSecondPage = false;

  checkUsername() async {
    saveInfo();
    // try {
    //   var response = await http.post(Uri.parse(API.validateName),
    //       body: {'user_name': userNameController.text.trim()});

    //   if (response.statusCode == 200) {
    //     var responseBody = jsonDecode(response.body);

    //     if (responseBody['existName'] == true) {
    //       Fluttertoast.showToast(
    //         msg: "이미 존재하는 사용자 이름입니다.",
    //       );
    //     } else {
    //       saveInfo();
    //     }
    //   }
    // } catch (e) {
    //   print(e.toString());
    //   Fluttertoast.showToast(msg: e.toString());
    // }
  }

  saveInfo() async {
    SignupUser userModel = SignupUser(
      1,
      userIdController.text.trim(),
      userIdController.text.trim(),
      '${emailController.text.trim()}@${domainName.trim()}',
      phoneController.text.trim(),
      pwController.text.trim(),
      genderController,
      birthdayController,
    );
    print(userModel.toJson());
    try {
      var res = await http.post(Uri.parse(RestAPI.signup),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(userModel.toJson()));
      if (res.statusCode == 200) {
        var resSignup = jsonDecode(res.body);
        if (resSignup['result'] == 'Success') {
          Fluttertoast.showToast(msg: 'Signup successfully');
          setState(() {
            userIdController.clear();
            emailController.clear();
            pwController.clear();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => signupSuccessScreen(),
              ),
            );
          });
        } else {
          if (resSignup['result'] == 'Already') {
            Fluttertoast.showToast(msg: '이미 존재하는 사용자명입니다.');
          } else {
            Fluttertoast.showToast(msg: 'Error occurred. Please try again');
          }
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
        elevation: 0.0,
        toolbarHeight: 0,
        backgroundColor: Theme.of(context).primaryColor,
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
                            signupIdBox(
                              icon: const Icon(Icons.account_circle_outlined),
                              controller: userIdController,
                            ),
                            signupNickBox(
                              controller: nicknameController,
                            ),
                            signupPwBox(
                              pwController: pwController,
                              pwCheckController: pwCheckController,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () =>
                                    Navigator.pushNamed(context, '/signup/sec'),
                                child: const Text('다음'),
                              ),
                            ),
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

// 회원가입 제출
class submitSignUp extends StatelessWidget {
  // String domain;
  // Function checkUsername;
  const submitSignUp({
    super.key,
    // required this.domain,
    // required this.checkUsername,
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
        // checkUsername();
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
  // var emailController;
  // Function changeDomain;
  const emailTextbox({
    super.key,
    // required this.emailController,
    // required this.changeDomain,
  });

  @override
  State<emailTextbox> createState() => _emailTextboxState();
}

class _emailTextboxState extends State<emailTextbox> {
  final List<String> _emailList = ['google.com', 'naver.com', 'hanmail.net'];
  String _selectedValue = 'google.com';
  @override
  Widget build(BuildContext context) {
    String email = '${emailController.text}@$_selectedValue';
    return TextFormField(
      controller: emailController,
      inputFormatters: [
        FilteringTextInputFormatter(RegExp("[a-z|0-9]"), allow: true),
      ],
      decoration: InputDecoration(
        hintText: '이메일',
        labelText: '이메일',
        prefixIcon: const Icon(
          Icons.email_outlined,
          color: Colors.black,
        ),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.alternate_email_rounded,
              color: Colors.black,
            ),
            const SizedBox(
              width: 8,
            ),
            DropdownButton(
              underline: const SizedBox.shrink(),
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
                  changeDomain(value);
                });
              },
            ),
          ],
        ),
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
    return TextField(
      controller: widget.phoneController,
      inputFormatters: [
        MultiMaskedTextInputFormatter(
            masks: ['xxx-xxxx-xxxx', 'xxx-xxx-xxxx'], separator: '-'),
      ],
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: '휴대전화',
        prefixIcon: Icon(
          Icons.phone_android_rounded,
          color: Colors.black,
        ),
      ),
    );
  }
}

// 성별 버튼
class genderSelectButton extends StatefulWidget {
  // Function genderChange;
  const genderSelectButton({
    super.key,
    // required this.genderChange,
  });

  @override
  State<genderSelectButton> createState() => _genderSelectButtonState();
}

class _genderSelectButtonState extends State<genderSelectButton> {
  final List<String> _genderList = ['남성', '여성'];
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
              underline: const SizedBox.shrink(),
              value: _selectedValue,
              hint: const Text('성별'),
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
  // Function changeBrithday;
  const brithdaySelector({
    super.key,
    // required this.changeBrithday,
  });

  @override
  State<brithdaySelector> createState() => _brithdaySelectorState();
}

class _brithdaySelectorState extends State<brithdaySelector> {
  final TextEditingController _BirthdayController =
      TextEditingController(text: DateTime.now().toString());
  DateTime brithday = DateTime.now();
  // String _selectedDate = '';
  DateTime? tempPickedDate;
  DateTime _selectedDate = DateTime.now();
  _selectDate() async {
    DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      backgroundColor: ThemeData.light().scaffoldBackgroundColor,
      context: context,
      builder: (context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButton(
                      child: const Text('취소'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    CupertinoButton(
                      child: const Text('완료'),
                      onPressed: () {
                        Navigator.of(context).pop(tempPickedDate);
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ],
                ),
              ),
              const Divider(
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
              decoration: const InputDecoration(
                isDense: true,
              ),
              controller: _BirthdayController,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
      ],
    );
  }
}

class firstPage extends StatefulWidget {
  // Function changePage;
  // TextEditingController idController;
  // TextEditingController pwController;
  // TextEditingController pwCheckController;
  const firstPage({
    super.key,
    // required this.changePage,
    // required this.idController,
    // required this.pwController,
    // required this.pwCheckController,
  });

  @override
  State<firstPage> createState() => _firstPageState();
}

class _firstPageState extends State<firstPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}

// 다음 화면(두번째)
class secondPage extends StatefulWidget {
  // String domain;

  const secondPage({
    super.key,
  });

  @override
  State<secondPage> createState() => _secondPageState();
}

class _secondPageState extends State<secondPage> {
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
        elevation: 0.0,
        toolbarHeight: 0,
        backgroundColor: Theme.of(context).primaryColor,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Icon(Icons.arrow_back_ios)),
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
                            const emailTextbox(
                                // emailController: emailController,
                                // changeDomain: changeDomain,
                                ),
                            phoneTextbox(
                              phoneController: phoneController,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: const genderSelectButton(
                                      // genderChange: widget.changeGender,
                                      ),
                                ),
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: const brithdaySelector(
                                        // changeBrithday: widget.changeBrithday,
                                        )),
                              ],
                            ),
                            const submitSignUp(
                                // checkUsername: widget.checkUsername,
                                )
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

// 회원가입 아이디
class signupIdBox extends StatefulWidget {
  Icon icon;
  TextEditingController controller;
  signupIdBox({
    super.key,
    this.icon = const Icon(Icons.account_circle_outlined),
    required this.controller,
  });

  @override
  State<signupIdBox> createState() => _signupIdBoxState();
}

class _signupIdBoxState extends State<signupIdBox> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      inputFormatters: [
        FilteringTextInputFormatter(RegExp("[a-z|0-9]"), allow: true),
      ],
      decoration: InputDecoration(
          labelText: '아이디',
          prefixIcon: widget.icon,
          suffixIcon: ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll(Theme.of(context).primaryColor),
            ),
            child: const Text('중복 확인'),
          )),
    );
  }
}

// 회원가입 비밀번호
class signupPwBox extends StatefulWidget {
  TextEditingController pwController;
  TextEditingController pwCheckController;
  signupPwBox({
    super.key,
    required this.pwController,
    required this.pwCheckController,
  });

  @override
  State<signupPwBox> createState() => _signupPwBoxState();
}

class _signupPwBoxState extends State<signupPwBox> {
  bool isDiff = true;
  Image keyImg = Image.asset('assets/pwImage.png');
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextFormField(
          obscureText: true,
          controller: widget.pwController,
          decoration: InputDecoration(prefixIcon: keyImg, labelText: '비밀번호'),
        ),
        TextFormField(
            obscureText: true,
            controller: widget.pwCheckController,
            decoration:
                InputDecoration(prefixIcon: keyImg, labelText: '비밀번호 확인'),
            onChanged: (value) {
              if (widget.pwCheckController.text != widget.pwController.text) {
                setState(() {
                  isDiff = true;
                });
              } else {
                setState(
                  () {
                    isDiff = false;
                  },
                );
              }
            }),
        isDiff
            ? const Text(
                '* 비밀번호가 일치하지 않습니다',
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.end,
              )
            : const Text(''),
      ],
    );
  }
}

class signupNickBox extends StatelessWidget {
  TextEditingController controller;
  signupNickBox({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.admin_panel_settings_rounded),
        // hintText: '닉네임',
        labelText: '닉네임',
      ),
      controller: controller,
    );
  }
}
