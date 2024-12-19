class History {
  String? title;
  String? data;

  History({this.title, this.data});

  History.fromJson(Map<dynamic, dynamic> json) {
    title = json['title'];
    data = json['data'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['title'] = this.title;
    data['data'] = this.data;
    return data;
  }
}
