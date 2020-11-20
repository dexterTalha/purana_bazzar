class CategoryModel{
  String id, image, name, parent;

  CategoryModel({this.id, this.image, this.name, this.parent});
  factory CategoryModel.fromJson(Map<String, dynamic> map){
    return CategoryModel(
      id: map['id'],
      image: map['image'],
      name: map['name'],
      parent: map['parent'],
    );
  }
}