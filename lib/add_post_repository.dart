final postRepositoryProvider = Provider((ref) {
  return PostRepository(
    firestore: ref.watch(firestoreProvider),
  );
});// Provider

class PostRepository{
  final FirebaseFirestore_firestore;
  PostRepository({required FirebaseFirestore firestore}):_firestore = firestore;

  CollectionReference get _posts => _ firestore. collection(FirebaseConstants.postsCollection);

  }
  FutureVoid addPost (Post post) async {
  try{
    return right(_posts.doc(post.id) .set(post.toMap()));
    } on FirebaseException catch (e) {
    throw e.message!;
    } catch (e){
    return left(Failure(e.toString()));
      }
    }
  }