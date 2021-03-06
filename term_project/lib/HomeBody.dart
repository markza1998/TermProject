import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'login_button/twiiter.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:flutter/services.dart';
import 'package:term_project/HomePage.dart';
class HomeBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<HomeBody> {
  static final TwitterLogin twitterLogin = TwitterLogin(
    consumerKey: 'V6WhIk4MThLDHOZffp5ePjhxb',
    consumerSecret: '0mBgQEhDmlCJYFiEuzv49bwauCKzvBHh7yg2ph5QksMNxHTaOQ',
  );
  String _title = "";

  void _login() async {
    final TwitterLoginResult result = await twitterLogin.authorize();
    String Message;
    int error=0;
    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        Message = 'คุณ ${result.session.username}';
        break;
      case TwitterLoginStatus.cancelledByUser:
        Message = 'Login cancelled by user.';
        error=1;
        break;
      case TwitterLoginStatus.error:
        Message = 'Login error: ${result.errorMessage}';
        error=2;
        break;
    }

    setState(() {
      if(error==0)
          _title = Message;
      print('tile :::::' + _title);
    });
  }

  void _logout() async {
    await twitterLogin.logOut();

    setState(() {
      _title = "";
    });
  }

  final MethodChannel _channel = const MethodChannel('flutter_share_me');

  Future<String> shareToTwitter({String msg = '', String url = ''}) async {
    final Map<String, Object> arguments = Map<String, dynamic>();
    arguments.putIfAbsent('msg', () => msg);
    arguments.putIfAbsent('url', () => url);
    dynamic result;
    try {
      result = await _channel.invokeMethod('shareTwitter', arguments);
    } catch (e) {
      return "false";
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return _title.length==0 ? loginUI() : mainUI();

  }

  Widget loginUI() {
    return Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top:80),
            child: Image.asset('assets/images/logo3.png', height: 150,),
          ),
          Container(
            padding: EdgeInsets.only(left: 10 , right: 10,bottom: 30),
            child: Text(
              "OMB คือแอพพลิเคชันสำหรับตรวจสอบคำ Bully ภาษาไทยก่อนข้อความนั้นจะถูกโพสลงบน Twitter",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Container()),
          Container(
            child: Column(
              children: <Widget>[
                  Container(
                    child: TwitterSignInButton(
                      onPressed: _login,
                    ),
                  ),
                Container(
                    padding: EdgeInsets.only(bottom: 20,top: 15,right: 20 , left: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                       Container(
                             child : Icon(Icons.info,color: Colors.white,)
                       ),
                        Expanded(child: Container(
                          child: Text("ผู้ใช้งานจะต้องมีบัญชี Twitter ก่อน"
                              "ถึงจะสามารถใช้งานได้",textAlign: TextAlign.center,style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),),
                        ),)
                      ],
    )

                )]),
                    )
                ]);

  }
  final TextEditingController _bullywordController = TextEditingController();
  Color color1 = HexColor("ffcde8");
  Widget mainUI() {
    return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top:80),
              child: Image.asset('assets/images/logo3.png', height: 150,),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, ),
              child : Text('ยินดีต้อนรับ'+_title, style: TextStyle(
                  fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white
              ), textAlign: TextAlign.center,),
            ),

            Expanded(child: Container(
              padding: EdgeInsets.only(top: 20, bottom: 10, right: 20 , left: 20),
              width: 300,
              child: TextField(
                controller: _bullywordController,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: color1,
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: color1)),
                    labelText: 'กรอกประโยคที่ต้องการ Tweet'),
              ),
            ),),
            ButtonTheme(
              minWidth: 300.0,
              child: RaisedButton(
                onPressed: () async {
                  var response = await FlutterShareMe().shareToTwitter(
                      msg: _bullywordController.text);
                  if (response == 'success') {
                   //showAlertDialog(context, 'ทวีตข้อความสำเร็จ');
                  }
                },
                color: Colors.blueAccent,
                textColor: Colors.white,
                padding: EdgeInsets.only(right: 30 , left: 30, bottom: 10, top: 10),
                child: Text("Tweet on Twitter".toUpperCase(),
                    style: TextStyle(fontSize: 25)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: Colors.blueAccent)),

              ),
            ),
           Container(
             padding: EdgeInsets.only(top: 30 , bottom: 30),
             child:  ButtonTheme(
               minWidth: 300.0,
               child: RaisedButton(
                 color: Colors.red,
                 textColor: Colors.white,
                 padding: EdgeInsets.only(right: 30 , left: 30, bottom: 10, top: 10),
                 child: Text("Log Out".toUpperCase(),
                     style: TextStyle(fontSize: 25)),
                 shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(20.0),
                     side: BorderSide(color: Colors.red)),
                 onPressed: _logout,
               ),
             ),
           )
          ],
        );

  }
  showAlertDialog(BuildContext context, String text) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {

      Navigator.pop(context);},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Result"),
      content: Text(text),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
