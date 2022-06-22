import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../database/db_helper.dart';
import '../helper/genLoginSignupHeader.dart';
import '../helper/genTextFormField.dart';
import '../helper/helper_class.dart';
import '../model/user_model.dart';
import 'login_page.dart';



class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {


  // form key
  final _formKey = GlobalKey<FormState>();

  // controllers
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final numberController = TextEditingController();

  // variable
  var dbHelper;
  File image=File("");

  // sign up function to register
  signUp() async {
    FocusManager.instance.primaryFocus?.unfocus();

    String uname = nameController.text;
    String email = emailController.text;
    String number = numberController.text;
    String passwd = passwordController.text;

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      UserModel? uModel = UserModel(uname, email, number,passwd,);
      await dbHelper.saveData(uModel).then((userData) {
        alertDialog(context, "Successfully Saved");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }).catchError((error) {
        print(error);
        alertDialog(context, "Error: Data Save Fail");
      });
    }
  }


  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
  }

  @override
  Widget build(BuildContext context) {
    // Mediaquery variable to get device screen size
    Size screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          // resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: _formKey,
              child: Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      genLoginSignupHeader('Signup'),
                      getTextFormField(
                          controller: nameController,
                          icon: Icons.person_outline,
                          inputType: TextInputType.name,
                          hintName: 'User Name'),
                      SizedBox(height: screenSize.height/30),
                      getTextFormField(
                          controller: emailController,
                          icon: Icons.email,
                          inputType: TextInputType.emailAddress,
                          hintName: 'Email'),
                      SizedBox(height: screenSize.height/30),
                      getTextFormField(
                        controller: numberController,
                        icon: Icons.phone_android,
                        hintName: 'Mobile No',
                        isObscureText: false,
                      ),
                      SizedBox(height: screenSize.height/30),
                      getTextFormField(
                        controller: passwordController,
                        icon: Icons.lock,
                        hintName: 'Password',
                        isObscureText: false,
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
                            'Signup',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: signUp
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Already have account?'),
                            FlatButton(
                              textColor: Colors.blue,
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => LoginPage()));
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
