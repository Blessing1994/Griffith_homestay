import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:homestay/services/firestore_services.dart';
import 'package:homestay/services/usermanagement.dart';
import 'package:toast/toast.dart';

class ParentSignUp extends StatefulWidget {
  @override
  _ParentSignUpState createState() => _ParentSignUpState();
}

class _ParentSignUpState extends State<ParentSignUp> {
  final _formKey = GlobalKey<FormState>();
  var passKey = GlobalKey<FormFieldState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _validate = false;
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _firstName = '';
  String _lastName = '';
  bool passwordVisible;
  var _userType = "Host Parent";
  String authError;

  _showSnackBar() {
    final snackBar = new SnackBar(
      content: Row(
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(
            width: 10,
          ),
          Text('Host Parent registration please wait ...'),
        ],
      ),
      //duration: new Duration(seconds: 3),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  final auth = FirebaseAuth.instance;
  final fs = FirestoreServices();

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  Future<String> parentSignUp(String email, String password) async {
    _showSnackBar();
    FirebaseUser user = await auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then(
      (FirebaseUser signedInUser) {
        signedInUser.sendEmailVerification();
        UserUpdateInfo updateUser = UserUpdateInfo();
        updateUser.displayName = _firstName.trim() + ' ' + _lastName.trim();
        updateUser.photoUrl =
            'https://firebasestorage.googleapis.com/v0/b/homestay-app.appspot.com/o/no-img.png?alt=media';
        signedInUser.updateProfile(updateUser).then((user) {
          FirebaseAuth.instance.currentUser().then((user) {
            UserManagement().storeNewHostParent(
                user, context, _userType, _firstName.trim(), _lastName.trim());
          }).catchError((e) {
            //print(e);
          });
        }).catchError((e) {});
      },
    ).catchError((e) {
      //print('not working');
      if (e.code == 'ERROR_INVALID_EMAIL') {
        //print('not a proper email');
        authError = 'Invalid Email Address';
        showToast(authError,
            gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      //resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Host Parent Register'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image(
            image: AssetImage('assets/images/host.jpg'),
            fit: BoxFit.cover,
            colorBlendMode: BlendMode.darken,
            color: Colors.black.withOpacity(0.7),
          ),
          Theme(
            data: ThemeData(
                primaryColor: Colors.teal,
                canvasColor: Colors.black.withOpacity(0.5),
                inputDecorationTheme: InputDecorationTheme(
                  hintStyle: TextStyle(color: Colors.teal),
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Muli',
                    fontSize: 20,
                  ),
                ),
                hintColor: Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: <Widget>[
                    Container(
                      height: 150,
                      child: Image.asset(
                        'assets/images/logo.png',
                      ),
                    ),
                    Card(
                      elevation: 10,
                      color: Colors.black.withOpacity(0.6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Form(
                        key: _formKey,
                        autovalidate: _validate,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: 330,
                                child: TextFormField(
                                  maxLength: 15,
                                  onSaved: (value) {
                                    setState(() {
                                      _firstName = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10),
                                      ),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      // width: 0.0 produces a thin "hairline" border
                                      borderSide: const BorderSide(
                                          color: Colors.teal, width: 1.5),
                                    ),
                                    labelText: 'First Name',
                                    labelStyle: TextStyle(
                                      fontFamily: 'Muli',
                                      color: Colors.white,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.account_box,
                                      color: Colors.teal,
                                    ),
                                  ),
                                  style: TextStyle(
                                      fontFamily: 'Muli',
                                      color: Colors.white,
                                      fontSize: 17),
                                  validator: validateFullName,
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Container(
                                width: 330,
                                child: TextFormField(
                                  maxLength: 15,
                                  onSaved: (value) {
                                    setState(() {
                                      _lastName = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10),
                                      ),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      // width: 0.0 produces a thin "hairline" border
                                      borderSide: const BorderSide(
                                          color: Colors.teal, width: 1.5),
                                    ),
                                    labelText: 'Last Name',
                                    labelStyle: TextStyle(
                                      fontFamily: 'Muli',
                                      color: Colors.white,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.account_box,
                                      color: Colors.teal,
                                    ),
                                  ),
                                  style: TextStyle(
                                      fontFamily: 'Muli',
                                      color: Colors.white,
                                      fontSize: 17),
                                  validator: validateLastName,
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Container(
                                width: 330,
                                child: TextFormField(
                                  maxLength: 30,
                                  onSaved: (value) {
                                    setState(() {
                                      _email = value;
                                    });
                                  },
                                  validator: validateEmail,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10),
                                      ),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      // width: 0.0 produces a thin "hairline" border
                                      borderSide: const BorderSide(
                                          color: Colors.teal, width: 1.5),
                                    ),
                                    labelText: 'Email Address',
                                    helperText:
                                        '(Valid email e.g gmail, hotmail, yahoo)',
                                    labelStyle: TextStyle(
                                      fontFamily: 'Muli',
                                      color: Colors.white,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.mail,
                                      color: Colors.teal,
                                    ),
                                  ),
                                  style: TextStyle(
                                      fontFamily: 'Muli',
                                      color: Colors.white,
                                      fontSize: 17),
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Container(
                                width: 330,
                                child: TextFormField(
                                  key: passKey,
                                  maxLength: 10,
                                  validator: validatePassword,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10),
                                      ),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      // width: 0.0 produces a thin "hairline" border
                                      borderSide: const BorderSide(
                                          color: Colors.teal, width: 1.5),
                                    ),
                                    labelText: 'Password',
                                    labelStyle: TextStyle(
                                      fontFamily: 'Muli',
                                      color: Colors.white,
                                    ),
                                    prefixIcon: Icon(
                                      FontAwesomeIcons.key,
                                      color: Colors.teal,
                                    ),
                                    helperText:
                                        '(Uppercase, Lowercase, special, atleast 8 characters)',
                                    helperStyle: TextStyle(fontSize: 10),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      color: Colors.teal,
                                      onPressed: () {
                                        setState(() {
                                          passwordVisible = !passwordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                  onSaved: (value) {
                                    setState(() {
                                      _password = value;
                                    });
                                  },
                                  obscureText: passwordVisible,
                                  style: TextStyle(
                                      fontFamily: 'Muli',
                                      color: Colors.white,
                                      fontSize: 17),
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Container(
                                width: 330,
                                child: TextFormField(
                                  maxLength: 10,
                                  validator: (_confirm_password) {
                                    var password = passKey.currentState.value;
                                    if (_confirm_password.isEmpty) {
                                      return 'Password is empty';
                                    } else if (_confirm_password != password) {
                                      return 'Password is not matching';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(10),
                                      ),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      // width: 0.0 produces a thin "hairline" border
                                      borderSide: const BorderSide(
                                          color: Colors.teal, width: 1.5),
                                    ),
                                    labelText: 'Retype Password',
                                    labelStyle: TextStyle(
                                      fontFamily: 'Muli',
                                      color: Colors.white,
                                    ),
                                    prefixIcon: Icon(
                                      FontAwesomeIcons.key,
                                      color: Colors.teal,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      color: Colors.teal,
                                      onPressed: () {
                                        setState(() {
                                          passwordVisible = !passwordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                  onSaved: (value) {
                                    setState(() {
                                      _confirmPassword = value;
                                    });
                                  },
                                  obscureText: passwordVisible,
                                  style: TextStyle(
                                      fontFamily: 'Muli',
                                      color: Colors.white,
                                      fontSize: 17),
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Container(
                                width: 330,
                                child: RaisedButton(
                                  padding: EdgeInsets.all(16),
                                  color: Colors.teal,
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                      parentSignUp(_email, _password);
                                    } else {
                                      setState(() {
                                        _validate = true;
                                      });
                                    }
                                  },
                                  elevation: 0,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Icon(
                                        FontAwesomeIcons.signInAlt,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 9,
                                      ),
                                      Text(
                                        'Register',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Muli',
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  shape: StadiumBorder(
                                    side: BorderSide(
                                        color: Colors.black, width: 0),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushReplacementNamed(
                                      '/parentsigninpage');
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      'Already have an account? Login',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Muli',
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  String validateFullName(String _fullName) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(pattern);
    if (_fullName.isEmpty) {
      return 'First name is empty';
    } else if (!regExp.hasMatch(_fullName)) {
      return 'Invalid name';
    }
    return null;
  }

  String validateLastName(String _lastName) {
    String pattern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(pattern);
    if (_lastName.isEmpty) {
      return 'First name is empty';
    } else if (!regExp.hasMatch(_lastName)) {
      return 'Invalid name';
    }
    return null;
  }

  String validatePassword(String _password) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&%*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    if (_password.isEmpty) {
      return 'Password is empty';
    } else if (!regExp.hasMatch(_password)) {
      return 'Uppercase, lowercase and alphanumerics';
    } else if (_password.toString().length < 8) {
      return 'Password  must be more than 8 characters';
    }
    return null;
  }

  String validateConfirmPassword(String _confirmPassword) {
    if (_confirmPassword.isEmpty) {
      return 'Confirm password is empty';
    }
//    else if (_confirmPassword.toString() != _password.toString()) {
//      return 'Password Mismatch';
//    }
    return null;
  }

  String validateEmail(String _email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (_email.isEmpty) {
      return 'Email is empty';
    } else if (!regex.hasMatch(_email)) {
      return 'Invalid Email';
    }
    return null;
  }
}
