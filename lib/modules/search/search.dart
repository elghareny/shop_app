import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/models/search_model.dart';
import 'package:shop_app/modules/search/cubit/search_cubit.dart';
import 'package:shop_app/modules/search/cubit/search_state.dart';
import 'package:shop_app/shared/components/components.dart';

class Search extends StatelessWidget {
   Search({super.key});

  var formKey = GlobalKey<FormState>();
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) 
        {

        },
        builder: (context, state) {
          var cubit = SearchCubit.get(context);

          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: 
                  [
                    textField(
                      prefixIcon: Icons.search, 
                      controller: searchController, 
                      validate: (value)
                      {
                        if(value!.isEmpty)
                        {
                          return 'enter text to search';
                        }
                        return null;
                      }, 
                      onSubmit: (String? text)
                      {
                        cubit.search(text);
                      },
                      text: 'Search',),
                      SizedBox(height: 10,),
                      if(state is SearchLoadingState)
                      LinearProgressIndicator(),
                      SizedBox(height: 20,),
                      if(state is SearchSuccessState)
                      Expanded(
                        child: ListView.separated(
            physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) => buildSearchItem(cubit.searchModel!.data!.data![index] , context), 
          separatorBuilder: (context, index) =>Divider(color: Colors.grey,thickness: 1,indent: 20 ,endIndent: 20), 
          itemCount: cubit.searchModel!.data!.data!.length)
                      )
                  ],
                ),
              ),
            )
          );
        },
      ),
    );
  }




  Widget buildSearchItem(Product? model , context) =>Padding(
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
                      image: NetworkImage(model!.image!),
                      width: 120,
                      height: 120,
                    ),
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
                        model.name!,
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16, height: 1.4),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Text(
                            '${model.price!.toString()}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.blue),
                          ),
                          SizedBox(
                            width: 5,
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
      ),
    );

    
}
