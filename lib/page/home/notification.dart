import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readbook/blocs/book/socket_service.dart';
import 'package:timeago/timeago.dart' as timeago;


class NotificationForm extends StatelessWidget {
  const NotificationForm({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SocketService(),
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.blue),
        ),
        home: NotificationPage(),
      ),
    );
  }
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late SocketService socketService;
  List<String> notification = [];
  Timer? timer;
  int selectdIndex = -1;

  @override
  void initState() {
    super.initState();
    socketService = Provider.of<SocketService>(context, listen: false);
    socketService.initialize();
    socketService.loadNotification();

  }

  @override
  void dispose() {
    socketService.dispose();
    super.dispose();
  }
  void _showDeleteOption(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 100,
          color: Colors.white,
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Xóa'),
                onTap: () {
                  setState(() {
                    socketService.newBookNotification.removeAt(index);
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _onLongPressStart(BuildContext context,index){
    timer = Timer(const Duration(milliseconds: 500), (){
      _showDeleteOption(context, index);
    });
  }

  void _onLongPressEnd(LongPressEndDetails detail){
    timer?.cancel();
  }

  Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 1),(){
      setState(() {
        socketService.loadNotification();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Thông báo'),
        centerTitle: true,
      ),
      body: Center(
        child: Consumer<SocketService>(
          builder: (context, socketService, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hôm nay",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                SizedBox(height: 20),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refreshData,
                    child: ListView.builder(
                      itemCount: socketService.newBookNotification.length,
                      itemBuilder: (context, index) {
                        try {
                          var notification = jsonDecode(socketService.newBookNotification[index]);
                          var timestamp = DateTime.parse(notification['timestamp']);
                          var timeAgo = timeago.format(timestamp);
                          return GestureDetector(
                            onTap: (){
                              setState(() {
                                selectdIndex = index;
                              });
                            },
                            onLongPressStart: (_) => _onLongPressStart(context,index),
                            onLongPressEnd: _onLongPressEnd,
                            child: Container(
                              height: 80,
                              color: selectdIndex == index ? Colors.white : Colors.grey[200] ,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                   Text('${notification['author']} đã đăng một sách mới ${notification['title']}',textAlign: TextAlign.center,),
                                    const SizedBox(height: 5,),
                                    Text(timeAgo)
                    
                                  ],
                                ),
                              ),
                            ),
                          );
                        } catch (e) {
                          print("Error parsing notification: $e");
                          return Container(); // Trả về widget trống nếu có lỗi parse JSON
                        }
                      },
                    ),
                  )

                )
              ],
            );
          },
        ),
      ),
    );
  }
}
