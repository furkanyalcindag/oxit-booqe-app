import 'package:flutter/material.dart';
import 'package:oxit_booqe_app/services/profile_methods.dart';


class ChangePassword extends StatefulWidget {
  @override
  ChangePasswordState createState() {
    return ChangePasswordState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class ChangePasswordState extends State<ChangePassword> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  
  bool currentPassword = true;
  bool newPassword = true;
  bool repeatPassword = true;
  bool isMatch = true;

  TextEditingController currentPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();

  TextEditingController repeatPassController = TextEditingController();
  ProfileMethods profileMethods = new ProfileMethods();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    currentPassController.dispose();
    newPassController.dispose();
    repeatPassController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(
          elevation: 0,
          brightness: Brightness.light,
backgroundColor: Colors.white,
leading: new IconButton(icon: new Icon(Icons.arrow_back,color:  Color.fromRGBO(210, 74, 97, 1),),
            onPressed: () => Navigator.pop(context)


        )),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(backgroundColor: Colors.white,
              body: ListView(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  'Şifre Değiştirme',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextField(
                  controller: newPassController,
                  onChanged: (text) {
                    return print(text);
                  },
                  decoration: InputDecoration(
                   
                    suffixIcon: IconButton(
                      icon: Icon(Icons.remove_red_eye),
                      onPressed: () async {
                        print('dsds');

                        if (newPassword) {
                          setState(() {
                            newPassword = false;
                          });
                        } else {
                          setState(() {
                            newPassword = true;
                          });
                        }
                      },
                    ),
                    border: OutlineInputBorder(),
                    hintText: 'Yeni Şifre',
                  ),
                  autofocus: false,
                  obscureText: newPassword,
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextField(
                    controller: repeatPassController,
                    onChanged: (text) {
                      print(newPassController.text);

                      if (newPassController.text == text) {
                        setState(() {
                          isMatch = true;
                        });
                      } else {
                        setState(() {
                          isMatch = false;
                        });
                      }

                      return print(text);
                    },
                    decoration: InputDecoration(
                      errorText: !isMatch ? 'Şifre eşleşmiyor' : null,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.remove_red_eye),
                        onPressed: () async {
                          print('dsds');

                          if (repeatPassword) {
                            setState(() {
                              repeatPassword = false;
                            });
                          } else {
                            setState(() {
                              repeatPassword = true;
                            });
                          }
                        },
                      ),
                      border: OutlineInputBorder(),
                      hintText: 'Şifre Tekrarı',
                    ),
                    autofocus: false,
                    obscureText: repeatPassword,
                  )),
              Container(
                width: 60.0,
                height: 60.0,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child:Builder(
  builder: (context) =>
                
                
                 RaisedButton(
                   
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.red)),
                    onPressed: () async {

                      if (isMatch&&newPassController.text==repeatPassController.text){
                      int status = await profileMethods
                          .changePassword(newPassController.text);

                      if (status == 200) {
                        final snackBar = SnackBar(
                          content: Text('Şifre Güncellendi'),
                          backgroundColor: Color.fromRGBO(210, 74, 97, 1),
                          
                        );

                        // Find the Scaffold in the widget tree and use
                        // it to show a SnackBar.
                        Scaffold.of(context).showSnackBar(snackBar);
                      }
                      else {
                        final snackBar = SnackBar(
                          content: Text('Şifre güncelleme işlemi başarısız.'),
                          backgroundColor: Color.fromRGBO(210, 74, 97, 1),
                          
                        );

                        // Find the Scaffold in the widget tree and use
                        // it to show a SnackBar.
                        Scaffold.of(context).showSnackBar(snackBar);
                      } }
                      else{
                        return null;
                      }
                    },
                    textColor: Colors.white,
                    color: Color.fromRGBO(210, 74, 97, 1),
                    child: Text(
                      'Şifre Güncelle',
                      style: TextStyle(fontSize: 20),
                    ))),
              )
            ],
          )),
        ));
  }
}
