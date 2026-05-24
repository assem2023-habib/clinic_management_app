import 'package:equatable/equatable.dart';

enum RatingFilter { newest, highest, lowest, withPhotos }

abstract class RatingEvent extends Equatable {
  const RatingEvent();
  @override
  List<Object?> get props => [];
}

class RatingLoad extends RatingEvent {
  final String? doctorId;
  const RatingLoad({this.doctorId});
  @override
  List<Object?> get props => [doctorId];
}

class RatingFilterChanged extends RatingEvent {
  final RatingFilter filter;
  const RatingFilterChanged(this.filter);
  @override
  List<Object?> get props => [filter];
}

class RatingLoadMore extends RatingEvent {
  const RatingLoadMore();
}

class RatingToggleLike extends RatingEvent {
  final String reviewId;
  const RatingToggleLike(this.reviewId);
  @override
  List<Object?> get props => [reviewId];
}
