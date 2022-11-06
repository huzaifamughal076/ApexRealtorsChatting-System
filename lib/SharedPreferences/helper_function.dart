import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{

  //Keys
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userPhoneKey = "USERPHONEKEY";

  //Saving the Data to SF

  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn)async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setBool(userLoggedInKey, isUserLoggedIn);
  }


  static Future<bool> saveUserNameSF(String userName)async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setString(userNameKey, userName);
  }

    static Future<bool> saveUserEmailSF(String userEmail)async {
      SharedPreferences sf = await SharedPreferences.getInstance();
      return sf.setString(userEmailKey, userEmail);
    }

  static Future<bool> saveUserPhoneSF(String userPhone)async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setString(userPhoneKey, userPhone);
  }


  //Retrieving the Data from SF

  static Future<bool?> getUserLoggedInStatus()async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }
}