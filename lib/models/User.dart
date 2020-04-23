class User {
  int id;
  String username;
  String password;

  User({this.id, this.username, this.password});

  User.empty(){
    
  }




   Map<String, dynamic> toMapWithoutId() {
   final map = new Map<String, dynamic>();
   map["username"] = username;
   map["password"] = password;
   return map;
 }

Map<String, dynamic> toMap() {
   final map = new Map<String, dynamic>();
   map["id"] = id;
   map["username"] = username;
   map["password"] = password;
   return map;
 }

 //to be used when converting the row into object
 factory User.fromMap(Map<String, dynamic> data) => new User(
     id: data['id'],
     username: data['username'],
     password: data['password']
 );



}