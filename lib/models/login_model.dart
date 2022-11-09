class LoginModel 
{
  bool? status;
  String? message;
  UserData? data;

 LoginModel.fromJson(Map<String,dynamic>json)
  {
    status=json['status'];
    message=json['message'];
    data=json['data'] != null ? UserData.fromJson(json['data']) : null;
  }


}


class UserData
{
  int? id;
  String? name;
  String? email;
  String? phone;
  String? image;
  String? token;
  int? points;
  int? credit;

  // UserData({
  //   this.email,
  //   this.credit,
  //   this.id,
  //   this.image,
  //   this.name,
  //   this.phone,
  //   this.points,
  //   this.token,
  // });

  UserData.fromJson(Map<String,dynamic>json)
  {
    id=json['id'];
    email=json['email'];
    credit=json['credit'];
    image=json['image'];
    name=json['name'];
    phone=json['phone'];
    points=json['points'];
    token=json['token'];
  }
}