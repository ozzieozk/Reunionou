import 'package:reunionou_app/models/EventAuthor.dart';
import 'package:reunionou_app/models/Location.dart';
import 'package:reunionou_app/models/User.dart';

class Event{
  int id;
  EventAuthor author;
  String title;
  String description;
  String date;
  String token;
  Location location;//var location = {"id" : 1, "name" : "tour eiffel"......};
  bool isOwned;
  List<User> invitedUser = [];
  double distanceBetweenAuth;

  Event(this.id, this.author, this.title, this.description, this.date, this.token, this.location, this.isOwned);
}