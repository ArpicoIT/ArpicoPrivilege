import 'package:flutter/material.dart';

import '../../shared/components/comment_tree.dart';
import '../../data/models/product.dart';

class ReviewDetailsViewModel extends ChangeNotifier{

  final FocusNode commentInputFocus = FocusNode();
  final TextEditingController commentInputCtrl = TextEditingController();

  Review review = Review();

  List<CommentData> comments = CommentData.data;

  int get totalCommentsCount => _countComments(comments);

  int _countComments(List<CommentData> comments) {
    int count = 0;
    for (var comment in comments) {
      count++; // Count the main comment
      if (comment.replies.isNotEmpty) {
        count += _countComments(comment.replies); // Recursively count replies
      }
    }
    return count;
  }

  void saveComment(String data) {
    final comment = CommentData(
        avatar: null,
        userName: 'Gayan Chanaka',
        content: data,
        createdAt: DateTime.now()
    );

    comments.add(comment);
    comments.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

    notifyListeners();

    // if (context.mounted) {
    //   _commentController.clear();
    //   FocusScope.of(context).unfocus();
    //   setState(() {});
    // }
  }

  void likeComment(CommentData value) {
    value.like = !value.like;
    notifyListeners();
  }

  void startReplying(CommentData value) {
    // _commentController.text = "@${value.userName ?? ''} ";
    // _commentFieldFocus.requestFocus();
  }
}