class UserModel {
  String? uid;
  String? email;
  String? nickname;
  String? phone;

  UserModel({this.uid, this.email, this.nickname, this.phone});

  //receiving data from server
  factory UserModel.fromMap(map){
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      nickname: map['nickname'],
      phone: map ['phone'],
    );
  }


  //sending data to our server
  Map<String, dynamic> toMap(){
    return{
      'uid' : uid,
      'email' : email,
      'nickName':nickname,
      'phone':phone,

    };
  }


}