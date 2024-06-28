import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../model/book.dart';

part 'book_state.dart';

class BookCubit extends Cubit<BookState> {
  BookCubit() : super(BookInitial());

  Dio dio = Dio();

  Future<void> getListBook() async {
    try {
      final reponse = await dio.get("http://10.0.2.2:1111/book/api/getall");
      if (reponse.statusCode == 200) {
        final List<Book> data =
            (reponse.data as List).map((json) => Book.fromJson(json)).toList();
        emit(BookLoaded(data));
      } else {
        emit(BookError('Lấy danh sách lỗi'));
      }
    } catch (e) {
      print('Đã có lỗi khi lấy danh sách của sách : $e');
    }
  }

  Future<void> searchBook(String query) async {
    try {
      final response = await dio.post("http://10.0.2.2:1111/book/api/seachbook",
          data: {'query': query});
      if(response.statusCode == 200) {
        final List<Book> data = (response.data as List).map((json) => Book.fromJson(json)).toList();
        emit(BookLoaded(data));
      }else{
        emit(BookError("Lỗi"));
      }
    } catch (e) {
      print('Lỗi tìm kiếm : $e');
    }
  }

  void clearSearch(){
    emit(BookInitial());
  }
}
