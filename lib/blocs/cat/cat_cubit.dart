import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../model/cat.dart';

part 'cat_state.dart';

class CatCubit extends Cubit<CatState> {
  CatCubit() : super(CatInitial());
  Dio dio = Dio();

  Future<void> getCat() async {
    try{
      final response = await dio.get("http://10.0.2.2:1111/book/api/getcat");
      if(response.statusCode == 200){
        final List<Category> data = (response.data as List).map((json) => Category.fromJson(json)).toList();
        emit(CatLoaded(data));
      }else{
        emit(CatError("Không lấy được danh sách"));
      }
    }catch(e){
      print('Có lỗi : $e');
    }
  }
}
