part of 'edit_profile_bloc.dart';

@immutable
abstract class EditProfileEvent {}

class EditProfileInitialEvent extends EditProfileEvent {
  final FirebaseAuth auth;

  EditProfileInitialEvent(this.auth);
}

class EditProfilePhotoClickedEvent extends EditProfileEvent {}

class EditProfileLogOutClickedEvent extends EditProfileEvent {
  final FirebaseAuth auth;

  EditProfileLogOutClickedEvent(this.auth);
}

class EditProfileDoneClickedEvent extends EditProfileEvent {
  final FirebaseAuth auth;
  final String profileName;
  final String userName;
  final String bio;

  EditProfileDoneClickedEvent(
      this.auth, this.profileName, this.userName, this.bio);
}

class EditProfileTakePhotoFromCameraPressedEvent extends EditProfileEvent {}

class EditProfileTakePhotoFromGalleryePressedEvent extends EditProfileEvent {}

class EditProfileRemoveCurrentDPPressedEvent extends EditProfileEvent {
  final FirebaseAuth auth;

  EditProfileRemoveCurrentDPPressedEvent(this.auth);
}
