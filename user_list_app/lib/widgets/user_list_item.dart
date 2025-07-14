// Packages
import 'package:flutter/material.dart';

// Models
import '../models/user_model.dart';

// Screens
import '../screens/user_detail_screen.dart';

class UserListItem extends StatelessWidget {
  final User user;

  const UserListItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(user.avatar)),
      title: Text('${user.firstName} ${user.lastName}'),
      subtitle: Text(user.email),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetailScreen(user: user),
            // builder: (context) => Scaffold(
            //   appBar: AppBar(title: Text('${user.firstName} ${user.lastName}')),
            //   body: Center(child: Text('User details for ${user.firstName}')),
            // ),
          ),
        );
      },
    );
  }
}
