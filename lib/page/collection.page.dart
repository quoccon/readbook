import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readbook/page/home/detail_book.dart';

class CollectiobPage extends StatefulWidget {
  const CollectiobPage({super.key});

  @override
  State<CollectiobPage> createState() => _CollectiobPageState();
}

class _CollectiobPageState extends State<CollectiobPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.notifications_active,size: 35,),
            )
          ],
        ),
      body:  Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("My Collection",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
              const SizedBox(height: 20,),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GestureDetector(
                        onTap: (){
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => const DetailBook()));
                        },
                        child: Container(
                          height: 100,
                          width: double.infinity,
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset("assets/images/photo.png",width: 50,height: 70,fit: BoxFit.cover,),
                                  const SizedBox(width: 16,),
                                   const Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("The Midnight Libary",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18,color: Color(0xff0d0842)),),
                                        Text("Matt Haig",style: TextStyle(fontSize: 15,color: Color(0xff3d3968),fontWeight: FontWeight.w500),),
                                        SizedBox(height: 8,),
                                        Text("The story follows a woman named Nora Seed.",style: TextStyle(fontSize: 15,color: Color(0xff817e9c)),)
                                      ],
                                    ),
                                  ),
                                  Image.asset("assets/images/withlist.png",fit: BoxFit.cover,width: 20,height: 25,)
                                ],
                              ),
                              const Divider(color: Color(0xffededed))
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}