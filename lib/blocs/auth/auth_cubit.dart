import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:readbook/model/user.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  final Dio dio = Dio();

  Future<void> register(String username, String email, String password) async {
    emit(AuthLoading());
    try {
      final response = await dio.post(
        "http://10.0.2.2:1111/auth/api/users/register",
        data: {'username': username, 'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          Auth auth = Auth.fromJson(response.data);
          emit(AuthLoaded(auth: auth));
        } else {
          // Log the response data for debugging
          print('Unexpected response format: ${response.data}');
          emit(AuthError("Unexpected response format"));
        }
      } else {
        emit(AuthError(
            "Registration failed with status code: ${response.statusCode}"));
      }
    } catch (e) {
      emit(AuthError("An error occurred: $e"));
      print('Error: $e');
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await dio.post("http://10.0.2.2:1111/auth/api/users/login",
          data: {'email': email, 'password': password});
      if(response.statusCode == 200){
        Auth auth = Auth.fromJson(response.data);
        emit(AuthLoaded(auth: auth));
      }else{
        emit(AuthError("Error == ${response.statusMessage}"));
      }
    } catch (e) {
      print('Login failed : $e');
    }
  }

  Future<void> addWithList(String userId, String bookId) async {
    try {
      final response = await dio.post(
          "http://10.0.2.2:1111/auth/api/addwithlist",
          data: {'userId': userId, 'bookId': bookId});
      if (response.statusCode == 200) {
        final Auth auth = Auth.fromJson(response.data);
        emit(AuthLoaded(auth: auth));
      } else {
        emit(AuthError("Đã có lỗi"));
      }
    } catch (e) {
      print('Lỗi thêm yêu thích : $e');
    }
  }
}
