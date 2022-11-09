import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/modules/search/search.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';

class ShopLayout extends StatelessWidget {
  const ShopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {

        var cubit = ShopCubit.get(context);
        return Scaffold(
        appBar: AppBar(title: Text(
          'Salla',
          style: TextStyle(color: Colors.black,
          fontSize: 40),),
          actions: [IconButton(
            icon: Icon(Icons.search,size: 30),
            onPressed: ()
            {
              navigateTo(context, Search());
            },
          )],
          ),
        body: cubit.bottomScreens[cubit.currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index)
          {
            cubit.changeBottom(index);
          },
          currentIndex: cubit.currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home'
              ),
            BottomNavigationBarItem(
              icon: Icon(Icons.apps),
              label: 'Cateogries'
              ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites'
              ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings'
              ),
                        
          ],
        ),
      );
      },
    );
  }
}