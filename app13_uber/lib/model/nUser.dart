class nUser {
  String _userId = "";
  late String _name;
  late String _email;
  late String _password;
  late String _userType;

  double _latitude = 0;
  double _longitude = 0;

  nUser();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "userId": userId,
      "name": name,
      "email": email,
      "userType": userType,
      "latitude": latitude,
      "longitude": longitude,
    };

    return map;
  }

  String verifyUserType(bool userType) {
    return userType ? "driver" : "passenger";
  }

  String get userType => _userType;

  set userType(String value) {
    _userType = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
  }

  double get longitude => _longitude;

  set longitude(double value) {
    _longitude = value;
  }

  double get latitude => _latitude;

  set latitude(double value) {
    _latitude = value;
  }
}
