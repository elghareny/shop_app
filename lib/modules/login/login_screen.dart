import 'dart:ui';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/layout/shop_layout.dart';
import 'package:shop_app/modules/login/cubit/login_cubit.dart';
import 'package:shop_app/modules/register/register_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';


class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  var formkey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit,LoginState>
      (listener: (context, state) 
      {
        if(state is LoginSuccessState)
        {
          if(state.loginModel.status!)
          {
            CacheHelper.saveData(key: 'token', value: state.loginModel.data!.token)!.then((value)
              {
                token = state.loginModel.data!.token;
                ShopCubit.get(context).getUserData();
                navigateAndFinis(context, ShopLayout());
                showToast(text: state.loginModel.message!, state: ToastStates.SUCCESS);
              });
            
            print(state.loginModel.message!);
            print(state.loginModel.data!.token!);
          }else
          {
            showToast(text: state.loginModel.message!, state: ToastStates.ERROR);
            print(state.loginModel.message!);
          }
        }
      },
        builder: (context, state) {
          return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Form(
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Login',style: TextStyle(
                      fontSize: 50
                    ),),
                    SizedBox(height: 60,),
                    textField(
                      prefixIcon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController, 
                      validate: (String? value)
                      {
                        if(value!.isEmpty)
                        {
                          return 'please enter your email';
                        }
                      }, 
                      text: 'Email'),
                      SizedBox(height: 40,),
                    textField(
                      prefixIcon: Icons.lock,
                      suffixIcon: LoginCubit.get(context).suffixIcon,
                      isPassword: LoginCubit.get(context).isPassword,
                      suffixPressed: ()
                      {
                        LoginCubit.get(context).changePassword();
                      },
                      keyboardType: TextInputType.visiblePassword,
                      controller: passwordController, 
                      onSubmit: (value)
                      {
                        if(formkey.currentState!.validate()){
                            LoginCubit.get(context).userLogin(email: emailController.text, password: passwordController.text);
                            }
                      },
                      validate: (String? value)
                      {
                        if(value!.isEmpty)
                        {
                          return 'please enter your password';
                        }
                      }, 
                      text: 'Password'),
                      SizedBox(height: 50,),
                      ConditionalBuilder(
                        condition: state is! LoginLoadingState,
                        builder:(context) => defaultButton(
                          text: 'Login',
                          backcolor: Colors.blue,
                          radius: 40,
                          isUpperCase: false,
                          function: (){
                            if(formkey.currentState!.validate()){
                            LoginCubit.get(context).userLogin(email: emailController.text, password: passwordController.text);
                            }
                          },
                        ),
                        fallback: (context) => Center(child: CircularProgressIndicator()),
                      ),
                      SizedBox(height: 40,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Don\'t have an account ?'
                          ,style: TextStyle(fontSize: 20),),
                          TextButton(onPressed: ()
                          {navigateTo(context, Register());
                          }, child: Text('Register',style: TextStyle(fontSize: 20),))
                        ],
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
        },
       )
      
      
    );
  }
}