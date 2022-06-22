import 'dart:convert';

import 'package:assignment/views/login_page.dart';
import 'package:assignment/views/maps_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/demoData.dart';

class GridViewApi extends StatefulWidget {
  const GridViewApi({Key? key}) : super(key: key);

  @override
  State<GridViewApi> createState() => _GridViewApiState();
}

class _GridViewApiState extends State<GridViewApi> {
  List<DemoData> dataList = [];

  Future<List<DemoData>?> getData() async {
    var response = await http.get(Uri.parse("https://picsum.photos/v2/list"));
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      for (Map i in data) {
        dataList.add(DemoData.fromJson(i));
      }
      return dataList;
    } else {
      return dataList;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Mediaquery variable to get device screen size
    Size screenSize = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          onPressed: (){
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => LoginPage()));          },
          icon: Icon(Icons.arrow_back,color: Colors.white,),),
        title: Text(
          "GridViewData",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: getData(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: GridView.builder(
                            itemCount: dataList.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                  color: Colors.white,
                                  margin: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Expanded(
                                          flex: 4,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(5),
                                                    topLeft:
                                                        Radius.circular(5)),
                                                child: Image.network(
                                                  "${dataList[index].downloadUrl}",
                                                  fit: BoxFit.fill,
                                                )),
                                          )),
                                      Expanded(
                                          flex: 1,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Flexible(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(1.0),
                                                  child: Text(
                                                    "${dataList[index].author}",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                    ],
                                  ));
                            },
                          ),
                        ),
                      ],
                    );
                  }
                }),
          )
        ],
      ),
    ));
  }
}
