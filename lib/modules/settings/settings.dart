import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';

class Settings extends StatelessWidget {
   Settings({super.key});
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (BuildContext context, state) 
      {
        if(state is ShopSuccessUpdateUserState)
        {
          ShopCubit.get(context).getUserData();
        }
      },
      builder: (BuildContext context, Object? state) 
      {
        var cubit = ShopCubit.get(context);


        nameController.text = cubit.userModel!.data!.name!;
        emailController.text = cubit.userModel!.data!.email!;
        phoneController.text = cubit.userModel!.data!.phone!;


        return ConditionalBuilder(
          condition: cubit.userModel !=null,
          fallback: (context) => Center(child: CircularProgressIndicator()),
          builder: (context) => Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [            
                if(state is ShopLoadingUpdateUserState)
                  LinearProgressIndicator(),

                  SizedBox(
                    height: 20,
                  ),
                textField(
                  keyboardType: TextInputType.name,
                  prefixIcon: Icons.person, 
                  controller: nameController, 
                  validate: (String? value)
                  {
                    if(value!.isEmpty)
                    {
                      return 'name must not be empty';
                    }
                  }, 
                  text: 'Name'),
                  SizedBox(
                    height: 20,
                  ),
                textField(
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email, 
                  controller: emailController, 
                  validate: (String? value)
                  {
                    if(value!.isEmpty)
                    {
                      return 'email must not be empty';
                    }
                  }, 
                  text: 'Email Address'),
                  SizedBox(
                    height: 20,
                  ),
                textField(
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone, 
                  controller: phoneController, 
                  validate: (String? value)
                  {
                    if(value!.isEmpty)
                    {
                      return 'phone must not be empty';
                    }
                  }, 
                  text: 'Phone'),
                  SizedBox(
                    height: 30,
                  ),
                  defaultButton(
                    text: 'Update',
                    function: ()
                    {
                      if(formKey.currentState!.validate())
                      {
                        cubit.updateUserData(
                          name :nameController.text,
                          email :emailController.text,
                          phone :phoneController.text,
                        );
                      }
                    },
                    backcolor: Colors.blue,
                    radius: 40
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  defaultButton(
                    text: 'Logout',
                    function: ()
                    {
                      signOut(context);
                    },
                    backcolor: Colors.red,
                    radius: 40
                  ),
              ],
            ),
          ),
              ),
        );
      },
    );
  }
}