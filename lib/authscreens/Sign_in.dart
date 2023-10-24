import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'Password Reset.dart';
import 'Register.dart';
//import 'main.dart';



class LoginPage extends StatefulWidget {
  // LoginPage(String s);


  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  late String _email, _password, _name;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  String? get title => null;
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home:Container(
        decoration: BoxDecoration(
        image: DecorationImage(
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(Colors.lightGreen.withOpacity(0.2), BlendMode.dstATop),
    image: AssetImage('assets/icons/718.jpg')
    ),
    ),
    child:Scaffold(
        backgroundColor: Colors.transparent,
        body:

        ListView(
            children: <Widget>[
              SizedBox(height:30.0),
              Padding(
                padding: EdgeInsets.only(top: 13.0),
                child:
                Text('Sign in',
                      textAlign: TextAlign.center
                ,style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color:  Colors.green[400]
                ),
                ),
              ),
              SizedBox(height:200.0),

              Form(
                  key: _formkey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                        child:
                        TextFormField(
                          style: TextStyle(
                            color: Colors.white
                          ),
                          validator: (input) {
                            if (input!.isEmpty) {
                              return 'Please Enter Email';
                            }
                          },
                          onSaved: (input) => _email = input!,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                                fontStyle: FontStyle.normal,
                                    color:Colors.green
                            ),

                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                        child:

                        TextFormField(
                          style: TextStyle(
                            color: Colors.white
                          ),
                          validator: (input) {
                            if (input!.length == 0) {
                              return 'Please enter password';
                            }
                          },
                          onSaved: (input) => _password = input!,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              color: Colors.green
                            )
                          ),
                          obscureText: true,
                        ),
                      ),
                      SizedBox(height:35.0),
                               ElevatedButton(
                onPressed: signIn,
                child: Text('Sign up'),
              ),
         
                 SizedBox(height:45.0),
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              style: TextStyle(color: Colors.green[600], fontSize: 30.0, fontStyle: FontStyle.normal),
                              children: <TextSpan>[
                                TextSpan(
                                    text: "I don't have an account.",
                                    style: TextStyle(color:  Colors.green[400],fontSize: 15.0, fontStyle: FontStyle.normal),
                                    recognizer: TapGestureRecognizer()..onTap=(){
                                      navigateToRegister();
                                    }
                                )
                              ]
                          )
                      ),
                      SizedBox(height:15.0),
                      
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              style: TextStyle(color: Colors.green[600], fontSize: 30.0, fontStyle: FontStyle.normal),
                              children: <TextSpan>[
                                TextSpan(
                                    text: "Forgot password.",
                                    style: TextStyle(color: Colors.green[400],fontSize: 15.0, fontStyle: FontStyle.normal),
                                    recognizer: TapGestureRecognizer()..onTap=(){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                          PasswordReset(), fullscreenDialog: true));
                                    }
                                )
                              ]
                          )
                      ),

                    ],
                  )
              ),
            ]
        )
    )
    )
    );
  }

  void navigateToRegister(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => Register(), fullscreenDialog: true));
  }
  showAlertDialog(BuildContext context){
    AlertDialog alert= AlertDialog(contentPadding: EdgeInsets.all(5),
      content: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(
            backgroundColor: Colors.brown,
          ),
           Container(margin: EdgeInsets.only(left: 5),child: Text('please wait...'),),
        ],
      ),
    ) ;
    showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return alert;
        }
    );
  }

/**  showAlertDialog1(BuildContext context){
     AlertDialog(contentPadding: EdgeInsets.all(5),
      content: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(margin: EdgeInsets.only(left: 5),
          ),
        ],
      ),
    ) ;
  } **/

  Future<void> signIn() async {
    final formState = _formkey.currentState;
    if (formState!.validate()) {
      formState.save();

      try {
        showAlertDialog(context);
          await FirebaseAuth.instance.signInWithEmailAndPassword(
    email:_email,
    password: _password
  ).whenComplete(() =>  Navigator.pop(context)) ;
  /**
  .whenComplete(() => 
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => people())));
               **/
      }
       on FirebaseAuthException catch (e) {

         showDialog(context: context,
             barrierDismissible: false,
             builder: (context) => AlertDialog(
               content: ListTile(
                   title: Text('Error',
                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0,),
                   ),
                   subtitle: Text(e.code)
               ),
               titlePadding: EdgeInsets.only(bottom: 20.0) ,
               contentPadding: EdgeInsets.all(12.0),
               actions: <Widget>[
                 Row(
                   children: <Widget>[
                     ElevatedButton(
                         onPressed: (){
                           Navigator.of(context).pop();
                           Navigator.pop(context);
                         },
                         child:Text('OK')
                     ),
                     SizedBox(height: 35.0,)
                   ],
                 ),
               ],
             )
         );
      }
  }
  }


}
