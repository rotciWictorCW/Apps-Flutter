
class Message {

  String? _UserId;
  String? _message;
  String? _imageUrl;

  String? _type;
  String? _date;

  Message();

  Map<String, dynamic> toMap(){

    Map<String, dynamic> map = {
      "userId" : this.UserId,
      "message" : this.message,
      "imageUrl" : this.imageUrl,
      "type" : this.type,
      "date" : this.date
    };

    return map;

  }

  String get date => _date!;

  set date(String value) {
    _date = value;
  }

  String get type => _type!;

  set type(String value) {
    _type = value;
  }

  String get imageUrl => _imageUrl!;

  set imageUrl(String value) {
    _imageUrl = value;
  }

  String get message => _message!;

  set message(String value) {
    _message = value;
  }

  String get UserId => _UserId!;

  set UserId(String value) {
    _UserId = value;
  }
}