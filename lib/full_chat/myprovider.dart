import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_firebase/full_chat/MyUserModel.dart';
import 'package:flutter/cupertino.dart';

class MyProvider extends ChangeNotifier{



  MyUserModel? _usermodel;


  void setUserModel(MyUserModel userModel,{bool isRefresh=true})
  {
    _usermodel=usermodel;

    if(isRefresh)notifyListeners();
  }



  MyUserModel? get usermodel => _usermodel;
}