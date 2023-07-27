import 'dart:core';

class UserModel {
  String? uid;
  String? email;
  String? guardianname;
  String? patientname;

  UserModel({this.uid, this.email, this.guardianname, this.patientname});

  //recieving data from the server

  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      guardianname: map['guardianname'],
      patientname: map['patientname'],
    );
  }

  //sending data to server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'guardianname': guardianname,
      'patientname': patientname,
    };
  }
}
