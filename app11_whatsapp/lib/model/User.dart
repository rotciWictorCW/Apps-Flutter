
class nUser {

  String? _idUser;
  String? _name;
  String? _email;
  String? _password;
  String? _imageUrl;

  nUser();

  Map<String, dynamic> toMap(){

    Map<String, dynamic> map = {
      "name" : this.name,
      "email" : this.email
    };

    return map;

  }

  String get idUser => _idUser!;

  set idUser(String value) {
    _idUser = value;
  }

  String get password => _password!;

  set password(String value) {
    _password = value;
  }

  String get email => _email!;

  set email(String value) {
    _email = value;
  }

  String get name => _name!;

  set name(String value) {
    _name = value;
  }

  String get imageUrl => _imageUrl!;

  set imageUrl(String value) {
    _imageUrl = value;
  }
}