part of 'edit_profile_bloc.dart';

@immutable
abstract class EditProfileState {}

abstract class EditProfileActionState extends EditProfileState {}

class EditProfileInitial extends EditProfileState {}

class EditProfileLoadedSuccessActionState extends EditProfileActionState {
  final Users dbUser;
  EditProfileLoadedSuccessActionState(this.dbUser);
}

class EditProfileLogoutDoneActionState extends EditProfileActionState {}

class EditProfilePhotoClickedActionState extends EditProfileActionState {}

class EditProfileNewDisplayPhotoChosenState extends EditProfileState {
  final ImageProvider photoData;

  EditProfileNewDisplayPhotoChosenState(this.photoData);
}

class EditProfileLoadingState extends EditProfileState {}

class EditProfileErrordDisplayActionState extends EditProfileActionState {
  final String errorMsg;

  EditProfileErrordDisplayActionState(this.errorMsg);
}

class EditProfileSuccessfullyDoneActionState extends EditProfileActionState {}
