import 'package:comment_tree/comment_tree.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../shared/components/images/user_avatar.dart';

class CommentTree extends CommentTreeWidget<CommentData, CommentData> {
  final Function(CommentData value) onPressedLike;
  final Function(CommentData value) onPressedReply;

  const CommentTree(
      super.root,
      super.replies, {
        required this.onPressedLike,
        required this.onPressedReply,
      }) : super();

  @override
  TreeThemeData get treeThemeData =>
      TreeThemeData(lineColor: Colors.grey.withAlpha(100), lineWidth: 2);

  @override
  AvatarWidgetBuilder<CommentData>? get avatarRoot =>
          (context, data) => PreferredSize(
        preferredSize: const Size.fromRadius(18.0),
        child: UserAvatar(
          avatar: data.avatar,
          userName: data.userName,
          radius: 18.0,
        ),
      );

  @override
  ContentBuilder<CommentData>? get contentRoot => _buildContent;

  @override
  AvatarWidgetBuilder<CommentData>? get avatarChild =>
          (context, data) => PreferredSize(
        preferredSize: const Size.fromRadius(14.0),
        child: UserAvatar(
          avatar: data.avatar,
          userName: data.userName,
          radius: 14.0,
        ),
      );

  @override
  ContentBuilder<CommentData>? get contentChild => _buildContent;

  Widget _buildContent(BuildContext context, CommentData data) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          child: Container(
            constraints: const BoxConstraints(minWidth: 120.0),
            padding:
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.userName ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(data.content ?? ''),
              ],
            ),
          ),
        ),
        Container(
          // color: Colors.red,
          padding: const EdgeInsets.only(left: 12.0, top: 4.0, bottom: 8.0),
          child: Row(
            children: [
              if (data.createdAt != null)
                Text(timeago.format(data.createdAt!),
                    style: textTheme.bodySmall
                        ?.copyWith(color: colorScheme.onSurfaceVariant)),
              const SizedBox(width: 8),
              _textButton(
                  context, () => onPressedLike(data), 'Like', data.like),
              _textButton(context, () => onPressedReply(data), 'Reply'),
            ],
          ),
        )
      ],
    );
  }

  Widget _textButton(BuildContext context, Function() onPressed, String name,
      [bool selected = false]) {
    return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
            foregroundColor:
            selected ? Theme.of(context).colorScheme.primary : Colors.grey,
            backgroundColor: Colors.transparent,
            // overlayColor: WidgetStateColor.transparent,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding:
            const EdgeInsets.symmetric(vertical: 2.0, horizontal: 12.0),
            minimumSize: Size.zero,
            elevation: 0,
            shape: const RoundedRectangleBorder()),
        child: Text(name));
  }
}

class CommentData extends Comment {
  final DateTime? createdAt;
  final List<CommentData> replies;
  late bool like;

  CommentData(
      {required super.avatar,
        required super.userName,
        required super.content,
        required this.createdAt,
        this.replies = const [],
        this.like = false});

  static List<CommentData> data = [
    CommentData(
      avatar: 'image_url_1',
      userName: 'Alice',
      content: 'This is amazing work!',
      like: false,
      createdAt: DateTime(2024, 12, 1, 8, 30),
      replies: [
        CommentData(
          avatar: 'image_url_2',
          userName: 'Bob',
          content: 'I completely agree!',
          like: false,
          createdAt: DateTime(2024, 12, 1, 9, 00),
        ),
        CommentData(
          avatar: 'image_url_3',
          userName: 'Charlie',
          content: 'Nice perspective.',
          like: false,
          createdAt: DateTime(2024, 12, 1, 9, 15),
        ),
      ],
    ),
    CommentData(
      avatar: 'image_url_4',
      userName: 'David',
      content: 'Can you provide more details?',
      like: false,
      createdAt: DateTime(2024, 11, 20, 14, 20),
      replies: [
        CommentData(
          avatar: 'image_url_5',
          userName: 'Emma',
          content: 'Check the documentation.',
          like: false,
          createdAt: DateTime(2024, 11, 20, 14, 45),
        )
      ],
    ),
    CommentData(
      avatar: 'image_url_6',
      userName: 'Fiona',
      content: 'This is very helpful!',
      like: false,
      createdAt: DateTime(2024, 10, 18, 10, 10),
      replies: [
        CommentData(
          avatar: 'image_url_7',
          userName: 'George',
          content: 'I found it helpful too!',
          like: false,
          createdAt: DateTime(2024, 10, 18, 10, 30),
        ),
      ],
    ),
    CommentData(
      avatar: 'image_url_8',
      userName: 'Ian',
      content: 'Could you explain this section?',
      like: false,
      createdAt: DateTime(2023, 12, 5, 17, 05),
    ),
    CommentData(
      avatar: 'image_url_9',
      userName: 'Julia',
      content: 'Brilliant execution!',
      like: false,
      createdAt: DateTime(2023, 11, 22, 21, 00),
      replies: [
        CommentData(
          avatar: 'image_url_10',
          userName: 'Kevin',
          content: 'Absolutely, it’s brilliant.',
          like: false,
          createdAt: DateTime(2023, 11, 22, 21, 30),
        ),
      ],
    ),
    CommentData(
      avatar: 'image_url_11',
      userName: 'Liam',
      content: 'What a great post!',
      like: false,
      createdAt: DateTime(2023, 10, 1, 13, 00),
      replies: [],
    ),
    CommentData(
      avatar: 'image_url_12',
      userName: 'Mia',
      content: 'I’ve learned so much from this.',
      like: false,
      createdAt: DateTime(2022, 9, 15, 12, 45),
      replies: [
        CommentData(
          avatar: 'image_url_13',
          userName: 'Noah',
          content: 'Me too, it’s fantastic.',
          like: false,
          createdAt: DateTime(2022, 9, 15, 13, 05),
        ),
      ],
    ),
    CommentData(
      avatar: 'image_url_14',
      userName: 'Olivia',
      content: 'This could use some improvement.',
      like: false,
      createdAt: DateTime(2022, 7, 10, 16, 15),
      replies: [
        CommentData(
          avatar: 'image_url_15',
          userName: 'Patrick',
          content: 'Any specific suggestions?',
          like: false,
          createdAt: DateTime(2022, 7, 10, 16, 45),
        ),
      ],
    ),
    CommentData(
      avatar: 'image_url_16',
      userName: 'Quinn',
      content: 'Outstanding result!',
      like: false,
      createdAt: DateTime(2021, 8, 8, 14, 10),
    ),
    CommentData(
      avatar: 'image_url_17',
      userName: 'Ryan',
      content: 'I’m impressed by your effort.',
      like: false,
      createdAt: DateTime(2021, 6, 3, 19, 00),
    ),
    CommentData(
      avatar: 'image_url_18',
      userName: 'Sophia',
      content: 'This sparked a great discussion!',
      like: false,
      createdAt: DateTime(2020, 5, 22, 9, 50),
      replies: [
        CommentData(
          avatar: 'image_url_19',
          userName: 'Thomas',
          content: 'Yes, it’s worth talking about.',
          like: false,
          createdAt: DateTime(2020, 5, 22, 10, 10),
        ),
        CommentData(
          avatar: 'image_url_20',
          userName: 'Uma',
          content: 'I’d love to dive deeper into this.',
          like: false,
          createdAt: DateTime(2020, 5, 22, 10, 25),
        ),
      ],
    ),
    CommentData(
      avatar: 'image_url_21',
      userName: 'Victor',
      content: 'Well done!',
      like: false,
      createdAt: DateTime(2020, 3, 18, 22, 05),
    ),
    CommentData(
      avatar: 'image_url_22',
      userName: 'Willow',
      content: 'I couldn’t agree more.',
      like: false,
      createdAt: DateTime(2019, 2, 14, 15, 35),
      replies: [
        CommentData(
          avatar: 'image_url_23',
          userName: 'Xavier',
          content: 'Same here!',
          like: false,
          createdAt: DateTime(2019, 2, 14, 15, 55),
        ),
      ],
    ),
    CommentData(
      avatar: 'image_url_24',
      userName: 'Yara',
      content: 'Thanks for sharing!',
      like: false,
      createdAt: DateTime(2018, 1, 20, 7, 00),
      replies: [
        CommentData(
          avatar: 'image_url_25',
          userName: 'Zack',
          content: 'No problem!',
          like: false,
          createdAt: DateTime(2018, 1, 20, 7, 15),
        ),
      ],
    ),
    CommentData(
      avatar: 'image_url_26',
      userName: 'Amy',
      content: 'Fantastic work!',
      like: false,
      createdAt: DateTime(2018, 12, 5, 8, 40),
      replies: [],
    ),
    CommentData(
      avatar: 'image_url_27',
      userName: 'Brian',
      content: 'Can you elaborate more?',
      like: false,
      createdAt: DateTime(2017, 11, 12, 10, 20),
    ),
    CommentData(
      avatar: 'image_url_28',
      userName: 'Catherine',
      content: 'Great insights.',
      like: false,
      createdAt: DateTime(2017, 10, 7, 12, 35),
      replies: [
        CommentData(
          avatar: 'image_url_29',
          userName: 'Derek',
          content: 'Totally agree!',
          like: false,
          createdAt: DateTime(2017, 10, 7, 12, 50),
        ),
      ],
    ),
    CommentData(
      avatar: 'image_url_30',
      userName: 'Ethan',
      content: 'Nice presentation!',
      like: false,
      createdAt: DateTime(2017, 9, 25, 18, 00),
    ),
  ];
}