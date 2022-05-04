import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class View extends StatefulWidget {
  const View({Key? key}) : super(key: key);

  @override
  State<View> createState() => _ViewState();
}

class _ViewState extends State<View> {
  List<List<dynamic>> rawdata = [];
  List<Category> data = [];

  @override
  void initState() {
    super.initState();
    loader().then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        List<Widget> result = [];

        for (Category cat in data) {
          // List<Widget> items = [];

          result.add(
            Container(
              margin: EdgeInsets.only(
                top: Settings.itemFontsize * 3,
                bottom: Settings.itemFontsize,
              ),
              child: Text(
                cat.title,
                style: TextStyle(
                  fontFamily: Settings.fontFamily,
                  fontSize: Settings.titleFontsize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );

          for (Item it in cat.items) {
            result.add(
              Container(
                margin: EdgeInsets.only(bottom: Settings.lineSpacing),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        it.title,
                        style: TextStyle(
                          fontFamily: Settings.fontFamily,
                          fontSize: Settings.itemFontsize,
                        ),
                      ),
                    ),

                    MediaQuery.of(context).size.width >= Settings.mobileMaxWidth
                        ? SizedBox(width: Settings.leftRightPCMargin)
                        : SizedBox(width: Settings.leftRightMobileMargin),

                    ///
                    ///
                    Text(
                      "₩ " + f.format(it.price),
                      style: TextStyle(
                        fontFamily: Settings.fontFamily,
                        fontSize: Settings.itemFontsize,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }

        return ListView(
            children: result,
            padding:
                MediaQuery.of(context).size.width >= Settings.mobileMaxWidth
                    ? EdgeInsets.fromLTRB(Settings.leftRightPCMargin, marginTop,
                        Settings.leftRightPCMargin, marginBottom)
                    : EdgeInsets.fromLTRB(
                        Settings.leftRightMobileMargin,
                        marginTop,
                        Settings.leftRightMobileMargin,
                        marginBottom));
      }),
    );
  }

  //////////////////////////////////
  // Functions /////////////////////

  var f = NumberFormat("#,##0", "ko_KR");
  double marginBottom = 100;
  double marginTop = 50;

  // https://medium.com/geekculture/loading-new-fonts-in-flutter-app-after-deployment-ttf-otf-ffe9c13ffcd1
  Future<ByteData> fetchFont({required String fontname}) async {
    final http.Response response =
        await http.get(Uri.parse("./public/data/font.ttf"));
    return ByteData.view(response.bodyBytes.buffer);
  }

  Future<List<List<dynamic>>> dataLoader({required String dataname}) async {
    http.Response res = await http.get(Uri.parse("./public/data/data.csv"));
    List<List<dynamic>> csvResult =
        resultToCsv(convert.utf8.decode(res.bodyBytes));
    csvResult.removeAt(0);
    return csvResult;
  }

  Future<Map<String, dynamic>> settingLoader() async {
    http.Response res = await http.get(Uri.parse("./public/data/setting.json"));
    return convert.jsonDecode(convert.utf8.decode(res.bodyBytes));
  }

  Future<void> loader() async {
    // Load setting
    Map<String, dynamic> settings = await settingLoader();

    Settings.datafileName = settings["datafileName"];
    Settings.fontfileName = settings["fontfileName"];

    Settings.productNameIndex = settings["productNameIndex"] - 1;
    Settings.categoryIndex = settings["categoryIndex"] - 1;
    Settings.qtIndex = settings["qtIndex"] - 1;
    Settings.displayPriceIndex = settings["displayPriceIndex"] - 1;
    Settings.inorder = settings["inorder"];

    Settings.titleFontsize = settings["titleFontsize"];
    Settings.itemFontsize = settings["itemFontsize"];
    Settings.leftRightMobileMargin = settings["leftRightMobileMargin"];
    Settings.leftRightPCMargin = settings["leftRightPCMargin"];
    Settings.lineSpacing = settings["lineSpacing"];
    Settings.mobileMaxWidth = settings["mobileMaxWidth"];

    // Load data file
    rawdata = await dataLoader(dataname: Settings.datafileName);

    // Load font
    var fontLoader = FontLoader(Settings.fontFamily);
    fontLoader.addFont(fetchFont(fontname: Settings.fontfileName));
    await fontLoader.load();

    dataBuilder();
  }

  List<int> file = [];

  List<List<dynamic>> resultToCsv(String result) {
    List<List<dynamic>> rowsAsListOfValues =
        const CsvToListConverter().convert(result);

    return rowsAsListOfValues;
  }

  void dataBuilder() {
    // 데이터 구조 생성

    Set categories = {};

    for (List<dynamic> target in rawdata) {
      categories.add(target[Settings.categoryIndex]);
    }

    for (String catName in categories) {
      Category newcat = Category(title: catName, items: []);
      for (List<dynamic> target in rawdata) {
        if (catName == target[Settings.categoryIndex]) {
          int price = target[Settings.displayPriceIndex] is String
              ? 0
              : target[Settings.displayPriceIndex];
          String productName = target[Settings.productNameIndex];
          int qt = target[Settings.qtIndex];

          if (price == 0 || qt == 0) {
            continue;
          }
          // print(price);
          // print(productName);
          // print(qt);
          // print("==============");

          newcat.items.add(Item(title: productName, price: price));
        }
      }

      if (newcat.items.length != 0) {
        data.add(newcat);
      }
    }

    if (Settings.inorder) {
      data.sort(
          ((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase())));
    } else {
      data.sort(
          ((b, a) => a.title.toLowerCase().compareTo(b.title.toLowerCase())));
    }
  }
}

//////////////////////////////////////
// Extra Classes /////////////////////
class Settings {
  static String datafileName = "";
  static String fontfileName = "";

  static int productNameIndex = -1;
  static int categoryIndex = -1;
  static int qtIndex = -1;
  static int displayPriceIndex = -1;

  static bool inorder = true;
  static const String fontFamily = "cff";

  static double titleFontsize = 16;
  static double itemFontsize = 16;
  static double leftRightMobileMargin = 70;
  static double leftRightPCMargin = 35;
  static double lineSpacing = 10;
  static double mobileMaxWidth = 800;
}

class Category {
  final String title;
  final List<Item> items;

  Category({
    required this.title,
    required this.items,
  });

  @override
  String toString() {
    return "{title: $title, items: $items}";
  }
}

class Item {
  final String title;
  final int price;

  Item({
    required this.title,
    required this.price,
  });

  @override
  String toString() {
    return "{title: $title, price: $price}";
  }
}
