import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  List<dynamic> data = [];
  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      );
      if (response.statusCode == 200) {
        setState(() {
          data = json.decode(response.body);
          isLoading = false;
        });
        print(data);
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching posts: $error");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching data: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen'), centerTitle: true),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : data.isNotEmpty
              ? ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final item = data[index];
                  return Card(
                    elevation: 2,
                    child: ListTile(
                      title: Text(item['title']),
                      subtitle: Text(item['body']),
                      leading: Text(item['id'].toString()),
                    ),
                  );
                },
              )
              : SizedBox(),
    );
  }
}
