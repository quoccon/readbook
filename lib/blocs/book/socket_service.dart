import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';


class SocketService with ChangeNotifier {
  late IO.Socket socket;
  List<String> newBookNotification = [];

  void initialize() {
    socket = IO.io(
      "http://192.168.0.102:1111",
      IO.OptionBuilder()
          .setTransports(['websocket']).setExtraHeaders({'foo': 'bar'}).build(),
    );

    // Xử lý khi kết nối thành công
    socket.on('connect', (_) {
      print('Connected to server');
    });

    // Xử lý sự kiện sách mới
    socket.on('newbook', (data) {
      var jsonData = jsonDecode(data);
      var titleAndAuthor = jsonEncode({
        'id':jsonData['_id'],
        'title': jsonData['title'],
        'author': jsonData['author'],
        'timestamp':DateTime.now().toString(),
      });

      newBookNotification.add(titleAndAuthor);
      _saveNotification();
      notifyListeners();

      _showOverLayNotification(jsonData['title'],jsonData['author']);
    });

    // Xử lý khi ngắt kết nối
    socket.on('disconnect', (_) {
      print('Disconnected from server');
    });

    // Xử lý lỗi kết nối
    socket.on('connect_error', (error) {
      print('Connection Error: $error');
    });

    // Kết nối tới máy chủ
    socket.connect();
  }

  Future<void> _saveNotification() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('newNotification', newBookNotification);
  }

  Future<void> loadNotification() async {
    final prefs = await SharedPreferences.getInstance();
    newBookNotification = prefs.getStringList('newNotification') ?? [];
    notifyListeners();
  }

  void _showOverLayNotification(String title,String author){
      showSimpleNotification(
          const Text('Thông báo sách mới'),
        subtitle: Text(author),
        background: Colors.blue,
        duration: const Duration(seconds: 2),
      );
  }


}
