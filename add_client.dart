import 'package:InvoiceGenerator/model/client_model.dart';
import 'package:InvoiceGenerator/tables/get_client.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quickalert/quickalert.dart';
import '../database/databese_invoice.dart';

class AddClient extends StatefulWidget {
  late ClientModel ?model;
  AddClient({required this.model});
  @override
  State<AddClient> createState() => _AddClientState();
}

TextEditingController Client_name=TextEditingController();
TextEditingController Client_address=TextEditingController();
TextEditingController Client_mono=TextEditingController();
TextEditingController Client_email=TextEditingController();
TextEditingController Client_gstno=TextEditingController();
DatabaseInvoice di=DatabaseInvoice();

class _AddClientState extends State<AddClient>
{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Client_name.text= widget.model != null ? widget.model!.Client_name! : '';
    Client_address.text= widget.model != null ? widget.model!.Address! : '';
    Client_mono.text= widget.model != null ? widget.model!.Mo_no.toString()! : '';
    Client_email.text= widget.model != null ? widget.model!.Email! : '';
    Client_gstno.text= widget.model != null ? widget.model!.GST_no!: '';
  }
  var formKey=GlobalKey<FormState>();
  List<ClientModel> localList = [];
  List<ClientModel> searchlist = [];
  bool isgetdata = true;
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff8f9fc),
      appBar: AppBar(backgroundColor:Colors.white,
        leading: GestureDetector(
          child: Icon( Icons.arrow_back_ios, color: Colors.black,  ),
          onTap: () {
            Navigator.pop(context);
          } ,
        ) ,
        title: Text("Add the Client",
          style: TextStyle(  fontSize: 18,
              fontFamily: "Roboto-Bold",
              color: Color(0xff00031c)
          ),)),
      body: Form(
        key: formKey,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Column(children: [
              SizedBox(height: 10,),

              // client name textfield
              Container(
                margin: EdgeInsets.all(10),
                child: TextFormField(
                  controller: Client_name,
                decoration: InputDecoration(
                  labelText: "Client name",
                    border: (OutlineInputBorder(
                        borderRadius: (BorderRadius.circular(0))))
                ),
                  style: TextStyle(fontSize: 16,
                      fontFamily:'Roboto-Light',
                      color: Color(0xff000000)),
                  validator: (value) {
                    if(value !=null && value.isEmpty)
                    {
                      return "Please enter a client name";
                    }
                    else if(value!.length<3)
                    {
                      return "Please enter a valid client name";
                    }
                  },
                ),
              ),

              // client name address
              Container(
                margin: EdgeInsets.all(10),
                child: TextFormField(controller: Client_address,
                    decoration: InputDecoration(
                        labelText: "Address",
                        border: (OutlineInputBorder(
                            borderRadius: (BorderRadius.circular(0))))),
                    style: TextStyle(fontSize: 16,
                        fontFamily:'Roboto-Light',
                        color: Color(0xff000000)),
                  validator: (value) {
                    if(value !=null && value.isEmpty)
                    {
                      return "Please enter a address";
                    }
                    else if(value!.length<3)
                    {
                      return "Please enter a valid address";
                    }
                  },
                ),
              ),

              // client Mo.no textfield
              Container(
                margin: EdgeInsets.all(10),
                child: TextFormField(controller: Client_mono,
                    decoration: InputDecoration(
                        labelText: "Mo.no",
                        hintText: "ex. +911234567890",
                        border: (OutlineInputBorder(
                            borderRadius: (BorderRadius.circular(0))))),
                  keyboardType:TextInputType.number,
                  style: TextStyle(fontSize: 16,
                      fontFamily:'Roboto-Light',
                      color: Color(0xff000000)),
                  validator: (value) {
                    if(value !=null && value.isEmpty)
                    {
                      return "Please enter a mo.no";
                    }
                    else if(value!.length<10)
                    {
                      return "Please enter a valid mo.no";
                    }
                  },
                ),
              ),

              // client email textfield
              Container(
                margin: EdgeInsets.all(10),
                child: TextFormField(controller: Client_email,
                  decoration: InputDecoration(
                      labelText: "Email",
                    hintText: "ex.abc@gmail.com",
                      border: (OutlineInputBorder(
                          borderRadius: (BorderRadius.circular(0))))),
                  style: TextStyle(fontSize: 16,
                      fontFamily:'Roboto-Light',
                      color: Color(0xff000000)),
                  validator: (value) {
                    if(value !=null && value.isEmpty)
                    {
                      return "Please enter a email";
                    }
                    else if(value!.length<10)
                    {
                      return "Please enter a valid email";
                    }
                  },
                ),
              ),

              //client GST NO textfield
              Container(
                margin: EdgeInsets.all(10),
                child: TextFormField(controller: Client_gstno,
                  decoration: InputDecoration(
                      labelText: "GST.No",
                      hintText: "ex.00AAAAA0000A0Z5",
                      border: (OutlineInputBorder(
                          borderRadius: (BorderRadius.circular(0))))),
                  style: TextStyle(fontSize: 16,
                      fontFamily:'Roboto-Light',
                      color: Color(0xff000000)),
                  validator: (value) {
                    if(value !=null && value.isEmpty)
                    {
                      return "Please enter a gst no";
                    }
                    else if(value!.length<15)
                    {
                      return "Please enter a valid gst no";
                    }
                  },
                ),
              ),

              SizedBox(height: 20,),

              // text button container
              Container(
                margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    color: Color(0xff0006ca),
                  ),
                child: TextButton(onPressed: ()
                async {
                  if(formKey.currentState!.validate())
                  {
                    if(widget.model==null)
                    {
                      alertconfirmforinsert();
                    }
                    else {
                      // showAlertDialogtoedit(context,widget.model!.Client_id);
                      alertconfirmforupdate(widget.model!.Client_id);
                    }
                  }
                },
                  style: TextButton.styleFrom(shadowColor: Colors.green,),
                  child: Container(
                    child: Center(
                      child: Text("Save",
                        style: TextStyle(  fontFamily: 'Roboto-Medium',
                            fontSize: 14, color: Color(0xffffffff)
                          //background:  borderRadius: BorderRadius.all(Radius.circular(20)
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ]),
          ],
        ),
      ),
    );
  }
  showAlertDialogtoedit(BuildContext context,id) {
    // set up the buttons
    Widget yesButton = TextButton(
        child: Text("Yes"),
        onPressed:  () async {
          await di.updateclient(
              Client_name: Client_name.text,
              Address: Client_address.text,
              Mo_no: Client_mono.text,
              Email: Client_email.text,
              GST_no: Client_gstno.text,
              Client_id:id
            //widget.model!=null?
          ).then((value) => Navigator.of(context).pop(true));
          Navigator.of(context).pop(true);

        }
    );
    Widget noButton = TextButton(
      child: Text("No"),
      onPressed:  () {
        // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        //   return GetClient();
        // },));
        setState(() {
        });
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Edit"),
      content: Text("Are you sure want to Edit this user??"),
      actions: [
        yesButton,
        noButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void alertdialogforinsert()
  {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: 'Client details added Successfully!',
    );
  }

  void alertconfirmforinsert()
  {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: 'Do you want to add this client details',
      confirmBtnText: 'Yes',onConfirmBtnTap: () async {
      await di.insertclient(
        Client_name: Client_name.text,
        Address: Client_address.text,
        Mo_no: Client_mono.text,
        Email: Client_email.text,
        GST_no: Client_gstno.text,
      ).then((value) => Navigator.of(context).pop(true));
      Navigator.of(context).pop(true);
      alertdialogforinsert();
    },
      cancelBtnText: 'No',onCancelBtnTap: () {
      Navigator.of(context).pop();
    },
      confirmBtnColor: Colors.green,
    );
  }

  void alertdialogforupdate()
  {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: 'Client details updateed Successfully!',
    );
  }

  void alertconfirmforupdate(id)
  {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: 'Do you want to Update this client details',
      confirmBtnText: 'Yes',onConfirmBtnTap: () async {
      await di.updateclient(
          Client_name: Client_name.text,
          Address: Client_address.text,
          Mo_no: Client_mono.text,
          Email: Client_email.text,
          GST_no: Client_gstno.text,
          Client_id:id)
          .then((value) => Navigator.of(context).pop(true));
      Navigator.of(context).pop(true);
      alertdialogforupdate();
    },
      cancelBtnText: 'No',onCancelBtnTap: () {
      Navigator.of(context).pop();
    },
      confirmBtnColor: Colors.green,
    );
  }

  void showalert() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Oops...',
      text: 'Sorry, something went wrong',
      backgroundColor: Colors.black,
      titleColor: Colors.white,
      textColor: Colors.white,
    );
  }

}
