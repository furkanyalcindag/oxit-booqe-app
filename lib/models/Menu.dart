class Menu {
  final int id;
  final String categoryName;
  final String categoryImage;

  Menu({this.id, this.categoryName, this.categoryImage});

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'],
      categoryName: json['categoryName'],
      categoryImage: json['categoryImage'],
    );
  }
}