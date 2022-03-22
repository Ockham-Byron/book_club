import 'dart:math';

import 'package:badges/badges.dart';
import 'package:book_club/models/book_model.dart';
import 'package:book_club/models/group_model.dart';
import 'package:book_club/models/user_model.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';

String displayBookCoverUrl(BookModel book) {
  String currentBookCoverUrl;

  if (book.cover == "") {
    currentBookCoverUrl =
        "https://cdn.pixabay.com/photo/2020/12/14/15/52/book-5831278_1280.jpg";
  } else {
    currentBookCoverUrl = book.cover!;
  }

  return currentBookCoverUrl;
}

String getUserPseudo(UserModel user) {
  String userPseudo;
  if (user.pseudo == null) {
    userPseudo = "personne";
  } else {
    userPseudo = user.pseudo!;
  }
  return "${userPseudo[0].toUpperCase()}${userPseudo.substring(1)}";
}

// Used to generate random integers for the random colors
// final random = Random();

// final Color? foregroundColor = Colors
//     .primaries[random.nextInt(Colors.primaries.length)][random.nextInt(9) * 100]
//     ?.withOpacity(0.6);

bool withProfilePicture(UserModel user) {
  if (user.pictureUrl == "") {
    return false;
  } else {
    return true;
  }
}

Widget displayCircularAvatar(UserModel user, Color color) {
  if (withProfilePicture(user)) {
    return CircularProfileAvatar(
      user.pictureUrl!,
      showInitialTextAbovePicture: false,
      radius: 50,
    );
  } else {
    return CircularProfileAvatar(
      "https://digitalpainting.school/static/img/default_avatar.png",
      foregroundColor: color,
      initialsText: Text(
        getUserPseudo(user)[0].toUpperCase(),
        style: const TextStyle(
            fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
      ),
      showInitialTextAbovePicture: true,
    );
  }
}

Widget displayProfileWithBadge(UserModel user, GroupModel group, Color color) {
  if (user.uid == group.leader) {
    return Badge(
      badgeContent: const Icon(
        Icons.verified_user,
        color: Colors.white,
      ),
      badgeColor: Colors.white.withOpacity(0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: displayCircularAvatar(user, color),
      ),
    );
  } else {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: displayCircularAvatar(user, color),
    );
  }
}

String getGroupId(GroupModel group) {
  String groupId;
  if (group.id != null) {
    groupId = group.id!;
  } else {
    groupId = "Id inconnu, ce qui est très étrange";
  }
  return groupId;
}
