import 'dart:convert';

import 'package:api_demo/model/usermodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'editpost-screen.dart';

final  String url = "https://jsonplaceholder.typicode.com/posts";

class DataListScreen extends StatefulWidget {
  const DataListScreen({super.key});

  @override
  State<DataListScreen> createState() => _DataListScreenState();
}

class _DataListScreenState extends State<DataListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fatchData();
  }

  bool isload = true;

  List<DataModel> dataList = [];

  Future<void> fatchData() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);

      setState(() {
        dataList = jsonData.map((item) => DataModel.fromJson(item)).toList();
        isload = false;
      });
      print("recall");
    } else {
      print("Error fetching data: ${response.statusCode}");
    }

    return null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Total Data ${dataList.length}")),
      body: isload
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                final post = dataList[index];
                return ListTile(
                  title: Text(
                    post.title.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    post.body.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  leading: Text(post.id.toString(),style: TextStyle(fontSize: 20),),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditPostScreen(post: post),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
