import 'package:InvoiceGenerator/tables/add_client.dart';
import 'package:InvoiceGenerator/tables/get_companyname.dart';
import 'package:InvoiceGenerator/model/client_model.dart';
import 'package:quickalert/quickalert.dart';
import 'package:flutter/material.dart';
import '../database/databese_invoice.dart';

class GetClient extends StatefulWidget
{
  const GetClient({Key? key}) : super(key: key);
  @override
  State<GetClient> createState() => _GetClientState();
}

class _GetClientState extends State<GetClient> {
  DatabaseInvoice di = DatabaseInvoice();
  @override
  List<ClientModel> localList = [];
  List<ClientModel> searchlist = [];
  TextEditingController txt1 = TextEditingController();
  bool isgetdata = true;
  bool isSearching = false;
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xfff8f9fc),
        appBar: AppBar(
            title: isSearching ?
            Container(
              height: 50,
              margin: EdgeInsets.all(10),
              child: TextFormField(
                controller: txt1,
                onChanged: (value) {
                  setState(() {
                    searchlist.clear();
                    for (int i = 0; i < localList.length; i++) {
                      if (localList[i].Client_name!.toLowerCase().
                      contains(value.toLowerCase())) {
                        searchlist.add(localList[i]);
                      }
                    }
                  });
                  isgetdata = false;
                  setState(() {});
                },
                decoration: InputDecoration(
                  labelText: "Search",
                ),
                style: TextStyle(fontSize: 17),
              ),
            )
                :
            Text("Clients", style: TextStyle(
                fontSize: 18,
                fontFamily: "Roboto-Bold",
                color: Color(0xff00031c)),),
            backgroundColor: Color(0xffffffff),
            leading: GestureDetector(
              child: Icon(Icons.arrow_back_ios, color: Colors.black,),
              onTap: () {
                setState(() {
                  Navigator.pop(context);
                });
              },
            ),
            actions: isSearching
                ?
            [
              IconButton(
                  icon: Icon(Icons.clear,size: 24,color: Color(0xff0006ca)),
                  onPressed: () {
                    setState(() {
                      isSearching = false;
                      txt1.clear();
                      searchlist.clear();
                      searchlist.addAll(localList);
                    });
                  }
              )
            ]
                :
            [
              IconButton(
                icon: Icon(Icons.search,size: 24,color: Color(0xff0006ca)),
                onPressed: () {
                  setState((){
                    isSearching = true;
                  });
                },
              ),
            ]
        ),
        body: FutureBuilder<bool>(builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder<List<ClientModel>>(
                builder: (context, snapshot) {
                  if (snapshot.data != null && snapshot.data!.length > 0) {
                    if (isgetdata) {
                      localList.clear();
                      searchlist.clear();
                      localList.addAll(snapshot.data!);
                      searchlist.addAll(localList);
                    }
                    return
                      Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemBuilder: ((BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.pop(context, searchlist[index]);
                                  },
                                  child: Dismissible(
                                    key: UniqueKey(),
                                    child: Card(
                                      // color: Colors.grey.shade300,
                                      elevation: 5,
                                      borderOnForeground: true,
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        child: Row(
                                          //crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        CircleAvatar(
                                                          radius: 20,
                                                          backgroundImage:
                                                          AssetImage("assets/images/person1.png"),
                                                        ),
                                                        SizedBox(width: 8,),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            Text(
                                                              (searchlist[index]
                                                                  .Client_name
                                                                  .toString()),
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.bold,
                                                              fontFamily:'Roboto-Medium',
                                                              color: Color(0xff000000)),),
                                                            Text(
                                                              (searchlist[index]
                                                                  .Email
                                                                  .toString()),
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontFamily:'RobotoCondensed-Regular',
                                                              color: Color(0xff757f93)),),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    // Text((searchlist[index].Client_id.toString())),
                                                    // Text((searchlist[index].Client_name.toString())),
                                                    // Text((searchlist[index].Address.toString())),
                                                    // Text((searchlist[index].Mo_no.toString())),
                                                    // Text((searchlist[index].Email.toString())),
                                                    // Text((searchlist[index].GST_no.toString())),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    background: leftEditIcon,
                                    // right side
                                    secondaryBackground: rightDeleteIcon,
                                    onDismissed: (DismissDirection direction) {
                                      if (direction ==
                                          DismissDirection.startToEnd) {
                                        // Left to right
                                        setState(() {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return AddClient(
                                                    model: searchlist[index],);
                                                },)).then((value) {
                                            if (value == true) {
                                              localList.clear();
                                              searchlist.clear();
                                              isgetdata = true;
                                              setState(() {});
                                            }
                                          });
                                        });
                                      } else if (direction ==
                                          DismissDirection.endToStart) {
                                        // Right to left
                                        setState(() {
                                          alertconfirmfordelete(searchlist[index]
                                              .Client_id) ;
                                        });
                                      }
                                    },
                                  ),
                                );
                              }
                              ),
                              itemCount: searchlist.length,
                            ),
                          ),
                        ],
                      );
                  }
                  else {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return AddClient(
                              model: null,
                            );
                          },
                        ));
                      },
                      child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 55,
                                backgroundImage:
                                AssetImage("assets/images/add_person1.jpg"),
                              ),
                              SizedBox(height: 10,),
                              Text(
                                "you don't have any client.",
                                style: TextStyle(
                                    fontSize: 14,
                                    //fontWeight: FontWeight.bold,
                                    fontFamily: "Roboto-Regular",
                                    color: Color(0xff00031c)),
                              ),
                              SizedBox(height: 5,),
                              Text(
                                "Click on the plus button below to create your first client!",
                                style: TextStyle(fontSize: 12,
                                    fontFamily: 'RobotoCondensed-Thin',
                                    color: Color(0xff505050)),
                              ),
                            ],
                          )),
                    );
                  }
                },
                future: isgetdata
                    ? DatabaseInvoice().getdatafromClientemodel()
                    : null
            );
          }
          else {
            return CircularProgressIndicator();
          }
        },
            future: DatabaseInvoice().copyPasteAssetFileToRoot()),

        // floating button for add the new client
        floatingActionButton: Container(
          height: 35,
          width: 35,
          child: FloatingActionButton(
              backgroundColor: Color(0xff0006ca),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return AddClient(model: null);
                    })).then((value) {
                  if (value == true) {
                    localList.clear();
                    searchlist.clear();
                    isgetdata = true;
                    setState(() {});
                  }
                });
                ;
              },
              child: Icon(Icons.add, size: 24, color: Colors.white,)
          ),
        ),
      ),
    );
  }

  // left swipleble for edit
  final leftEditIcon = Container(
    color: Colors.green,
    child: Icon(Icons.edit),
    alignment: Alignment.centerLeft,
  );

  // right swipleble for delete
  final rightDeleteIcon = Container(
    color: Colors.red,
    child: Icon(Icons.delete),
    alignment: Alignment.centerRight,
  );


// alert message for delete
  void alertdialogfordelete()
  {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: 'Delete Client Successfully!',
    );
  }

 // confirm message for delete
  void alertconfirmfordelete(id)
  {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: 'Do you want to delete this Client',
      confirmBtnText: 'Yes',onConfirmBtnTap: () async {
      await di.deleteClient(id);
      localList.clear();
      searchlist.clear();
      isgetdata = true;
      setState(() {
      });
      Navigator.of(context).pop();
      alertdialogfordelete();
    },
      cancelBtnText: 'No',onCancelBtnTap: () {
      Navigator.of(context).pop();
    },
      confirmBtnColor: Colors.green,
    );
  }

}
