class UserSingleton{
  static UserSingleton? _instance;

   late String _userID;

    UserSingleton._();

    String get userID => _userID;

    // Static method to get the singleton instance
  static UserSingleton get instance {
    _instance ??= UserSingleton._();
    return _instance!;
  }

   // Method to initialize the user value 
  void initializeUserValue(String userID) {
    _userID = userID;
  }

}