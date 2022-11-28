class Post{
  int? _id;
  String? _title;
  String? _description;

  Post(this._id, this._title, this._description);

  Map toJson() {
    return {
      "id": this._id,
      "title": this._title,
      "description": this._description
    };
  }

  String get description => _description!;

  set description(String value) {
    _description = value;
  }

  String get title => _title!;

  set title(String value) {
    _title = value;
  }

  int get id => _id!;

  set id(int value) {
    _id = value;
  }
}