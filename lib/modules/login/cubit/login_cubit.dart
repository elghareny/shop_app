import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  LoginModel? loginModel ;

void userLogin(
  {
    @required String? email,
    @required String? password,
})
{
  emit(LoginLoadingState());
  DioHelper.postData(
    url: LOGIN,
     data: {
      'email':email,
      'password':password
     }).then((value) {
      loginModel = LoginModel.fromJson(value.data);
      print(loginModel!.status);
      print(loginModel!.message);
      print(loginModel!.data!.token);
      print(value.data);
      emit(LoginSuccessState(loginModel!));
      }).catchError((error)
      {
        emit(LoginErrorState(error));
      });
}

IconData suffixIcon = Icons.visibility_outlined;
bool isPassword = true;
void changePassword()
{
  isPassword = !isPassword;
  suffixIcon =isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
  emit(ChangePasswordState());
}

}
