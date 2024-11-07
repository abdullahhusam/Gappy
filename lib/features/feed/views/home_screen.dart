import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gappy/features/auth/controllers/user_controller.dart';
import 'package:gappy/features/auth/views/login_screen.dart';
import 'package:gappy/features/feed/components/custom_container.dart';
import 'package:gappy/features/feed/controllers/post_controller.dart';
import 'package:gappy/features/feed/views/create_post_screen.dart';
import 'package:gappy/features/shared/components/custom_text.dart';
import 'package:gappy/features/shared/components/custom_text_field.dart';
import 'package:gappy/features/shared/components/like_button.dart';
import 'package:gappy/utils/routes.dart';
import 'package:go_router/go_router.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postControllerProvider);
    final userController = ref.read(userControllerProvider);
    final TextEditingController text = TextEditingController();

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   title: CustomTextField(
      //     onChanged: (value) {},
      //     labelText: 'Email',
      //     controller: text,
      //     enabled: false,
      //   ),
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 60,
            ),
            InkWell(
              onTap: () {
                context.go(createPostPath);
              },
              child: CustomTextField(
                marginAll: 15,
                onChanged: (value) {},
                labelText: "What's on your mind?",
                controller: text,
                enabled: false,
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return CustomContainer(
                  marginAll: 20,
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: post.userProfilePhoto != null
                                  ? FileImage(File(post.userProfilePhoto!))
                                  : AssetImage('assets/images/user_image.png')
                                      as ImageProvider,
                            ),
                            CustomText(
                              text:
                                  "${post.userFirstName} ${post.userLastName}",
                              fontWeight: FontWeight.w700,
                              marginLeft: 10,
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => ref
                              .read(postControllerProvider.notifier)
                              .deletePost(post.id),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (post.imageUrl != null)
                          Image.file(File(post.imageUrl!)),
                        CustomText(
                          text: post.text,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                        Row(
                          children: [
                            LikeButton(
                              onTap: () {
                                ref
                                    .read(postControllerProvider.notifier)
                                    .likePost(post.id);
                              },
                            ),
                            CustomText(
                              text: "${post.likes} likes",
                              marginLeft: 10,
                              fontSize: 13,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
