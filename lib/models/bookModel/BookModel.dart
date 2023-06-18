class BookModel {
  List<ItemsData> items = [];

  BookModel.fromJson(Map<String, dynamic> json) {
    for (var element in json['items']) {
      items.add(ItemsData.fromJson(element));
    }
  }
}

class ItemsData {
  String? id;
  String? etag;
  VolumeInfo? volumeInfo;
  AccessInfo? accessInfo;

  ItemsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    etag = json['etag'];
    volumeInfo = (json['volumeInfo'] != null)
        ? VolumeInfo.fromJson(json['volumeInfo'])
        : null;
    accessInfo = (json['accessInfo'] != null)
        ? AccessInfo.fromJson(json['accessInfo'])
        : null;
  }
}

class VolumeInfo {
  String? title;
  String? subtitle;
  String? publishedDate;
  dynamic pageCount;
  dynamic averageRating;
  String? language;
  List<dynamic>? authors;
  ImageLinks? imageLinks;
  String? previewLink;

  VolumeInfo.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    subtitle = json['subtitle'];
    authors = json['authors'];
    publishedDate = json['publishedDate'];
    pageCount = json['pageCount'];
    language = json['language'];
    averageRating = json['averageRating'];
    previewLink = json['previewLink'];
    imageLinks = (json['imageLinks'] != null)
        ? ImageLinks.fromJson(json['imageLinks'])
        : null;
  }
}

class ImageLinks {
  String? smallThumbnail;
  String? thumbnail;

  ImageLinks.fromJson(Map<String, dynamic> json) {
    smallThumbnail = json['smallThumbnail'];
    thumbnail = json['thumbnail'];
  }
}

class AccessInfo {
  String? country;
  String? webReaderLink;
  Epub? epub;

  AccessInfo.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    webReaderLink = json['webReaderLink'];
    epub = (json['epub'] != null) ? Epub.fromJson(json['epub']) : null;
  }
}

class Epub {
  String? downloadLink;

  Epub.fromJson(Map<String, dynamic> json) {
    downloadLink = json['downloadLink'];
  }
}
