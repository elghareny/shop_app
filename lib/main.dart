import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/layout/shop_layout.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/modules/on_boarding.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  await CacheHelper.init();


  Widget? widget;

  bool? onBoarding = CacheHelper.getData('onBoarding');

  token = CacheHelper.getData('token');
  print(token);

  if(onBoarding != null)
  {
    if(token != null)
    {
      widget = ShopLayout();
    }else widget = Login();
  }else
  {
    widget = OnBoarding();
  }

  print('onBoarding : ${onBoarding}');


  runApp( MyApp(startWidget: widget,));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.startWidget});

  final Widget? startWidget;
  

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ShopCubit()..getHomeData()..getCategories()..getFavorites()..getUserData()
          )
      ],
      child: BlocConsumer<ShopCubit,ShopStates>(
        listener: (context, state){},
        builder: (context, state) {
          return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black
          ),
          elevation: 0,),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            elevation: 20,
            showUnselectedLabels: true,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey 
          )
      ),
      home: startWidget,
    );
        }),);
        
  }
}