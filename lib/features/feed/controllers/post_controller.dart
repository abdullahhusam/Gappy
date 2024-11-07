import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gappy/features/auth/controllers/user_controller.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import '../models/post_model.dart';

final postControllerProvider =
    StateNotifierProvider<PostController, List<Post>>(
  (ref) => PostController(ref),
);

class PostController extends StateNotifier<List<Post>> {
  final Ref ref;
  late Box<Post> _postsBox;

  PostController(this.ref) : super([]) {
    _initializePostsBox();
  }

  Future<void> _initializePostsBox() async {
    _postsBox = await Hive.openBox<Post>('postsBox');
    loadPosts();
  }

  void loadPosts() {
    // Load posts from Hive, sort by likes, and update the state
    final savedPosts = _postsBox.values.cast<Post>().toList()
      ..sort((a, b) => b.likes.compareTo(a.likes));
    state = savedPosts;
  }

  void addPost(String text, [String? imageUrl]) {
    final userController = ref.read(userControllerProvider);
    final currentUser = userController.currentUser;

    final newPost = Post(
      id: DateTime.now().toString(),
      text: text,
      imageUrl: imageUrl,
      userFirstName: currentUser!.firstName,
      userLastName: currentUser.lastName,
      userProfilePhoto: currentUser.userPhoto,
    );

    _postsBox.add(newPost);
    state = [...state, newPost];
  }

  void updatePost(String id, String newText) {
    final index = state.indexWhere((post) => post.id == id);
    if (index != -1) {
      final updatedPost = Post(
        id: state[index].id,
        text: newText,
        imageUrl: state[index].imageUrl,
        likes: state[index].likes,
        userFirstName: state[index].userFirstName,
        userLastName: state[index].userLastName,
        userProfilePhoto: state[index].userProfilePhoto,
      );

      _postsBox.putAt(index, updatedPost);
      state = [...state]..[index] = updatedPost;
    }
  }

  void deletePost(String id) {
    final index = state.indexWhere((post) => post.id == id);
    if (index != -1) {
      _postsBox.deleteAt(index);
      state = state.where((post) => post.id != id).toList();
    }
  }

  void likePost(String id) {
    final index = state.indexWhere((post) => post.id == id);
    if (index != -1) {
      final likedPost = Post(
        id: state[index].id,
        text: state[index].text,
        imageUrl: state[index].imageUrl,
        likes: state[index].likes + 1,
        userFirstName: state[index].userFirstName,
        userLastName: state[index].userLastName,
        userProfilePhoto: state[index].userProfilePhoto,
      );

      _postsBox.putAt(index, likedPost);
      state = [...state]..[index] = likedPost;
    }
  }

  Future<String?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile?.path;
  }
}
