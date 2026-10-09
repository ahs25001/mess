abstract class SharedPreferencesErrors {
  String message;
  SharedPreferencesErrors(this.message);
}
class SharedPreferencesLocalErrors extends SharedPreferencesErrors{
  SharedPreferencesLocalErrors(super.message);
}