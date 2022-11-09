import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/models/categories_model.dart';

class Cateogries extends StatelessWidget {
  const Cateogries({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (BuildContext context, Object? state) {  },
      builder: (BuildContext context, state) {
        var cubit = ShopCubit.get(context);
        return ListView.separated(
          physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) => buildCatItem(cubit.categoriesModel!.data!.data[index]), 
        separatorBuilder: (context, index) =>Divider(color: Colors.grey,thickness: 1,indent: 20 ,endIndent: 20), 
        itemCount: cubit.categoriesModel!.data!.data.length);
      }
      ); 
      }

  Widget buildCatItem(DataModel dataModel) => Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Image(image: NetworkImage(dataModel.image!),
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          ),
          SizedBox(
            width: 20,
          ),
          Text(dataModel.name!,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
          ),
          Spacer(),
          Icon(Icons.arrow_forward_ios)
        ],
      ),
    );
}