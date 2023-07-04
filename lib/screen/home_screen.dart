import 'package:exchange_notice/component/padding.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> items = ['Select Exchange', 'ecc', 'exx'];
  List<String> itemsCategory = ['Category', 'ecc', 'exx'];
  TextEditingController startDateController = TextEditingController();
  String dropdownvalue = 'Select Exchange';
  String dropdownvalueCatagorius = 'Category';
  String? startDateData;
  late DateTime startDate;
  String? pdfPath;

  @override
  void initState() {
    super.initState();
    savePDF();
  }

  final TextEditingController _dateController = TextEditingController();

  Future<void> savePDF() async {
    String url =
        'https://www.borsaitaliana.it/derivati/archiviopdf/marketmaker/mmobligaitonjune23.pdf';

    var response = await http.get(Uri.parse(url));
    var bytes = response.bodyBytes;

    final appDir = await getApplicationDocumentsDirectory();
    final pdfPath = '${appDir.path}/mmobligaitonjune23.pdf';
    File pdfFile = File(pdfPath);
    await pdfFile.writeAsBytes(bytes);

    setState(() {
      this.pdfPath = pdfPath;
    });
  }

  // Future<void> downloadPDF() async {
  //   String url = 'https://www.borsaitaliana.it/derivati/archiviopdf/marketmaker/mmobligaitonjune23.pdf';
  //
  //   var response = await http.get(Uri.parse(url));
  //   var bytes = response.bodyBytes;
  //
  //   final appDir = await getApplicationDocumentsDirectory();
  //   final pdfPath = '${appDir.path}/sample.pdf';
  //   File pdfFile = File(pdfPath);
  //   await pdfFile.writeAsBytes(bytes);
  //
  //   setState(() {
  //     this.pdfPath = pdfPath;
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text("Exchange Notices"),
      ),
      body: Padding(
        padding: Toppadding,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                          underline: Container(),
                          isExpanded: true,
                          value: dropdownvalue,
                          onChanged: (String? val) {
                            setState(() {
                              dropdownvalue = val.toString();
                            });
                          },
                          items: items
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList()),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: Toppadding.add(EdgeInsets.only(
                  top: 10,
                )),
                child: Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: TextFormField(
                        maxLines: null, // Allow multiple lines of text
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10),
                          labelText: 'Search',
                          border: OutlineInputBorder(),
                        ),
                        // Set overflow behavior
                      ),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Flexible(
                      flex: 2,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<String>(
                                underline: Container(),
                                isExpanded: true,
                                style:
                                    TextStyle(color: Colors.cyan, fontSize: 16),
                                value: dropdownvalueCatagorius,
                                onChanged: (String? val) {
                                  setState(() {
                                    dropdownvalueCatagorius = val.toString();
                                  });
                                },
                                items: itemsCategory
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList()),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 0, right: 0),
                        child: TextFormField(
                          onChanged: (value) {},
                          style: TextStyle(fontSize: 12),
                          readOnly: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter start date';
                            } else {
                              return null;
                            }
                          },
                          controller: _dateController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),

                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide()),

                            suffixIconConstraints: BoxConstraints(),

                            hintText: 'Year',
                            isDense: true,
                            // important line
                            contentPadding: EdgeInsets.fromLTRB(5, 12, 0, 12),
                            // control your hints text size
                            hintStyle: TextStyle(
                                letterSpacing: 2,
                                fontSize: 14,
                                fontWeight: FontWeight.w300),
                          ),
                          onTap: () async {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1960),
                              lastDate: DateTime(2101),
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: ThemeData.light(),
                                  // Customize the date picker theme if needed
                                  child: child!,
                                );
                              },
                            ).then((pickedDate) {
                              if (pickedDate != null) {
                                final formattedDate =
                                    DateFormat('MM-yyyy').format(pickedDate);
                                _dateController.text = formattedDate;
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: pdfPath != null
                    ? Flexible(
                        child: PDFView(
                          filePath: pdfPath!,
                        ),
                      )
                    : CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
