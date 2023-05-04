import 'package:flutter/material.dart';

class ManageData extends StatelessWidget {
  String dataType;
  ManageData({
    super.key,
    required this.dataType,
  });

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
                child: manageData(
                  dataType: dataType,
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
    return manageDataWidget(
      dataType: dataType,
    );
    // Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Padding(
    //       padding: const EdgeInsets.all(25),
    //       child: Row(
    //         children: [
    //           GestureDetector(
    //             onTap: () {
    //               Navigator.of(context).pop();
    //             },
    //             child: const Icon(
    //               Icons.navigate_before_rounded,
    //               size: 30,
    //             ),
    //           ),
    //           const SizedBox(
    //             width: 20,
    //           ),
    //           Text(
    //             dataType,
    //             style: const TextStyle(
    //               fontSize: 20,
    //               fontWeight: FontWeight.w600,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //     Padding(
    //       padding: const EdgeInsets.symmetric(
    //         horizontal: 50,
    //         vertical: 40,
    //       ),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Container(
    //             margin: const EdgeInsets.symmetric(
    //               vertical: 20,
    //             ),
    //             decoration: BoxDecoration(
    //               color: Theme.of(context).primaryColor,
    //               borderRadius: BorderRadius.circular(10),
    //             ),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 Padding(
    //                   padding: const EdgeInsets.all(10),
    //                   child: Text(
    //                     dataType,
    //                     style: const TextStyle(
    //                       color: Colors.white,
    //                       fontSize: 20,
    //                       fontWeight: FontWeight.w600,
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ],
    // );
  }
}

class manageDataWidget extends StatelessWidget {
  String dataType;
  String content;
  String currentBackUpDate;
  manageDataWidget(
      {super.key,
      required this.dataType,
      this.content = "",
      this.currentBackUpDate = ""});
  dataProcess(String datatype) {
    if (dataType == "백업하기") {
      content = "데이터를 백업합니다";
    } else if (dataType == "복원하기") {
      content = "데이터를 복원합니다";
    } else {
      content = "데이터를 내보냅니다. ";
    }
    return content;
  }

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
              Text(
                dataProcess(dataType),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
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
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          dataType,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
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
