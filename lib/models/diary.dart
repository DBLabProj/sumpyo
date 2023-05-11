import 'package:intl/intl.dart';

class Diary {
  int diary_id;
  String user_name;
  String diary_title;
  String diary_content;
  DateTime diary_date;

  Diary(
    this.diary_id,
    this.user_name,
    this.diary_title,
    this.diary_content,
    this.diary_date,
  );

  Diary.fromJson(Map<String, dynamic> json)
      : diary_id = json['diaryId'],
        user_name = json['userName'],
        diary_title = json['diaryTitle'],
        diary_content = json['diaryContent'],
        diary_date = DateTime.parse(json['diaryDate']);

  Map<String, dynamic> toJson() => {
        'user_id': diary_id.toString(),
        'user_name': user_name,
        'user_email': user_name,
        'user_phone': diary_title,
        'user_passwd': diary_content,
        'user_birthday': (DateFormat('yyyy-MM-dd')).format(diary_date),
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
