part of 'withlist_cubit.dart';

@immutable
sealed class WithlistState extends Equatable{}

final class WithlistInitial extends WithlistState{
  @override
  List<Object?> get props => [];
}
final class WithListLoading extends WithlistState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

final class WithListLoaded extends WithlistState{
  final WithList withList;
  WithListLoaded(this.withList);
  @override
  List<Object?> get props => [withList];
}

final class WithListError extends WithlistState{
  final String error;
  WithListError(this.error);
  @override
  List<Object?> get props => [error];
}
