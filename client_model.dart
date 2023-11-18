import 'dart:ffi';
class ClientModel {

  int? Client_id;
  String? Client_name;
  String? Address;
  int? Mo_no;
  String? Email;
  String? GST_no;

  ClientModel(
      {this.Client_id,
        this.Mo_no,
        this.Client_name,
        this.Address,
        this.Email,
        this.GST_no,});

  ClientModel.fromJson(Map<String, dynamic> json) {
    Client_id = json['Client_id'];
    Client_name = json['Client_name'];
    Address = json['Address'];
    Mo_no = json['Mo_no'];
    Email = json['Email'];
    GST_no = json['GST_no'];
  }
}


