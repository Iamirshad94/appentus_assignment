import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/db_helper.dart';
import '../helper/genLoginSignupHeader.dart';
import '../helper/genTextFormField.dart';
import '../helper/helper_class.dart';
import '../model/user_model.dart';
import 'maps_page.dart';
import 'signup_page.dart';


class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // shared prefrence
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  // form key
  final _formKey = GlobalKey<FormState>();

  // controller for email and password
  final emailContoller = TextEditingController();
  final passwordController = TextEditingController();

  // DataBase variable
  var dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
  }


  // login function
  login() async {
    FocusManager.instance.primaryFocus?.unfocus();
    String email = emailContoller.text;
    String passwd = passwordController.text;

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await dbHelper.getLoginUser(email, passwd).then((userData) {
        if (userData != null) {
          setSP(userData).whenComplete(() {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => MainPage(userData)),
                    (Route<dynamic> route) => false);
          });
        } else {
          alertDialog(context, "Error: User Not Found");
        }
      }).catchError((error) {
        print(error);
        alertDialog(context, "Error: Login Fail");
      });
    }
  }


  // future function to save values in shared prefrence
  Future setSP(UserModel user) async {
    final SharedPreferences sp = await _pref;
    sp.setString("userName", user.username);
    sp.setString("email", user.email);
    sp.setString("number", user.number);
    sp.setString("password", user.password);
  }

  @override
  Widget build(BuildContext context) {
    // Mediaquery variable to get device screen size
    Size screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: _formKey,
              child: Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      genLoginSignupHeader('Login'),
                      getTextFormField(
                          controller: emailContoller,
                          icon: Icons.person,
                          hintName: 'Email'),
                      SizedBox(height: screenSize.height/24),
                      getTextFormField(
                        controller: passwordController,
                        icon: Icons.lock,
                        hintName: 'Password',
                        isObscureText: true,
                      ),
                      Container(
                        margin: EdgeInsets.all(30.0),
                        width: screenSize.width/1.5,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: FlatButton(
                          child: Text(
                            'Login',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: login,
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Does not have account?'),
                            FlatButton(
                              textColor: Colors.blue,
                              child: Text('Signup',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) => SignUp()));
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
