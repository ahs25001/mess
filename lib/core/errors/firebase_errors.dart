abstract class FirebaseErrors {
  String error;
  FirebaseErrors({required this.error});
}
class FirebaseRemoteError extends FirebaseErrors {
  FirebaseRemoteError({required super.error});
}
class FirebaseLocalError extends FirebaseErrors {
  FirebaseLocalError({required super.error});
}
