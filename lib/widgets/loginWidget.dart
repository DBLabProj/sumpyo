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
