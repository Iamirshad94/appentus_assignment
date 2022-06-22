import 'dart:io';

import 'package:flutter/material.dart';

class UserModel {
  late String username;
  late String email;
  late String number;
  late String password;

  UserModel(this.username, this.email, this.number,this.password,);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'user_name': username,
      'email': email,
      'number': number,
      'password': password,
    };
    return map;
  }

  UserModel.fromMap(Map<String, dynamic> map) {
    username = map['user_name'];
    email = map['email'];
    number = map['number'];
    password = map['password'];
  }
}
