// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'notif_bloc.dart';

@immutable
abstract class NotifState {}

class NotifInitial extends NotifState {}

class NotifLoadingState extends NotifState {}

class NotifLoadedState extends NotifState {
  List<UserNotifications> userNotifs;
  List<String> userNames;
  List<String> imgUrls;
  NotifLoadedState(
      {required this.userNotifs,
      required this.userNames,
      required this.imgUrls});
}

class NotifEmptyState extends NotifState {}
