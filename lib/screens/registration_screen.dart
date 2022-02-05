import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:study/model/user_model.dart';
import 'package:study/screens/home/home_screen.dart';
import 'package:study/model/helper_widget.dart';

//주석은 코드 해석 및 어떤 코드를 쓸지 고민할 떄 사용

class RegisterationScreen extends StatefulWidget {
  const RegisterationScreen({Key? key}) : super(key: key);

  @override
  _RegisterationScreenState createState() => _RegisterationScreenState();
}

class _RegisterationScreenState extends State<RegisterationScreen> {
  final _auth = FirebaseAuth.instance; //Firebase 인증 API를 사용하는 Flutter 플러그인 인증
  final _formKey = GlobalKey<FormState>(); //전체 앱에서 고유한 키 값

  final emailEditingController = new TextEditingController();
  final pwEditingController = new TextEditingController();
  final confirmpwEditingController = new TextEditingController();
  final nicknameEditingController = new TextEditingController();
  final phoneEditingController = new TextEditingController();

  double _headerHeight = 200;

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      autofocus: false, //창을 열자마자 포커스가 잡히지 않도록 함.
      controller: emailEditingController, //컨트롤러
      keyboardType: TextInputType.emailAddress, //이메일의 경우 이메일 형식으로 쓰이도록 함.
      validator: (value) {
        //Field 내에 입력된 텍스트를 인자로 받는 콜백함수를 인자로 받는다.
        if (value!.isEmpty) {
          //빈칸일 경우
          return ("Please Enter Your Email");
          // return ("이메일을 입력하십시오. ");
        }

        //reg expression for email validation
        //RegExp 객체의 hasMatch 함수의 인자로 텍스트를 넘기면 이메일 형식이 맞는지 텍스트를 검증하게 된다.
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid email");
          // return ("이메일 형식에 맞춰서 입력하십시오. ");
        }
        return null;
      },
      onSaved: (value) {
        emailEditingController.text = value!;
      },
      textInputAction: TextInputAction.next, //엔터 치면 다음으로 넘어감
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.email), //아이콘 사람 모양
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          //둥글게 선을 구분해줌
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    final pwField = TextFormField(
      autofocus: false, //창을 열자마자 포커스가 잡히지 않도록 함.
      controller: pwEditingController, //컨트롤러
      obscureText: true, //비밀번호 비밀로 칠 수 있게 해줌
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
          // return ("로그인을 위해 비밀번호가 필요합니다.");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password(Min. 6 Character");
          // return ("유효한 비밀번호(최소 6자)를 입력하십시오.");
        }
      },
      onSaved: (value) {
        pwEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    final confirmpwField = TextFormField(
      autofocus: false,
      controller: confirmpwEditingController, //컨트롤러
      obscureText: true, //비밀번호 비밀로 칠 수 있게 해줌

      validator: (value) {
        if (confirmpwEditingController.text != pwEditingController.text) {
          // return "Password don't match";
          return "비밀번호가 일치하지 않습니다.";
        }
        return null;
      },
      onSaved: (value) {
        confirmpwEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirm Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    final nicknameField = TextFormField(
      autofocus: false,
      controller: nicknameEditingController, //컨트롤러

      validator: (value) {
        RegExp regex = new RegExp(r'^.{2,}$');
        if (value!.isEmpty) {
          return ("NickName cannot be Empty");
          // return ("서비스를 이용하시려면 닉네임이 필요합니다.");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Nickname(Min. 2 Character");
          // return ("유효한 닉네임(최소 2자)을 입력하십시오. ");
        }
        return null;
      },

      onSaved: (value) {
        nicknameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next, //엔터 치면 다음으로 넘어감
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "NickName",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    final phoneField = TextFormField(
      autofocus: false, //창을 열자마자 포커스가 잡히지 않도록 함.
      controller: phoneEditingController, //컨트롤러
      keyboardType: TextInputType.phone,
      validator: (value) {
        // RegExp regex = new RegExp("[0-9]+-[0-9]+-[0-9]");
        // RegExp regex = new RegExp("[0-9]");
        RegExp regex = new RegExp(r'^.{10,}$');
        if (value!.isEmpty) {
          // return ("Phone cannot be Empty");
          return ("전화번호를 입력하십시오. ");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Phone(Min. 10 Character");
          // return ("XXX-XXXX-XXXX 형식으로 입력하십시오. ");
          // return ("알맞은 전화번호가 아닙니다.");
        }
        return null;
      },
      onSaved: (value) {
        phoneEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.phone),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Phone",
          //둥글게 선을 구분해줌
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    final SignUpButton = Material(
      elevation: 5, //버튼에 그림자
      borderRadius: BorderRadius.circular(30), //버튼을 둥글게
      color: Colors.green.shade400,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          //MediaQuery는 화면 크기를 얻기 위해 사용하는 클래스
          minWidth: MediaQuery.of(context).size.width, //앱 화면의 넓이
          onPressed: () {
            signUp(emailEditingController.text, pwEditingController.text);
          },
          child: Text(
            "SignUp",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
              child: Column(children: [
            Stack(children: <Widget>[
              Container(
                  height: 200,
                  child: HeaderWidget(
                      _headerHeight, true, Image.asset('assets/logo_img.png'))),
              Container(
                  child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.arrow_back))
                ],
              ))
            ]),
            SafeArea(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(36.0), //가로폭이 줄어듦
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Sign up",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )
                        ]),
                        SizedBox(
                          height: 20,
                        ),
                        emailField,
                        SizedBox(
                          height: 10,
                        ),
                        pwField,
                        SizedBox(
                          height: 10,
                        ),
                        confirmpwField,
                        SizedBox(
                          height: 10,
                        ),
                        nicknameField,
                        SizedBox(
                          height: 10,
                        ),
                        phoneField,
                        SizedBox(
                          height: 10,
                        ),
                        SignUpButton,
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ])),
        ));
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore()})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message); //오류가 나면 오류 메시지를 보여줌
      });
    }
  }

//FireStore는 Collection-Documnet 기반 Nosql 데이터베이스 이다.
  postDetailsToFirestore() async {
    //calling our firestore
    //calling our user model
    //sending these values

    FirebaseFirestore firebaseFirestore =
        FirebaseFirestore.instance; //firestore를 가져와서 사용
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    //writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.nickname = nicknameEditingController.text;
    userModel.phone = phoneEditingController.text;

    await firebaseFirestore
        .collection("users") //collection=내부 collection을 호출한다 혹은 생성한다.
        .doc(user.uid) //doc=특정 documentId를 통해 단일의 document에 접근한다.
        .set(userModel
            .toMap()); //set=documnet의 내용을 넘어온 data(userModel.toMap())로 대체해버린다
    Fluttertoast.showToast(msg: "Account created succesfully :) ");
    // Fluttertoast.showToast(msg: "성공적으로 계정이 생성되었습니다 :) ");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false);
  }
}
