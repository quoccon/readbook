import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../model/comment.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  CommentCubit() : super(CommentInitial());

  Dio dio = Dio();

  Future<void> addComment(String userId, String bookId, String comment) async {
    try {
      final response = await dio.post(
          "http://10.0.2.2:1111/book/api/addcoment",
          data: {'userId': userId, 'bookId': bookId, 'comment': comment});
      if(response.statusCode == 200){
        final dynamic resData = response.data;
        if(resData is Map<String,dynamic>){
          final Comment comment = Comment.fromJson(resData);
          emit(CommentSuccess(comment));
        }else{
          emit(CommentError("Failed to add comment: Invalid response data"));
        }
      }else{
       emit(CommentError("Comment lỗi"));
      }
    } catch (e) {
      print('Comment thất bại : $e');
    }
  }

  Future<void> getComment(String bookId)async{
    try{
      final response = await dio.get("http://10.0.2.2:1111/book/api/getcoment",data: {'bookId':bookId});
      if(response.statusCode == 200){
        final List<Comment> data = (response.data as List).map((json) => Comment.fromJson(json)).toList();
        emit(CommentLoaded(data));
      }else{
        emit(CommentError("lỗi get"));
      }
    }catch(e){
      print('Lỗi : $e');
    }
  }
}
