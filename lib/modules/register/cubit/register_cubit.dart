import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  LoginModel? registerModel ;

void userRegister(
  {
    @required String? email,
    @required String? name,
    @required String? phone,
    @required String? password,
})
{
  emit(RegisterLoadingState());
  DioHelper.postData(
    url: REGISTER,
     data: {
      'name':name,
      'email':email,
      'password':password,
      'phone':phone,
     }).then((value) {
      registerModel = LoginModel.fromJson(value.data);
      emit(RegisterSuccessState(registerModel!));
      }).catchError((error)
      {
        emit(RegisterErrorState(error));
      });
}

IconData suffixIcon = Icons.visibility_outlined;
bool isPassword = true;
void changePassword()
{
  isPassword = !isPassword;
  suffixIcon =isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
  emit(ChangePasswordRegisterState());
}

}
