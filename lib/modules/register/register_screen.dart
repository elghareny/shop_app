import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/layout/shop_layout.dart';
import 'package:shop_app/modules/register/cubit/register_cubit.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';

class Register extends StatelessWidget {
   Register({Key? key}) : super(key: key);


  var formkey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit,RegisterState>(
        listener: (BuildContext context, state) 
        {
          if(state is RegisterSuccessState)
        {
          if(state.registerModel.status!)
          {
            CacheHelper.saveData(key: 'token', value: state.registerModel.data!.token)!.then((value)
              {
                token = state.registerModel.data!.token;
                ShopCubit.get(context).getUserData();
                navigateAndFinis(context, ShopLayout());
                showToast(text: state.registerModel.message!, state: ToastStates.SUCCESS);
              });
            
            print(state.registerModel.message!);
            print(state.registerModel.data!.token!);
          }else
          {
            showToast(text: state.registerModel.message!, state: ToastStates.ERROR);
            print(state.registerModel.message!);
          }
        }
        },
        builder: (BuildContext context, state) 
        {
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
                        Text('Register',style: TextStyle(
                          fontSize: 50
                        ),),
                        SizedBox(height: 60,),
                        textField(
                          prefixIcon: Icons.person,
                          keyboardType: TextInputType.name,
                          controller: nameController, 
                          validate: (String? value)
                          {
                            if(value!.isEmpty)
                            {
                              return 'please enter your name';
                            }
                          }, 
                          text: 'Name'),
                           SizedBox(height: 40,),
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
                          suffixIcon: RegisterCubit.get(context).suffixIcon,
                          isPassword: RegisterCubit.get(context).isPassword,
                          suffixPressed: ()
                          {
                            RegisterCubit.get(context).changePassword();
                          },
                          keyboardType: TextInputType.visiblePassword,
                          controller: passwordController, 
                          onSubmit: (value)
                          {
                          },
                          validate: (String? value)
                          {
                            if(value!.isEmpty)
                            {
                              return 'please enter your password';
                            }
                          }, 
                          text: 'Password'),
                          SizedBox(height: 40,),
                          textField(
                          prefixIcon: Icons.phone,
                          controller: phoneController, 
                          validate: (String? value)
                          {
                            if(value!.isEmpty)
                            {
                              return 'please enter your phone';
                            }
                          }, 
                          text: 'Phone'),
                          SizedBox(height: 50,),
                          ConditionalBuilder(
                            condition: state is! RegisterLoadingState,
                            builder:(context) => defaultButton(
                              text: 'Register',
                              backcolor: Colors.blue,
                              radius: 40,
                              isUpperCase: false,
                              function: (){
                                if(formkey.currentState!.validate()){
                                RegisterCubit.get(context).userRegister(
                                  email: emailController.text,
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  password: passwordController.text);
                                }
                              },
                            ),
                            fallback: (context) => Center(child: CircularProgressIndicator()),
                          ),                
                      ],
                    ),
                  ),
                ),
              ),
            ),
        );
        },
      ),
    );
  }
}