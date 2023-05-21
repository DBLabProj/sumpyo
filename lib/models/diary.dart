import 'package:intl/intl.dart';

class Diary {
  int diary_id;
  String user_name;
  String diary_title;
  String diary_content;
  DateTime diary_date;
  String diary_emotion;
  int diary_happiness;
  int diary_sadness;
  int diary_disgust;
  int diary_embarrassment;
  int diary_anger;
  // String diary_recommend;
  // int diary_stress;

  Diary(
    this.diary_id,
    this.user_name,
    this.diary_title,
    this.diary_content,
    this.diary_date,
    this.diary_emotion,
    this.diary_happiness,
    this.diary_sadness,
    this.diary_disgust,
    this.diary_embarrassment,
    this.diary_anger,
    // this.diary_recommend,
    // this.diary_stress,
  );

  Diary.fromJson(Map<String, dynamic> json)
      : diary_id = json['diary_id'],
        user_name = json['user_name'],
        diary_title = json['diary_title'],
        diary_content = json['diary_content'],
        diary_date = DateTime.parse(json['diary_date']),
        diary_emotion = json['diary_emotion'],
        diary_happiness = json['diary_happiness'],
        diary_sadness = json['diary_sadness'],
        diary_disgust = json['diary_disgust'],
        diary_embarrassment = json['diary_embarrassment'],
        diary_anger = json['diary_anger'];

  Map<String, dynamic> toJson() => {
        'diary_id': diary_id.toString(),
        'user_name': user_name,
        'diary_title': diary_title,
        'diary_content': diary_content,
        'diary_date': (DateFormat('yyyy-MM-dd')).format(diary_date),
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

class emotionData {
  emotionData(this.labledEmotion, this.frequency);
  final String labledEmotion;
  final double frequency;
}
