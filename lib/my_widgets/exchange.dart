import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../networking/getapi/homeget_api.dart';

class HomeListview extends StatefulWidget {
  const HomeListview({Key? key}) : super(key: key);

  @override
  State<HomeListview> createState() => _HomeListviewState();
}

class _HomeListviewState extends State<HomeListview> {
  final List<Map<String, dynamic>> printerList = [


    {
      "exchange": "eex",
      "title":
          "Comment on the Draft for the Amendment of Electricity Network Access Regulation",
      "file":
          "https://www.eex.com/fileadmin/EEX/Downloads/Newsroom/Publications/Opinions_Expert_Reports/20171109-eex-comment-amendment-stromnzv-bidding-zone-en-data.pdf",
      "published": "2017-11-09",
      "scraped": "2023-07-04",
      "category": "Opinions & Expert Reports"
    },

  ];

final GetHomeData getHomeData=GetHomeData();

  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.of(context).size;

    return Container(
      width: s.width,

      child:FutureBuilder<

          List<Map<String, dynamic>>>(
        future: GetHomeData.fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                height: 30,
                width: 30,
                child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            var users = snapshot.data;

            return ListView.builder(

              shrinkWrap: true,
              physics: PageScrollPhysics(),
              itemCount: users?.length,
              itemBuilder: (context, index) {
                print(users?.length.toString());
                var user = users?[index];
                return Expanded(
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Title"),
                        Flexible(child: Card(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(user?['title'],style: TextStyle(fontSize: 12,color: Colors.green),),
                        )),),
                      ],
                    ),


                );
              },
            );
          }
        },
      ),
    );
  }

  Future openFile({String? filename, required String url}) async {
    final name = filename ?? url.split('/').last;
    final file = await DownloadFile(filename!, name);
    if (file == null) return;
    OpenFile.open(file.path);
  }

  Future<File?> DownloadFile(String name, String url) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');

    try {
      final resposne = await Dio().get(url,
          options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              receiveTimeout: Duration(seconds: 0)));
      final ref = file.openSync(mode: FileMode.write);
      ref.writeFromSync(resposne.data);
      await ref.close();
      return file;
    } catch (e) {
      return null;
    }
  }
}
