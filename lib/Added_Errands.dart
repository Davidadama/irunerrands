import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

final GlobalKey<FormState> _formkey = GlobalKey<FormState>();


class Added_Errands extends StatefulWidget {
  final String title;
  const Added_Errands(String s,  {Key? key, required this.title}) : super(key: key);

  @override
  _Added_ErrandsState createState() => _Added_ErrandsState();
}

late String userID;

class _Added_ErrandsState extends State<Added_Errands> {



  late final  User _user;
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Added Errands',style: TextStyle(color: Colors.brown[400]),),
        centerTitle: true,
      ),
      body: ListPage(),

    );
  }
}

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();

}

final errandController = TextEditingController();
final descriptionController = TextEditingController();
final timeController = TextEditingController();
final payController = TextEditingController();
final locationController = TextEditingController();
final mobileController = TextEditingController();



class _ListPageState extends State<ListPage> {
  get index => null;


  navigateToDetail(DocumentSnapshot errand){
    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(errand: errand)));
  }
 late String Errand_title,Description,Pay,Est_time,Location,mobile,uid,date;


  Widget build(BuildContext context) {
    return Container(
         child:
         FutureBuilder(
             builder: (context,AsyncSnapshot<FirebaseAuth> snapshot){

               final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('Add_Errands')
                   .where('userId', isEqualTo: userID).where('Status', isEqualTo: 'Available')
                   .orderBy('Date',descending:true)
                   .snapshots() ;


               if (snapshot.hasData == false) {
                 return Center(
                     child: Text('No errand has been added')
                  );
                     }
                 return  StreamBuilder(
                   stream:  _usersStream  ,
               builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                     if(!snapshot.hasData){
                       return Center(
                         child: Text('No errand has been added'),
                       );
                     }
                     else {
                       if (snapshot.connectionState ==
                           ConnectionState.waiting) {
                         return Center(
                             child: CircularProgressIndicator(
                               backgroundColor: Colors.brown,
                             )
                         );
                       }
                     }
                       return new ListView(

                         children: snapshot.data!.docs.map(
                         (DocumentSnapshot document) {
                       Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                       void showToast() {
                               Fluttertoast.showToast(
                                   msg: 'Document deleted',
                                   toastLength: Toast.LENGTH_SHORT,
                                   gravity: ToastGravity.CENTER,
                                   //timeInSecForIos: 2,
                                   backgroundColor: Colors.brown,
                                   textColor: Colors.white
                               );
                             }
                             String phone;
                             dynamic txtPhone_;

                             Widget popupMenuButton() {
                               return PopupMenuButton<String>(

                                   icon: Icon(Icons.more_vert,
                                   color: Colors.brown,
                                   size: 25.0,),
                                   itemBuilder: (BuildContext context) =>
                                   <PopupMenuEntry<String>>[

                                     PopupMenuItem<String>(
                                         value: '1',
                                         child:
                                             Row(
                                               children: <Widget>[
                                                 Icon(Icons.update,color: Colors.brown,),
                                                 Text('Update')
                                               ],
                                             )
                                        ),
                                     PopupMenuItem<String>(
                                         value: '2',
                                         child:
                                         Row(
                                           children: <Widget>[
                                             Icon(Icons.delete,color: Colors.brown,),
                                             Text('Delete'),
                                             ],
                                         )

                                     ),
                                     PopupMenuItem<String>(
                                         value: '3',
                                         child:
                                         Row(
                                           children: <Widget>[
                                             Icon(Icons.contact_phone,color: Colors.brown,),
                                             Text('Contact')
                                           ],
                                         )
                                        )

                                   ],
                                   onSelected: (retValue) {
                                     if (retValue == '1') {
                                       updateDialog(context,snapshot.data!.docs[index].id);
                                     }
                                     if (retValue == '2') {
                                       deleteData(
                                           snapshot.data!.docs[index].id);
                                       showToast();
                                     }
                                     if (retValue == '3') {
                                       showDialog(context: context,
                                           builder: (context) =>
                                               AlertDialog(
                                                 content: Row(
                                                     mainAxisAlignment: MainAxisAlignment
                                                         .spaceBetween,
                                                     children: <Widget>[
                                                       Container(
                                                         height: 100.0,
                                                         child:
                                                         Column(
                                                             mainAxisAlignment: MainAxisAlignment
                                                                 .center,
                                                             children: <
                                                                 Widget>[
                                                               IconButton(
                                                                 icon: Icon(
                                                                     Icons.phone,color: Colors.brown,),
                                                                 iconSize: 50.0,
                                                                 onPressed: () {
                                                                   launch(
                                                                       ('tel://07011133131'));
                                                                 },
                                                               ),
                                                               SizedBox(
                                                                   height: 5.0),
                                                               Text('call'),
                                                             ]
                                                         ),
                                                       ),
                                                       Container(
                                                         height: 100.0,
                                                         child:
                                                         Column(
                                                             mainAxisAlignment: MainAxisAlignment.center,
                                                             children: <Widget>[
                                                               IconButton(icon: Icon(Icons.textsms,
                                                                     color: Colors.brown,),
                                                                   iconSize: 50.0,
                                                                   onPressed: () {
                                                                     launch(
                                                                         ('sms://07011133131'));
                                                                   }
                                                               ),
                                                               SizedBox(
                                                                   height: 5.0),
                                                               Text('text'),
                                                             ]
                                                         ),
                                                       ),
                                                       Container(
                                                           height: 100.0,
                                                           child:
                                                           Column(
                                                               mainAxisAlignment: MainAxisAlignment.center,
                                                               children: <Widget>[
                                                                 IconButton(
                                                                     icon: Icon(
                                                                         Icons.message,
                                                                     color: Colors.brown,),
                                                                     iconSize: 50.0,
                                                                     onPressed: () async =>
                                                                     await launch(
                                                                         "http://wa.me/${2347011133131} ?text= Errand App"
                                                                     )
                                                                 ),
                                                                 SizedBox(
                                                                     height: 5.0),
                                                                 Text(
                                                                     'whatsApp'),
                                                               ]
                                                           )
                                                       ),
                                                     ]
                                                 ),
                                                 actions: <Widget>[
                                                   Row(
                                                     children: <Widget>[
                                                       ElevatedButton(
                                                           onPressed: () =>
                                                               Navigator.of(
                                                                   context)
                                                                   .pop(),
                                                           child:  Text('CANCEL',style: TextStyle(
                                                             color: Colors.black
                                                           ),)
                                                       ),
                                                       SizedBox(
                                                         height: 60.0,)
                                                     ],
                                                   ),

                                                 ],
                                               )
                                       );
                                     }
                                   }
                               );
                             }

                             return ListTile(
                               onTap: (){navigateToDetail(snapshot.data!.docs[index]);},
                               title: Text(snapshot.data!.docs[index]['Title'],
                                 style: TextStyle(
                                     fontWeight: FontWeight.w500,
                                         fontSize: 17.0,
                                 ),
                               ),

                               subtitle: Text(snapshot.data!.docs[index]['Location']),
                               trailing:
                               popupMenuButton(),
                             );

                           }
                           ).toList()
                       );
                   }
                   );
               }, future: null,


         )
    );
  }
  Future<void> _userDetails(userID) async {
    final userDetails = await getData(userID);
    setState (() {
      uid = userDetails.toString();
      Text(uid);
    }
    );
  }
  getData(userID) async{
    DocumentSnapshot result = await FirebaseFirestore.instance.collection('Add_Errands').doc(userID).get();
    return result;
  }

  Future<dynamic> updateDialog(BuildContext context, selectedDoc) async{
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title:
            Row(
                children:<Widget>[
                  Text('Update Data',
                      style: TextStyle(
                          fontSize: 17.0)),
                  IconButton(
                      icon: Icon(Icons.close),
                      onPressed: Navigator.of(context).pop,
                      padding: EdgeInsets.only(left: 100)
                  ),

                ],
            ),

            content:
            ListView(
                children: <Widget>[
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
                              onSaved:  (input) {
                                this.Errand_title = input!;
                              },
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
                              onSaved:  (input) {
                                this.Description = input!;
                              },
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
                              onSaved: (input) {
                                this.Pay= input!;
                              },
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
                              onSaved:  (input) {
                                this.Est_time = input!;
                              },
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
                              onSaved:  (input) {
                                this.Location = input!;
                              },
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
                                  return 'Please Enter phone number';
                                }
                              },
                              onSaved:  (input) {
                                this.mobile = input!;
                              },
                              decoration: InputDecoration(
                                labelText: 'Phone number',
                                hintText: '08145587953',
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
                              if (_formkey.currentState!.validate()) {
                                //no error in validator
                                _formkey.currentState!.save();
                                showToast();
                                // ignore: unnecessary_statements
                                Navigator.of(context).pop;
                                updateData(selectedDoc, {
                                  "Title": this.Errand_title,
                                  "Description": this.Description,
                                  "Pay": this.Pay,
                                  "Estimated_completion_time": this.Est_time,
                                  "Location": this.Location,
                                  "Phone_number": this.mobile
                                }
                                );
                              }
                              else{
                                //validation error
                                setState(() {
                                  var _validate = true;
                                });
                              }

                            },
                            child: Text('Update'),

                          )
                        ],
                      )
                  )

                ]
            ),
          );
        }
    );
  }
}
void showToast() {
  Fluttertoast.showToast(
      msg: 'Document updated',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.brown,
      textColor: Colors.white
  );
}

updateData(selectedDoc,newValues){
  FirebaseFirestore.instance.collection('Add_Errands').doc(selectedDoc).update(newValues).catchError((e) {
    print(e);
  });
}

void setState(Null Function() param0) {
}



deleteData(docId) {
  FirebaseFirestore.instance.collection('Add_Errands').doc(docId).delete().catchError((e) {
    print(e);
  } );
}




class DetailPage extends StatefulWidget {
  final DocumentSnapshot errand;

  DetailPage({required this.errand});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Details',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17.0,
              color: Colors.brown[400],
          ),
        ),
      ),
      body:
      Container(
          child:
          ListView(
              children: <Widget>[
                Column(
                    children: <Widget>[
                      SizedBox(height: 5.0),
                      ListTile(
                          title: Row(
                            children: <Widget>[
                              Icon(Icons.title, color: Colors.brown,)
                              , Text('Title ',
                                style: TextStyle(
                                    fontSize: 17.0,fontWeight: FontWeight.w500),
                                maxLines: 3,
                              )
                              ,],
                          ),
                          subtitle:
                          Padding(padding: EdgeInsets.only(left:23.0),
                            child: Text(widget.errand.get('Title'),
                              style: TextStyle(
                                fontSize: 18.0,
                              ),),

                          )
                      ),

                      SizedBox(height: 5.0),

                      ListTile(
                          title: Row(
                            children: <Widget>[
                              Icon(Icons.description, color: Colors.brown,)
                              , Text('Description ',
                                style: TextStyle(
                                    fontSize: 17.0,fontWeight: FontWeight.w500),
                                maxLines: 3,
                              )
                              ,],
                          ),
                          subtitle:
                          Padding(padding: EdgeInsets.only(left:23.0),
                            child: Text(widget.errand.get('Description'),
                              style: TextStyle(
                                fontSize: 18.0,
                              ),),

                          )
                      ),

                      SizedBox(height: 5.0),
                      ListTile(
                          title: Row(
                            children: <Widget>[
                              Icon(Icons.timer, color: Colors.brown,)
                              , Text( 'Estimated Completion time' ,
                                style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w500),
                                maxLines: 3,
                              )
                              ,],
                          ),
                          subtitle:
                          Padding(padding: EdgeInsets.only(left:23.0),
                            child: Text(widget.errand.get('Estimated_completion_time'),
                              style: TextStyle(
                                fontSize: 18.0,
                              ),),

                          )
                      ),
                      SizedBox(height: 5.0),

                      ListTile(
                          title: Row(
                            children: <Widget>[
                              Icon(Icons.location_on, color: Colors.brown,)
                              , Text('Location ',
                                style: TextStyle(
                                    fontSize: 17.0,fontWeight: FontWeight.w500),
                                maxLines: 3,
                              )
                              ,],
                          ),
                          subtitle:
                          Padding(padding: EdgeInsets.only(left:23.0),
                            child: Text(widget.errand.get('Location'),
                              style: TextStyle(
                                fontSize: 18.0,
                              ),),

                          )
                      ),
                      SizedBox(height: 5.0),
                      ListTile(
                          title: Row(
                            children: <Widget>[
                              Icon(Icons.attach_money, color: Colors.brown,)
                              , Text('Pay',
                                style: TextStyle(
                                    fontSize: 17.0,fontWeight: FontWeight.w500),
                                maxLines: 3,
                              )
                              ,],
                          ),
                          subtitle:
                          Padding(padding: EdgeInsets.only(left:23.0),
                            child: Text(widget.errand.get('Pay'),
                              style: TextStyle(
                                fontSize: 18.0,
                              ),),

                          )
                      ),
                      SizedBox(height: 5.0),
                      ListTile(
                          title: Row(
                            children: <Widget>[
                              Icon(Icons.phone_android, color: Colors.brown,)
                              , Text('Phone number',
                                style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w500),
                                maxLines: 3,
                              )
                              ,],
                          ),
                          subtitle:
                          Padding(padding: EdgeInsets.only(left:23.0),
                            child: Text(widget.errand.get('Phone_number'),
                              style: TextStyle(
                                fontSize: 18.0,
                              ),),

                          )
                      ),
                      SizedBox(height:5.0),
                      ListTile(
                          title: Row(
                            children: <Widget>[
                              Icon(Icons.calendar_today, color: Colors.brown,)
                              , Text('Date ',
                                style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w500),
                                maxLines: 3,
                              )
                              ,],
                          ),
                          subtitle:
                          Padding(padding: EdgeInsets.only(left:23.0),
                            child: Text(widget.errand.get('Date'),
                              style: TextStyle(
                                fontSize: 18.0,
                              ),),

                          )
                      ),
                      SizedBox(height: 5.0),
                      ListTile(
                          title: Row(
                            children: <Widget>[
                              Icon(Icons.perm_identity, color: Colors.brown,)
                              , Text('UserID ',
                                style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w500),
                                maxLines: 3,
                              )
                              ,],
                          ),
                          subtitle:
                          Padding(padding: EdgeInsets.only(left:23.0),
                            child: Text(widget.errand.get('userID'),
                              style: TextStyle(
                                fontSize: 18.0,
                              ),),

                          )
                      ),
                      SizedBox(height:5.0),
                      SizedBox(height: 5.0),
                      ListTile(
                          title: Row(
                            children: <Widget>[
                              Icon(Icons.important_devices, color: Colors.brown,)
                              , Text('User Token ',
                                style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w500),
                                maxLines: 3,
                              )
                              ,],
                          ),
                          subtitle:
                          Padding(padding: EdgeInsets.only(left:23.0),
                            child: Text(widget.errand.get('userDevice_token'),
                              style: TextStyle(
                                fontSize: 18.0,
                              ),),

                          )
                      ),
                      SizedBox(height:5.0),
                      Padding(
                        padding: EdgeInsets.all( 5.0),
                        child:
                        Text('Status:  ' + widget.errand.get('Status'),
                            style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                                backgroundColor: Colors.blue
                            )
                        ),
                      ),



                    ]
                ),
              ]
          )
      ));

  }
}

