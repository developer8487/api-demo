import 'dart:convert';

import 'package:api_demo/datalist-screen.dart';
import 'package:api_demo/model/usermodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditPostScreen extends StatefulWidget {
  final DataModel post;
  const EditPostScreen({super.key, required this.post});

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print('${url}/${widget.post.id}');
    titleController = TextEditingController(text: widget.post.title);
    bodyController = TextEditingController(text: widget.post.body);
  }

  Future<void> updateData() async {
    final response = await http.put(
      Uri.parse('${url}/${widget.post.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': titleController.text,
        'body': bodyController.text, // The data you want to update
      }),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Post Updated!')));
      setState(() {});
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Update failed')));
    }
  }

  Future<void> deletePost() async {
    final response = await http.delete(Uri.parse('${url}/${widget.post.id}'));

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Post Deleted!')));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DataListScreen()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Delete failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: bodyController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Body'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: updateData,

                  child: const Text('Update'),
                ),
                ElevatedButton(
                  onPressed: deletePost,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
