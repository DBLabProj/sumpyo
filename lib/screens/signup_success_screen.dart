import 'package:flutter/material.dart';
import 'package:sumpyo/screens/login_screen.dart';
import 'package:sumpyo/widgets/loginWidget.dart';

class signupSuccessScreen extends StatelessWidget {
  double cardHeight = 0.0;
  double cardWidth = 0.0;
  signupSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    cardHeight = MediaQuery.of(context).size.height * 0.69;
    cardWidth = MediaQuery.of(context).size.width * 0.82;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const loginBackground(),
            Padding(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.05,
                MediaQuery.of(context).size.height * 0.21,
                MediaQuery.of(context).size.width * 0.05,
                MediaQuery.of(context).size.height * 0.1,
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: cardHeight * 0.15,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 2.0,
                                        color: Colors.grey.withOpacity(0.4)))),
                            child: Text(
                              '회원가입',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w300,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                        const Text('회원가입이 완료되었습니다.'),
                        SizedBox(
                          width: cardWidth * 0.9,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/', (_) => false);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const loginScreen()),
                              );
                            },
                            child: const Text('완료'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
