import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// import 'detail_user_page.dart';

class AllUsersPage extends StatelessWidget {
  const AllUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //   builder: (context) => const DetailUserPage(),
              // ));
              context.pushNamed("detail_user", extra: index + 1);
            },
            title: Text("User ${index + 1}"),
          );
        },
      ),
    );
  }
}
