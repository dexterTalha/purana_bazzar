class AdModel{
  String id, parent, child, title, price, address;
  bool isPrime;
  List<String> images;

  AdModel({this.id, this.parent, this.child, this.title, this.price, this.address, this.isPrime, this.images});
  factory AdModel.fromJson(Map<String, dynamic> map){
    return AdModel(
      id: map['id'],
      parent: map['parent_id'],
      child: map['cat_id'],
      title: map['title'],
      price: map['price'],
      address: map['address'],
      images: map['thumbnail'].toString().split(","),
      isPrime: map['isprime']
    );
  }
}
