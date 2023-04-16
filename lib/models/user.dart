class User {
  int user_id;
  String user_name;
  String user_email;
  String user_phone;
  String user_passwd;

  User(this.user_id, this.user_name, this.user_email, this.user_phone,
      this.user_passwd);

  Map<String, dynamic> toJson() => {
        'user_id': user_id.toString(),
        'user_name': user_name,
        'user_email': user_email,
        'user_phone': user_phone,
        'user_passwd': user_passwd,
      };
}
