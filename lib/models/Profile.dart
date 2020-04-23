class Profile {
  String profileImage;
  String username;
  int pinCount;
  bool notification;
  String email;

  Profile(
      {this.profileImage,
      this.username,
      this.pinCount,
      this.email,
      this.notification});

  Profile.empty() {}

  Map<String, dynamic> toMapWithoutId() {
    final map = new Map<String, dynamic>();
    map["username"] = username;
    map["profileImage"] = profileImage;
    map["pinCount"] = pinCount;
    map["notification"] = notification;
    map["email"] = email;
    return map;
  }

  Map<String, dynamic> toMap() {
    final map = new Map<String, dynamic>();
    map["username"] = username;
    map["profileImage"] = profileImage;
    map["pinCount"] = pinCount;
    map["notification"] = notification;
    map["email"] = email;
    return map;
  }

  //to be used when converting the row into object
  factory Profile.fromMap(Map<String, dynamic> data) => new Profile(
        profileImage: data['profileImage'],
        username: data['username'],
        pinCount: data['pinCount'],
        notification: data['notification'],
        email: data['email'],
      );

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
        profileImage: json['profileImage'],
        username: json['username'],
        pinCount: json['pinCount'],
        notification: json['notification'],
        email: json['email']
        
        
        
        );
  }
}
