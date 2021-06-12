class validator{

  static bool validate_email(String email){
    if (email.isEmpty || !email.contains('@') || !email.contains('.'))
      return false;
    else
      return true;
  }

  static bool validate_password(String password){
    if(password == null || password.isEmpty)
      return false;
    else
      return true;
  }
}