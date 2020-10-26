class CarouselModel{
  String image;
  CarouselModel(this.image);
}
List<CarouselModel>carousels =
    carouselsData.map((item)=> CarouselModel(item['image'])).toList();
var carouselsData = [
  {"image": "images/1.jpg"},
  {"image": "images/2.jpg"},
  {"image": "images/3.jpg"},
];