class Post {
  int id;
  String description;
  String content;
  String postImage;
  String title;
  bool pin;


  Post({this.id, this.description, this.postImage,this.content,this.title,this.pin});


  void setPin(bool pin){

    this.pin=pin;

  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      postImage: json['image'],
      content:json['content'],
      pin:json['pin']
    );
  }
}