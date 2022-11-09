part of 'register_cubit.dart';


abstract class RegisterState {}

class RegisterInitialState extends RegisterState {}
class RegisterLoadingState extends RegisterState {}
class RegisterSuccessState extends RegisterState 
{
  final LoginModel registerModel;

  RegisterSuccessState(this.registerModel);

}
class RegisterErrorState extends RegisterState 
{
  final String error;

  RegisterErrorState(this.error);
}

class ChangePasswordRegisterState extends RegisterState {}

