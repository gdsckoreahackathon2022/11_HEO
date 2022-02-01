import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:study/screens/home_screen.dart';
import 'package:study/screens/registration_screen.dart';
import 'package:study/model/helper_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double _headerHeight = 200;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController pwController = new TextEditingController();

  //firebase
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      autofocus: false, //창을 열자마자 포커스가 잡히지 않도록 함.
      controller: emailController, //컨트롤러
      keyboardType: TextInputType.emailAddress, //이메일의 경우 이메일 형식으로 쓰이도록 함.
      validator: (value) {
        if (value!.isEmpty) {
          // return ("Please Enter Your Email");
          return ("이메일을 입력하십시오. ");
        }

        //reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          // return ("Please Enter a valid email");
          return ("이메일 형식에 맞춰서 입력하십시오. ");
        }
        return null;
      },

      onSaved: (value) {
        
        emailController.text = value!; 
      },
      textInputAction: TextInputAction.next, //엔터 치면 다음으로 넘어감
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail), 
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    final pwField = TextFormField(
      autofocus: false,
      controller: pwController,
      obscureText: true, //비밀번호 비밀로 칠 수 있게 해줌
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          // return ("Password is required for login");
          return ("로그인을 위해 비밀번호가 필요합니다.");
        }
        if (!regex.hasMatch(value)) {
          // return ("Enter Valid Password(Min. 6 Character");
          // return ("유효한 비밀번호(최소 6자)를 입력하십시오.");
          return ("비밀번호를 잘못 입력하셨습니다."); //6자 이상 입력해도 틀리면 사용자가 없다고 문구가 뜨긴하는데.. 그리고 if문이 6자 이상 안쳤을때 나오는 문구라..고민중
        }
      },
      onSaved: (value) {
        pwController.text = value!;
      },
      textInputAction: TextInputAction.done, //엔터쳤을 떄 다음으로 안넘어감
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "PassWord",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    final loginButton = Material(
      elevation: 5, //버튼에 그림자
      borderRadius: BorderRadius.circular(30), //버튼을 둥글게
      color: Colors.green.shade400,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          //MediaQuery는 화면 크기를 얻기 위해 사용하는 클래스
          minWidth: MediaQuery.of(context).size.width, //앱 화면의 넓이
          onPressed: () {
            signIn(emailController.text, pwController.text);
          },
          child: Text(
            "Login",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Column(
            children: [Stack(
              children:<Widget>[
              Container(
                height: 200,
                child: HeaderWidget(_headerHeight, true, Image.asset('assets/logo_img.png'))
            )]),            
          SafeArea(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(36.0), //가로폭이 줄어듦
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: [
                          SizedBox(width: 10,),
                          Text("Login", textAlign: TextAlign.left, 
                          style: TextStyle(fontSize: 20,  fontWeight: FontWeight.bold),)]),
                      SizedBox(
                        height: 30,
                      ),
                      emailField,
                      SizedBox(
                        height: 25,
                      ),
                      pwField,
                      SizedBox(
                        height: 35,
                      ),
                      loginButton,
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Don't have an account? "),
                          GestureDetector(
                            //사용자의 동작 감지(버튼이 아닌 위젯을 버튼처럼 사용할 수 있게 해줌)
                            // InkWell과 기능은 똑같지만 눌렀을 떄 애니메이션 효과 유무의 차이가 있음
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RegisterationScreen()));
                            },
                            child: Text(
                              "SignUp",
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
            ]),
      ),
    );
  }

  //login function
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
                // Fluttertoast.showToast(msg: "Login Successful!"),
                Fluttertoast.showToast(msg: "Login success!"),

            
                Navigator.of(context).pushReplacement( //뒤로가기 하고싶으면 push로 바꾸기(코드 계속 재실행시키기 귀찮으니까..?)
                    MaterialPageRoute(builder: (context) => HomeScreen())),
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }
}
