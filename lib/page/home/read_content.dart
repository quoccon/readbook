import 'package:flutter/material.dart';

class ReadContent extends StatelessWidget {
  final String? content;
  final String? title;
  const ReadContent({super.key, this.content, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(title??""),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
            child: Text(content??"",style: TextStyle(fontSize: 18,color: Color(0xff817e9c),),)),
      ),
    );
  }
}
