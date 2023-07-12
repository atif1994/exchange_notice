import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';

class GetHomeData{


 static Future<List<Map<String, dynamic>>> fetchUsers() async {
    var db = await Db.create('mongodb+srv://new-user-31:G2zdTCiyKSnJ7D*@exchange-cluster.ahi98e4.mongodb.net/scrapy');
    await db.open();
inspect(db);
    var collection = db.collection('kdpw');
   var user = await collection.find().toList();

    await db.close();

    return user;
  }
}