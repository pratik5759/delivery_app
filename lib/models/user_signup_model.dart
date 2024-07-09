class UserSignupModel {
  String name;
  String email;
  String mobNo;
  String address;
  String password;

  UserSignupModel(
      {required this.name,
      required this.email,
      required this.mobNo,
      required this.address,
      required this.password});

  factory UserSignupModel.fromMap(Map<String, dynamic> map) {
    return UserSignupModel(
        name: map['name'],
        email: map['email'],
        mobNo: map['mobNo'],
        address: map['address'],
        password: map['password']);
  }

  Map<String,dynamic> toMap(){
    return{
      'name': name,
      'email': email,
      'mobNo': mobNo,
      'address': address,
      'password': password,

    };
  }
}
