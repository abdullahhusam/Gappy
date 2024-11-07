import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gappy/features/auth/views/login_screen.dart';
import 'package:gappy/features/feed/controllers/post_controller.dart';
import 'package:gappy/features/shared/components/custom_button.dart';
import 'package:gappy/utils/routes.dart';
import 'package:go_router/go_router.dart';

class CreatePostPage extends ConsumerWidget {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postController = ref.watch(postControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("What's on Your Mind?")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(labelText: 'Enter post text'),
            ),
            CustomButton(
              marginTop: 50,
              text: "Pick Image and Submit",
              onPressed: () async {
                final imageUrl = await postController.pickImage();
                postController.addPost(_textController.text, imageUrl);
                context.go(entryPath);
              },
            ),
          ],
        ),
      ),
    );
  }
}
