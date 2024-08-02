
class LikeDislike {
  final int likes;
  final int dislikes;
  final int userAction;

  LikeDislike({
    required this.likes,
    required this.dislikes,
    required this.userAction,
  });

  LikeDislike copyWith({
    int? likes,
    int? dislikes,
    int? userAction,
  }) =>
      LikeDislike(
        likes: likes ?? this.likes,
        dislikes: dislikes ?? this.dislikes,
        userAction: userAction ?? this.userAction,
      );

  factory LikeDislike.fromJson(Map<String, dynamic> json) => LikeDislike(
    likes: json["likes"],
    dislikes: json["dislikes"],
    userAction: json["userAction"],
  );

  Map<String, dynamic> toJson() => {
    "likes": likes,
    "dislikes": dislikes,
    "userAction": userAction,
  };
}


// final likeDislike = LikeDisLike(
//     likes: e['likeDislike']['likes'],
//     dislikes: e['likeDislike']['dislikes'],
//     userAction: e['likeDislike']['userAction']);