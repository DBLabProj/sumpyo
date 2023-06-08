class API {
  static const hostConnect = 'http://203.252.240.80/api_new_members';
  static const hostConnectUser = "$hostConnect/user";

  static const signUp = "$hostConnect/user/signup.php";
  static const validateName = "$hostConnect/user/validate_name.php";
}

class RestAPI {
  static const hostConnect = "http://203.252.240.80:8888";
  static const login = "$hostConnect/login/";
  static const imgPath = "$hostConnect/static/img/";
  static const signup = "$hostConnect/signup/";
  static const uploadDiary = "$hostConnect/uploadDiary/";
  static const getDiary = "$hostConnect/getDiary/";
  static const getAnalysis = "$hostConnect/getAnalysis/";
  static const changeUserInfo = "$hostConnect/changeInfo/";
  static const checkUserExist = "$hostConnect/getIdExist/";
  static const checkPasswd = "$hostConnect/checkPasswd/";
}
