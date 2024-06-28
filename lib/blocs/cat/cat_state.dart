part of 'cat_cubit.dart';

@immutable
sealed class CatState extends Equatable{}

final class CatInitial extends CatState {
  @override
  List<Object?> get props => [];
}

final class CatLoaded extends CatState{
  final List<Category> cat;
  CatLoaded(this.cat);
  @override
  List<Object?> get props => [cat];
}

final class CatError extends CatState {
  final String error;
  CatError(this.error);
  @override
  List<Object?> get props => [error];
}
