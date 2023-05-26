import 'package:intl/intl.dart';

class SignupUser {
  int user_id;
  String user_name;
  String user_email;
  String user_phone;
  String user_passwd;
  String user_gender;
  DateTime user_birthday;

  SignupUser(
    this.user_id,
    this.user_name,
    this.user_email,
    this.user_phone,
    this.user_passwd,
    this.user_gender,
    this.user_birthday,
  );

  Map<String, dynamic> toJson() => {
        'user_id': user_id.toString(),
        'user_name': user_name,
        'user_email': user_email,
        'user_phone': user_phone,
        'user_passwd': user_passwd,
        'user_gender': user_gender,
        'user_birthday': (DateFormat('yyyy-MM-dd')).format(user_birthday),
      };
}

class loginUser {
  String user_id;
  String user_passwd;

  loginUser(
    this.user_id,
    this.user_passwd,
  );

  Map<String, dynamic> toJson() => {
        'user_id': user_id,
        'user_passwd': user_passwd,
      };
}

class sendUser {
  String userId = '';

  sendUser(
    this.userId,
  );

  Map<String, dynamic> toJson() => {
        'userId': userId,
      };
}
