import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

late String userID;
late String? _email, _displayName, _phoneNumber, _userRole;
late final DocumentSnapshot? userInfo;

late final  User _user = FirebaseAuth.instance.currentUser!;


class accepterrd_user extends StatefulWidget {
  final String title;


  const accepterrd_user(String s,  {Key? key, required this.title}) : super(key: key);
  @override
  _accepterrd_userState createState() => _accepterrd_userState();
}

final FirebaseMessaging _fcm = FirebaseMessaging.instance;

class _accepterrd_userState extends State<accepterrd_user> {

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
    try {
      userInfo = await FirebaseFirestore.instance
          .collection('User_information')
          .doc(_user.uid)
          .get().whenComplete(() => userID = _user.uid);

    } catch (e) {
      print(e);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Active Errands',style: TextStyle(color: Colors.brown[400]),),
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

  late String phone;
  dynamic txtPhone_;


  @override
  Widget build(BuildContext context) {

    return Container(
      child:
        FutureBuilder(
          //  future: FirebaseAuth.instance.currentUser(),
            builder: (context,AsyncSnapshot<FirebaseAuth> snapshot){

      final Stream<QuerySnapshot> _usersStream =  FirebaseFirestore.instance.collection('Add_Errands').where('userId', isEqualTo: userID)
          .where('Status', isEqualTo: 'Accepted').orderBy('Date',descending:true).snapshots();


                return StreamBuilder(
                      stream: _usersStream,
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){

              if(snapshot.hasData == false){
                     return Center(
                        child: Text('No errand has been accepted'),
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
              children: snapshot.data!.docs.map(
              (DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;


              void showToast() {
              Fluttertoast.showToast(
              msg: 'Document deleted',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.red,
              textColor: Colors.white
              );
              }


              Widget popupMenuButton(){
              return PopupMenuButton<String> (

              icon: Icon(Icons.more_vert),
              itemBuilder: (BuildContext context)=><PopupMenuEntry<String>>[

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
              onSelected: (retValue){
              if(retValue == '3'){
              showDialog(context: context,
              builder: (context) => AlertDialog(

              content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
              Container(
              height: 100.0,
              child:
              Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[
              IconButton(icon: Icon(Icons.phone),
              iconSize: 50.0,
              onPressed: (){
              launch(('tel://07011133131'));
              },
              ),
              SizedBox(height: 5.0),
              Text('call'),
              ]
              ),
              ),
              Container(
              height: 100.0,
              child:
              Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[
              IconButton(icon: Icon(Icons.textsms),
              iconSize: 50.0,
              onPressed: (){
              launch(('sms://07011133131'));
              }
              ),
              SizedBox(height: 5.0),
              Text('text'),
              ]
              ),
              ),
              Container(
              height: 100.0,
              child:
              Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[
              IconButton(icon: Icon(Icons.message),
              iconSize: 50.0,
              onPressed: ()async => await launch(
              "http://wa.me/${2347011133131} ?text= Errand App"
              )
              ),
              SizedBox(height: 5.0),
              Text('whatsApp'),
              ]
              )
              ),
              ]
              ),
              actions: <Widget>[
              Row(
              children: <Widget>[
              TextButton(onPressed: ()=> Navigator.of(context).pop(),
              child:Text('CANCEL')
              ),
              SizedBox(height: 60.0,)
              ],
              ),

              ],
              )
              );
              }

              }
              );
              }

              phone = Text(data['Phone_number']) as String;
              txtPhone_ = Text(data['Phone_number']);

              return ListTile(
              onTap: (){navigateToDetail(snapshot.data!.docs[index]);},
              title:
              Text(data['Title'],
              style: TextStyle(
              fontWeight: FontWeight.w500
              ),
              ),

              subtitle: Text(data['Location']),
              trailing:
              popupMenuButton(),
              );

              }).toList()

              );

              }
              );

              }, future: null,


        )

    );
  }


}
void showToast() {
  Fluttertoast.showToast(
      msg: 'Document updated',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.red,
      textColor: Colors.white
  );
}

void setState(Null Function() param0) {
}

updateData(selectedDoc,newValues){
  FirebaseFirestore.instance.collection('Add_Errands').doc(selectedDoc).update(newValues).catchError((e) {
    print(e);
  });
}




class DetailPage extends StatefulWidget {
   DocumentSnapshot errand;

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
                              child: Text(widget.errand.get('userId'),
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

