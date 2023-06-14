import 'package:flutter/material.dart';

class loginBackground extends StatelessWidget {
  const loginBackground({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

// ------------------------------------입력 상자 -------------------------------------------------
class loginTextbox extends StatelessWidget {
  Icon icon;
  String dataType;
  TextEditingController controller;
  loginTextbox(
      {super.key,
      required this.icon,
      required this.dataType,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        obscureText: dataType != '아이디' ? true : false,
        decoration: InputDecoration(
          labelText: dataType,
          prefixIcon: icon,
          // enabledBorder: UnderlineInputBorder(
          //     borderSide: BorderSide(color: Theme.of(context).primaryColor)),
        ));
  }
}
