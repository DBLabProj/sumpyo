import 'package:intl/intl.dart';

class Diary {
  int diaryId;
  String user_name;
  String user_email;
  String user_phone;
  String user_passwd;
  String user_gender;
  DateTime user_birthday;

  Diary(
    this.diaryId,
    this.user_name,
    this.user_email,
    this.user_phone,
    this.user_passwd,
    this.user_gender,
    this.user_birthday,
  );

  Map<String, dynamic> toJson() => {
        'user_id': diaryId.toString(),
        'user_name': user_name,
        'user_email': user_email,
        'user_phone': user_phone,
        'user_passwd': user_passwd,
        'user_gender': user_gender,
        'user_birthday': (DateFormat('yyyy-MM-dd')).format(user_birthday),
      };
}

class uploadDiary {
  int diaryId;
  String userId;
  String diaryTitle;
  String diaryContent;
  DateTime diaryDate;
  uploadDiary(
    this.diaryId,
    this.userId,
    this.diaryTitle,
    this.diaryContent,
    this.diaryDate,
  );
  Map<String, dynamic> toJson() => {
        'diaryId': diaryId.toString(),
        'userId': userId,
        'diaryTitle': diaryTitle,
        'diaryContent': diaryContent,
        'diaryDate': (DateFormat('yyyy-MM-dd')).format(diaryDate),
      };
}
