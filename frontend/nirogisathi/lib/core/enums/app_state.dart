import 'package:equatable/equatable.dart';
import 'user_role.dart';

abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object?> get props => [];
}

class AppLoading extends AppState {
  const AppLoading();
}

class Unauthenticated extends AppState {
  const Unauthenticated();
}

/// State when we have a saved UID but need MPIN verification
class MpinRequired extends AppState {
  final String mobile;
  const MpinRequired(this.mobile);

  @override
  List<Object?> get props => [mobile];
}

/// State to show manual role selection
class RoleSelectionRequired extends AppState {
  final String userName;
  const RoleSelectionRequired(this.userName);

  @override
  List<Object?> get props => [userName];
}

class LocationPermissionRequired extends AppState {
  final UserRole role;
  const LocationPermissionRequired(this.role);

  @override
  List<Object?> get props => [role];
}

class AuthenticatedWithRole extends AppState {
  final UserRole role;
  final String userName;
  const AuthenticatedWithRole(this.role, [this.userName = "User"]);

  @override
  List<Object?> get props => [role, userName];
}
