class ActivityModel {
  String name = "";
  String manager = "";
  String password = "";
  String id = "";

  ActivityModel(
      {required this.name,
      required this.manager,
      required this.password,
      required this.id});

  // ActivityModel.fromJson(Map<String, dynamic> json) {
  //   name = json['name'];
  //   manager = json['manager'];
  //   password = json['password'];
  //   id = json['id'];
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['name'] = this.name;
  //   data['manager'] = this.manager;
  //   data['password'] = this.password;
  //   data['id'] = this.id;
  //
  //   return data;
  // }
}
