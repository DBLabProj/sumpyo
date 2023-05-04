class API {
  static const hostConnect = 'http://203.252.240.80/api_new_members';
  static const hostConnectUser = "$hostConnect/user";

  static const signUp = "$hostConnect/user/signup.php";
  static const validateName = "$hostConnect/user/validate_name.php";
}

class RestAPI {
  static const hostConnect = "http://203.252.240.80:5000";
  static const login = "$hostConnect/login/";
  static const signup = "$hostConnect/signup/";
}
