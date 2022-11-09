import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/favorites_model.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (BuildContext context, Object? state) {  },
      builder: (BuildContext context, state) {
        var cubit = ShopCubit.get(context);
        return ConditionalBuilder(
          condition: state is! ShopLoadingGetFavoritesState,
          builder: (context) {
            return ListView.separated(
            physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) => buildFAVItem(cubit.favoritesModel!.data!.data![index] , context), 
          separatorBuilder: (context, index) =>Divider(color: Colors.grey,thickness: 1,indent: 20 ,endIndent: 20), 
          itemCount: cubit.favoritesModel!.data!.data!.length);
          } ,
          fallback: (context) => CircularProgressIndicator(),
        );
      }
      );  
  }



Widget buildFAVItem(FavoritesData? model , context) =>Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 120,
        child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: AlignmentDirectional.bottomStart,
                  children: [
                    Image(
                      image: NetworkImage(model!.product!.image!),
                      width: 120,
                      height: 120,
                    ),
                    if (model.product!.discount! != 0)
                      Container(
                        color: Colors.red,
                        padding: EdgeInsets.all(3),
                        child: Text(
                          'DISCOUNT',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      )
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.product!.name!,
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16, height: 1.4),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Text(
                            '${model.product!.price!.toString()}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.blue),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          if (model.product!.discount! != 0)
                            Text(
                              '${model.product!.oldPrice!.toString()}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough),
                            ),
                            Spacer(),
                            IconButton(
                              onPressed: ()
                              {
                                ShopCubit.get(context).changeFavorites(model.product!.id!);
                              }, 
                              icon: CircleAvatar(
                                backgroundColor: ShopCubit.get(context).favorites[model.product!.id]! ? Colors.blue : Colors.grey,
                                radius: 16,
                                child: Icon(Icons.favorite_border,color: Colors.white,size: 19,)))
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
      ),
    );



}