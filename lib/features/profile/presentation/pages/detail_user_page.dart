import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_clean_architecture/features/injection.dart';

import '../../domain/entities/profile.dart';
import '../bloc/profile_bloc.dart';

class DetailUserPage extends StatelessWidget {
  final int userId;

  const DetailUserPage(this.userId, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Users $userId'),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        // bloc: context.read<ProfileBloc>()
        //   ..add(ProfileEventGetDetailUser(userId)),
        bloc: myInjection<ProfileBloc>()
          ..add(ProfileEventGetDetailUser(userId)),
        builder: (context, state) {
          if (state is ProfileStateLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileStateError) {
            return Center(
              child: Text(state.message),
            );
          } else if (state is ProfileStateLoadedUser) {
            Profile profile = state.detailUser;

            return Card(
              margin: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(profile.profileImageUrl),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text('ID : ${profile.id}'),
                    Text('Fullname : ${profile.fullName}'),
                    Text('Email: ${profile.email}'),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: Text("Empty"),
            );
          }
        },
      ),
    );
  }
}
