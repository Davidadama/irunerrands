import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

final GlobalKey<FormState> _formkey = GlobalKey<FormState>();


// ignore: camel_case_types
class Add_Errands extends StatefulWidget {
  final String title;
  Add_Errands (this.title);


  @override
  _Add_ErrandsState createState() => _Add_ErrandsState();
}

final FirebaseFirestore _db = FirebaseFirestore.instance;
final FirebaseMessaging _fcm = FirebaseMessaging.instance;
late String Errand_title,Description,Pay,Est_time,Location,userID,uid,mobile;

class _Add_ErrandsState extends State<Add_Errands> {


  late User _user;
  late final DocumentSnapshot? userInfo;
  @override
  void initState() {
    super.initState();
    _currentUser().whenComplete((){
      setState(() {
      }
      );
    });
  }

  _currentUser() async {
    _user = FirebaseAuth.instance.currentUser! ;
    try {
      userInfo = await FirebaseFirestore.instance
          .collection('User_information')
          .doc(_user.uid)
          .get().whenComplete(() => userID = _user.uid );
      // userID = userInfo as String;

    } catch (e) {
      print("something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}
late String token;

_saveDeviceToken() async{
  String? fcmToken = await _fcm.getToken();
  token = fcmToken!;
}

// bool _validate;
  @override
  Widget build(BuildContext context) {

    _saveDeviceToken();

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Errands',style: TextStyle(color: Colors.brown[400]),),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body:
      ListView(
        children: <Widget>[
          SizedBox(height:10.0),
      /**    FutureBuilder(
              //future: FirebaseAuth.instance.currentUser(),
              builder: (context,AsyncSnapshot<FirebaseAuth> snapshot){
                if (snapshot.connectionState==ConnectionState.done){
                  userID = snapshot.data!.uid;
                  _userDetails(userID);

                  return  Text('');
                }
                else{
                  return new Text('');
                }
              }
          ),
**/
          Form(
              key: _formkey,
              child:
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                    child:
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      maxLength: 40,
                      validator: (input){
                        if (input!.isEmpty) {
                          return 'Please Enter errand title';
                        }
                      },
                      onSaved: (input) => Errand_title = input!,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        hintText: 'Parcel delivery',

                        labelStyle: TextStyle(
                            fontSize: 17.0,
                            fontStyle: FontStyle.normal
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                    child:
                    TextFormField(
                      maxLines: 5,
                      validator: (input){
                        if (input!.isEmpty) {
                          return 'Please enter errand description';
                        }
                      },
                      onSaved: (input) => Description  = input! ,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        hintText: 'In need of someone to deliver a parcel for me. Delivery '
                            'needs to be done by Tuesday{13/05/2020} from Jos{Rayfield} to Abuja {Area 11}'
                            'The parcel contains a pair of shoes and some sport wears',
                        hintMaxLines: 4,

                        labelStyle: TextStyle(
                            fontSize: 17.0,
                            fontStyle: FontStyle.normal
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                    child:

                    TextFormField(
                      maxLength: 10,
                      validator: (input){
                        if (input!.isEmpty) {
                          return 'Please Enter amount you are willing to pay';
                        }
                      },
                      onSaved: (input) => Pay = input!,
                      decoration: InputDecoration(
                        labelText: 'Pay{Naira}',
                        hintText: '5000',
                        labelStyle: TextStyle(
                            fontSize: 17.0,
                            fontStyle: FontStyle.normal
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                    child:
                    TextFormField(
                      textInputAction: TextInputAction.done,
                      maxLength: 20,
                      validator: (input){
                        if (input!.isEmpty) {
                          return 'Please Enter estimated completion time';
                        }
                      },
                      onSaved: (input) => Est_time = input!,
                      decoration: InputDecoration(
                        labelText: 'Estimated compeletion time',
                        hintText: '40 - 53 mins',
                        labelStyle: TextStyle(
                            fontSize: 17.0,
                            fontStyle: FontStyle.normal
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                    child:

                    TextFormField(
                      maxLength: 120,
                      maxLines: 2,
                      textInputAction: TextInputAction.next,
                      autofocus: true,
                      validator: (input){
                        if (input!.isEmpty) {
                          return 'Please Enter Location';
                        }
                      },
                      onSaved: (input) => Location = input!,
                      decoration: InputDecoration(
                        labelText: 'Location',
                        hintText: '2 Atiku Street,opposite renmark plaza, Rayfield',
                        labelStyle: TextStyle(
                            fontSize: 17.0,
                            fontStyle: FontStyle.normal
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                    child:

                    TextFormField(
                      maxLength: 50,
                      maxLines: 2,
                      textInputAction: TextInputAction.next,
                      autofocus: true,
                      validator: (input){
                        if (input!.isEmpty) {
                          return 'Please Enter Phone number';
                        }
                      },
                      onSaved: (input) => mobile = input!,
                      decoration: InputDecoration(
                        labelText: 'Phone number',
                        hintText: '08153369584',
                        labelStyle: TextStyle(
                            fontSize: 17.0,
                            fontStyle: FontStyle.normal
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height:25.0),
                  ElevatedButton(
                    onPressed: (){
                      setState(() {
                        var  _validate = true;
                      });

                      final formState = _formkey.currentState;
                      if (formState!.validate()) {
                        formState.save();
                       AddTo_Database();
                        Navigator.of(context).pop();
                      }
                      },
                    child: Text('Add'),
                  )
                ],
              )
          )

        ],
      ),

    );
  }

  void showToast() {
    Fluttertoast.showToast(
        msg: 'Information Added',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.brown,
        textColor: Colors.white
    );
  }


  AddTo_Database() {
    if (_formkey.currentState!.validate()) {
      //no error in validator
      _formkey.currentState!.save();
      showToast ();

      FirebaseFirestore.instance.runTransaction((Transaction transaction) async{
        CollectionReference reference = FirebaseFirestore.instance.collection(
            'Add_Errands');

        await reference.add({
          "userId": userID ,
          "Title": "$Errand_title",
          "Description": "$Description",
          "Pay": "$Pay",
          "Estimated_completion_time": "$Est_time",
          "Location": "$Location",
          "Phone_number": "$mobile",
          "Status":"Available",
         "Date": "${DateTime.now()}",
          "userDevice_token": token
        });
      });
    }
    else{
      //validation error
      setState(() {
        var  _validate = true;
      }
      );
    }
  }




void setState(Null Function() param0) {
}

