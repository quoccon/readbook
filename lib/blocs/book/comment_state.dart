part of 'comment_cubit.dart';

@immutable
sealed class CommentState extends Equatable{}

final class CommentInitial extends CommentState {
  @override
  List<Object?> get props => [];
}

final class CommentSuccess extends CommentState{
  final Comment comment;
  CommentSuccess(this.comment);
  @override
  List<Object?> get props => [comment];
}

final class CommentLoaded extends CommentState{
  final List<Comment> comment;
  CommentLoaded(this.comment);
  @override
  List<Object?> get props => [comment];
}

final class CommentError extends CommentState{
  final String error;
  CommentError(this.error);
  @override
  List<Object?> get props => [error];
}