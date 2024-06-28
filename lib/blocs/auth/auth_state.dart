part of 'auth_cubit.dart';

@immutable
sealed class AuthState extends Equatable{}

final class AuthInitial extends AuthState {
  @override
  List<Object?> get props => [];
}

final class AuthLoading extends AuthState{
  @override
  List<Object?> get props => [];
}

final class AuthLoaded extends AuthState{
  final Auth auth;
  AuthLoaded({required this.auth});

  @override
  List<Object?> get props => [auth];
}

final class AuthError extends AuthState{
  final String error;
  AuthError(this.error);
  @override
  List<Object?> get props => [error];
}