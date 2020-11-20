class AdSliderModel{
  String id, image, url;

  AdSliderModel({this.id, this.image, this.url});

  factory AdSliderModel.fromJson(Map<String, dynamic> map) {
    return AdSliderModel(
      id: map['id'],
      image: map['image'],
      url: map['url'],
    );
  }
}