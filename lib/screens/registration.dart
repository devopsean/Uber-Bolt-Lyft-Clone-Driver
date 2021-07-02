import 'package:cab_driver/brand_colors.dart';
import 'package:cab_driver/globalvariables.dart';
import 'package:cab_driver/screens/loginpage.dart';
import 'package:cab_driver/screens/mainpage.dart';
import 'package:cab_driver/screens/vehicleinfo.dart';
import 'package:cab_driver/widgets/ProgressDialog.dart';
import 'package:cab_driver/widgets/TaxiButton.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegistrationPage extends StatefulWidget {
  static const String id = 'register';

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  void showSnackBar(String title) {
    final snackbar = SnackBar(
        content: Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 15),
    ));
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var fullNameController = TextEditingController();

  var phoneController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  void registerUser() async {
    //show please wait dialog
    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        status: 'Registering you',
      ),
    );
    final User user = (await _auth
            .createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    )
            .catchError((ex) {
      //check errors and display message
      Navigator.pop(context);
      PlatformException thisEx = ex;
      showSnackBar(thisEx.message);
    }))
        .user;
    Navigator.pop(context);
//check if user registration is successful
    if (user != null) {
      DatabaseReference newUserRef =
          FirebaseDatabase.instance.reference().child('drivers/${user.uid}');
      //Prepare data to be saved on user's table
      Map userMap = {
        'fullname': fullNameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
      };
      newUserRef.set(userMap);
      currentFirebaseUser = user;
      //Take user to mainPage
      print('we got here');
      Navigator.pushNamed(context, VehicleInfoPage.id);
    } else {
      print(
          'USER IS NULLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                Image(
                  alignment: Alignment.center,
                  height: 100,
                  width: 100,
                  image: AssetImage('images/logo.png'),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  'Create a Driver\'s account',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontFamily: 'Brand-Bold'),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      //Full name
                      TextField(
                        controller: fullNameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Full name',
                          labelStyle: TextStyle(
                            fontSize: 14,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Email address
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email address',
                          labelStyle: TextStyle(
                            fontSize: 14,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //Phone
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Phone number',
                          labelStyle: TextStyle(
                            fontSize: 14,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //Password
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        //keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              fontSize: 14,
                            ),
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 10)),
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      TaxiButton(
                        title: 'REGISTER',
                        color: BrandColors.colorAccentPurple,
                        onPressed: () async {
                          //check for Network
                          var connectivityResult =
                              await Connectivity().checkConnectivity();
                          if (connectivityResult != ConnectivityResult.mobile &&
                              connectivityResult != ConnectivityResult.wifi) {
                            showSnackBar('No internet connection');
                            return;
                          }
                          if (fullNameController.text.length < 3) {
                            showSnackBar('Please provide a valid full name');
                            return;
                          }
                          if (phoneController.text.length < 10) {
                            showSnackBar('Please provide a valid phone numberc');
                            return;
                          }
                          if (!emailController.text.contains('@')) {
                            showSnackBar(
                                'Please provide a valid email address');
                            return;
                          }

                          registerUser();
                        },
                      ),
                    ],
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                         context, LoginPage.id, (route) => false);
                  },
                  child: Text('Already have a DRIVER account? Log in'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
