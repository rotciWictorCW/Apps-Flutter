class user_n {
  late String userId;
  late String name;
  late String email;
  late String password;

  user_n();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "idUsuario": userId,
      "nome": name,
      "email": email
    };

    return map;
  }
}
// a class in this way works???
