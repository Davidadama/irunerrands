import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';



class completed_user extends StatefulWidget {
  final String title;


  const completed_user(String s,  {required Key key, required this.title}) : super(key: key);
  @override
  _completed_userState createState() => _completed_userState();
}

final FirebaseMessaging _fcm = FirebaseMessaging.instance;

class _completed_userState extends State<completed_user> {

  late String userID;

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
        title: Text('Completed Errands',style: TextStyle(color: Colors.brown[400]),
        ),
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



class _ListPageState extends State<ListPage> {
  get index => null;



  navigateToDetail(DocumentSnapshot errand){
    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(errand: errand)));
  }

  late String Errand_title,Description,Pay,Est_time,Location,Accepted,Rejected,Completed,userID,uid;
  final Date = FieldValue.serverTimestamp().toString ;

  @override
  Widget build(BuildContext context) {

    return Container(
      child: FutureBuilder(
        //  future: FirebaseAuth.instance.currentUser(),
          builder: (context,AsyncSnapshot<FirebaseAuth> snapshot){
      final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('Add_Errands').where('userId', isEqualTo: userID)
        .where('Status', isEqualTo: 'Completed').orderBy('Date',descending:true).snapshots();


          if (snapshot.hasData == false) {
            return Center (
            child: Text('No errand has been completed'),
            );
          }
                return StreamBuilder(

                stream:  _usersStream  ,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                       if (snapshot.hasData == false){
                        return Center (
                          child: Text('No errand has been completed'),
                        );
                      }
                      else {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.brown,
                              )
                          );
                        }
                      }
                      return new ListView(
                           children: snapshot.data!.docs.map((DocumentSnapshot document){
                       Map<String, dynamic> data = document.data() as Map<String, dynamic>;


                              dynamic txtPhone_;
                              String phone;

                              Widget popupMenuButton(){
                                return PopupMenuButton<String> (

                                    icon: Icon(Icons.more_vert),
                                    itemBuilder: (BuildContext context)=><PopupMenuEntry<String>>[
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
                                          value:'3',
                                          child:
                                          Row(
                                            children: <Widget>[
                                              Icon(Icons.contact_phone,color: Colors.brown,),
                                              Text('Contact')
                                            ],
                                          )
                                      ),

                                    ],
                                    onSelected: (retValue) {
                                      if (retValue == '2') {
                                        deleteData(
                                            snapshot.data!.docs[index]
                                                .id);
                                        showToast();

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
                                                                        Icons
                                                                            .phone),
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
                                                                mainAxisAlignment: MainAxisAlignment
                                                                    .center,
                                                                children: <
                                                                    Widget>[
                                                                  IconButton(
                                                                      icon: Icon(
                                                                          Icons
                                                                              .textsms),
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
                                                                  mainAxisAlignment: MainAxisAlignment
                                                                      .center,
                                                                  children: <
                                                                      Widget>[
                                                                    IconButton(
                                                                        icon: Icon(
                                                                            Icons
                                                                                .message),
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
                                                              child: Text(
                                                                  'CANCEL')
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
                                    }
                                    );
                              }
                              phone =  Text(snapshot.data!.docs[index]['Phone_number']).data!;
                              txtPhone_ =  Text(snapshot.data!.docs[index]['Phone_number']);

                              return ListTile(
                                onTap: (){navigateToDetail(snapshot.data!.docs[index]);},
                                title:
                                Text(snapshot.data!.docs[index]['Title'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500
                                  ),
                                ),

                                subtitle: Text(snapshot.data!.docs[index]['Location']),
                                trailing:
                                popupMenuButton(),
                              );
                            }
                           ).toList(),
                        );
                    }
                );
              }, future: null,

            //  return new Text('loading...');

      )

    );
  }
    deleteData(docId) {
      FirebaseFirestore.instance.collection('Add_Errands').doc(docId).delete().catchError((e) {
        print(e);
      } );
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

void setState(Null Function() param0) {
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

