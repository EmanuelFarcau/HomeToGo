class AppUser {
  //final String uid;
  final String? email;
  final String? displayName;
  final List<String>? favoriteProductsId;

  AppUser({required this.email, this.displayName, this.favoriteProductsId});

  factory AppUser.fromMap(Map<dynamic, dynamic> map) {
    return AppUser(
      email: map['email'] ?? "",
      displayName: map['displayName'] ?? "",
      favoriteProductsId: map['favoriteProductsId'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'favoriteProductsId': favoriteProductsId,
    };
  }

  @override
  String toString() {
    return 'email: $email, displayName: $displayName, favoriteProductsId: $favoriteProductsId, ';
  }
}
