class Categorylistmodal  {
  String? photo;
  String? names;
  int? category_id;
  String? slug;

  Categorylistmodal({this.photo,this.names,this.slug,this.category_id});

  Categorylistmodal.fromJson(Map<String, dynamic> json) {
    photo = json['photo'];
    names = json['names'];
    category_id = json['category_id'];
    slug= json['slug'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['photo'] = photo;
    data['names'] = names;
    data['category_id'] = category_id;
    data['slug'] = slug;
    return data;
  }
}

