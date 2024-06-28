import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:readbook/model/withlist.dart';

part 'withlist_state.dart';

class WithlistCubit extends Cubit<WithlistState> {
  WithlistCubit() : super(WithlistInitial());

  Dio dio = Dio();

  Future<void> getWithList(String userId)async{
    try{
      final response = await dio.get("http://10.0.2.2:1111/auth/api/addwithlist",data: {'userId':userId});
      if(response.statusCode == 200) {
        final List<WithList> data = (response.data as List).map((json) => WithList.fromJson(json)).toList();
        emit(WithListLoaded(data as WithList));
      }
    }catch(e){
      print('Lỗi lấy danh sách : $e');
    }
  }
}
