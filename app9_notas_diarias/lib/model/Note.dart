class Note{

  int? id;
  final String title;
  final String description;
  String date;

  Note({
      this.id,
      required this.title,
      required this.description,
      required this.date,
});

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'title' : title,
      'description': description,
      'date' : date,
    };



  }
  }


  /* Map toMap(){

    Map<String, dynamic> map = {
    "title": this.title,
    "description": this.description,
    "date": this.date,
  };

    if( this.id != null){
      map["id"] = this.id;
    }

    return map;
  }

}

   */
