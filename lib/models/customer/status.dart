class Status {
  final String name;
  final int code;

  Status({this.name, this.code});
  
  Status.fromJson(Map<String, dynamic> json)
    : name = json['name'],
      code = int.parse(json['code']);
}