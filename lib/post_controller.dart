import 'package:buttons_functions/add_post_repository.dart';
import 'package:buttons_functions/post_model.dart';
import 'package:flutter/cupertino.dart';

final postControllerProvider = StateNotifierProvider<PostController, bool> ( ref){
  final postRepository  = ref .watch(postRepositoryProvider) ;
  final storageRepository   = ref.watch(storageRepositoryProvider) ;
  return PostController(
      postRepository: communityRepository,
      storageRepository: storageRepository,
      ref: ref,
    );
  });

class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final Ref ref;
  final StorageRepository _storageRepository;

  PostController({
    required PostRepository postRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })
      : _postRepository = postRepository,
        _ ref = ref,
        _ storageRepository = storageRepository,
        super (false);

      void shareTextPost(
          {
          required BuildContext context,
            required String title,
            required Community SelectedCommunity,
            required String description,
        }) async {
        state = true;
        String postId = const Uuid().v1();
        final user = _ref.read(userProvider)!;

        var selectedCommunity;
        final Post post = Post(
            id: postId,
            title: title,
            communityName: selectedCommunity.name,
            communityProfilePic: selectedCommunity.avatar,
            upvotes: [],
            downvotes: [],
            commentCount: 0,
            username: user.name,
            uid: user.uid,
            type: 'text',
            createdAt: DateTime.now(),
            awards: [],
            description: description,
        );

        final res = await _postRepository.addPost(post);
        state = false;
        res.fold((l) => showSnackbar(context, l.message), (r) {
          showSnackbar(context, 'Posted Sucessfully');
          Routemaster.of(context).pop();
        })
      }

  void shareLinkPost(
      {
        required BuildContext context,
        required String title,
        required Community SelectedCommunity,
        required String link,
      }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    var selectedCommunity;
    final Post post = Post(
      id: postId,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: 'link',
      createdAt: DateTime.now(),
      awards: [],
      link: link,
    );

    final res = await _postRepository.addPost(post);
    state = false;
    res.fold((l) => showSnackbar(context, l.message), (r) {
      showSnackbar(context, 'Posted Sucessfully');
      Routemaster.of(context).pop();
    })
  }

  void shareImagePost(
      {
        required BuildContext context,
        required String title,
        required Community SelectedCommunity,
        required File? file,
      }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    var setectedCommunity;
    final imageRes = await _storageRepository.storefile(
        path:' posts/${setectedCommunity.name} ',
        id: postId,
        file: file
    );

    imageRes.fold((l) => ShowSnackBar(context, l.message), (r) async {
      var selectedCommunity;
      final Post post = Post(
        id: postId,
        title: title,
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar,
        upvotes: [],
        downvotes: [],
        commentCount: 0,
        username: user.name,
        uid: user.uid,
        type: 'link',
        createdAt: DateTime.now(),
        awards: [],
        link: r,
      );

      final res = await _postRepository.addPost(post);
      state = false;
      res.fold((l) => showSnackbar(context, l.message), (r) {
        showSnackbar(context, 'Posted Sucessfully');
        Routemaster.of(context).pop();
      });
    });
  }
  }
