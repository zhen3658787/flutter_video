class BannerEntity {
  String title = '';
  String url = '';
  String image = '';
  String bannerimg = '';
  int type = -1;
  int urlType = -1;

  BannerEntity();

  factory BannerEntity.fromJson(Map<String, dynamic> json) {
    BannerEntity banner = BannerEntity();
    banner.title = json['title'];
    banner.url = json['url'];
    banner.image = json['image'];
    banner.bannerimg = json['bannerimg'];
    banner.type = json['type'];
    banner.urlType = json['urlType'];
    return banner;
  }

  @override
  String toString() {
    return title.toString();
  }
}
