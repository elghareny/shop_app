
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/shared/components/components.dart';

class Products extends StatelessWidget {
  const Products({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) 
        {
          if(state is ShopSuccessChangeFavoritesState)
          {
            if(!state.model.status!)
            {
              showToast(text: state.model.message,state: ToastStates.ERROR);
            }
          }
        },
        builder: (context, state) {
          var cubit = ShopCubit.get(context);
          return ConditionalBuilder(
              condition: cubit.homeModel != null && cubit.categoriesModel !=null,
              builder: (context) => productsBuilder(cubit.homeModel , cubit.categoriesModel , context),
              fallback: (context) =>
                  Center(child: CircularProgressIndicator()));
        });
  }

  Widget productsBuilder(HomeModel? model, CategoriesModel? categoriesModel ,context) => SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
                items: model!.data!.banners
                    .map((e) => Image(
                          image: NetworkImage('${e.image}'),
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ))
                    .toList(),
                options: CarouselOptions(
                    height: 250.0,
                    initialPage: 0,
                    viewportFraction: 1.0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(seconds: 3),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    scrollDirection: Axis.horizontal)),
            SizedBox(
              height: 10,
            ),
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 10),
             child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text('Categories',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 24,
              ),
              ),
              SizedBox(
              height: 10,
            ),
              Container(
                height: 100,
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) =>buildCategoryItem(categoriesModel.data!.data[index]), 
                  separatorBuilder: (context, index) => SizedBox(
                  width: 10,
                ), 
                  itemCount: categoriesModel!.data!.data.length),
              ),
              SizedBox(
              height: 20,
            ),
              Text('New Products',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 24,
              ),
              ),
              ],
             ),
           ),
            SizedBox(
              height: 10,
            ),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
              childAspectRatio: 1 / 1.3,
              children: List.generate(model.data!.products.length,
                  (index) => buildGridProduct(model.data!.products[index],context)),
            )
          ],
        ),
      );


   Widget buildCategoryItem(DataModel dataModel) =>  Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Image(image: NetworkImage(dataModel.image!),
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                ),
              Container(
                color: Colors.black.withOpacity(.8),
                width: 100,
                child: Text(dataModel.name!,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                ),
                ))
              ],
            );

  Widget buildGridProduct(ProductsModel model , context) => Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  image: NetworkImage(model.image!),
                  width: double.infinity,
                  height: 200,
                ),
                if (model.discount != 0)
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name!,
                    maxLines: 2,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16, height: 1.4),
                  ),
                  Row(
                    children: [
                      Text(
                        '${model.price!.round()}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.blue),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      if (model.discount != 0)
                        Text(
                          '${model.oldPrice!.round()}',
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
                            ShopCubit.get(context).changeFavorites(model.id!);
                          }, 
                          icon: CircleAvatar(
                            backgroundColor: ShopCubit.get(context).favorites[model.id]! ? Colors.blue : Colors.grey,
                            radius: 16,
                            child: Icon(Icons.favorite_border,color: Colors.white,size: 19,)))
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      );
}
