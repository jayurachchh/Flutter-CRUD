import 'dart:ffi';
import 'dart:io';
import 'package:InvoiceGenerator/model/imvoice_product.dart';
import 'package:InvoiceGenerator/model/client_model.dart';
import 'package:InvoiceGenerator/model/company_model.dart';
import 'package:InvoiceGenerator/model/invoice_model.dart';
import 'package:InvoiceGenerator/model/product_model.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class Demo
{
  // init database method
  Future<Database> initDatabase() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String databasePath = join(appDocDir.path, 'Invoice_Generator.db');
    return await openDatabase(
      databasePath,
      version: 2,
    );
  }

  // copypasteAssset method
  Future<bool> copyPasteAssetFileToRoot() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'Invoice_Generator.db');
    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      ByteData data = await rootBundle
          .load(join('assets/database/', 'Invoice_Generator.db'));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await new File(path).writeAsBytes(bytes);
      return true;
    }
    return false;
  }
  // ----------CLIENT TABLE METHOD-----------------


  // get all data from Client model
  Future<List<ClientModel>> getdatafromClientemodel() async {
    List<ClientModel> userlist = [];
    Database db = await initDatabase();
    List<Map<String, Object?>> data =
    await db.rawQuery('select * from Mst_Client');
    for(Map<String,Object?> dt in data)
      userlist.add(ClientModel.fromJson(dt));
    return userlist;
  }

  // get data from Client model pass by Client id
  Future<ClientModel> getdatafromdatabaseclient(Client_id) async {
    ClientModel client = ClientModel();
    Database db = await initDatabase();
    List<Map<String, Object?>> data = await db
        .rawQuery('select * from Mst_Client where Client_id=$Client_id');
    client.Client_id = data[0]['Client_id'] as int;
    client.Client_name = data[0]['Client_name'] as String;
    client.Address = data[0]['Address'] as String;
    client.Mo_no = data[0]['Mo_no'] as int;
    client.Email = data[0]['Email'] as String;
    client.GST_no = data[0]['GST_no'] as String;
    return client;
  }

  // insert data from Client model
  Future<int> insertclient({Client_name, Address, Mo_no, Email, GST_no}) async {
    Database db = await initDatabase();
    Map<String, Object?> map = Map();
    map['Client_name'] = Client_name;
    map['Address'] = Address;
    map['Mo_no'] = Mo_no;
    map['Email'] = Email;
    map['GST_no'] = GST_no;
    int a = await db.insert('Mst_Client', map);
    return Future(() => a);
  }

  // update data from Client Model
  Future<void> updateclient({Client_name, Address, Mo_no, Email, GST_no, Client_id})
  async {
    Database db = await initDatabase();
    Map<String, Object?> map = Map();
    map['Client_name'] = Client_name;
    map['Address'] = Address;
    map['Mo_no'] = Mo_no;
    map['Email'] = Email;
    map['GST_no'] = GST_no;
    await db.update(
      'Mst_Client',
      map,
      where: 'Client_id = ?',
      whereArgs: [Client_id],
    );
  }

  // delete data from Client model pass by Client Id
  Future<void> deleteClient(Client_id) async {
    Database db = await initDatabase();
    int id = await db
        .delete('Mst_Client', where: 'Client_id=?', whereArgs: [Client_id]);
  }


}