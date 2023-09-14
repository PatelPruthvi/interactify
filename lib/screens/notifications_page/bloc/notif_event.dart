part of 'notif_bloc.dart';

@immutable
abstract class NotifEvent {}

class NotifInitialEvent extends NotifEvent {
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshot;
  final FirebaseAuth auth;

  NotifInitialEvent(this.snapshot, this.auth);
}
