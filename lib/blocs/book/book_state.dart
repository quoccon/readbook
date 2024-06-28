part of 'book_cubit.dart';

@immutable
sealed class BookState extends Equatable{}

final class BookInitial extends BookState {
  @override
  List<Object?> get props => [];
}

final class BookLoading extends BookState{
  @override
  List<Object?> get props => [];
}

final class BookLoaded extends BookState {
  final List<Book> dataBook;
  BookLoaded(this.dataBook);
  @override
  List<Object?> get props => [dataBook];
}

final class BookError extends BookState {
  final String error;
  BookError(this.error);
  @override
  List<Object?> get props => [error];
}