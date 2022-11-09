import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/change_favorites_model.dart';
import 'package:shop_app/models/favorites_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/cateogries/cateogries.dart';
import 'package:shop_app/modules/favorites/favorites.dart';
import 'package:shop_app/modules/products/products.dart';
import 'package:shop_app/modules/settings/settings.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);


  int currentIndex = 0 ;

  List<Widget> bottomScreens = 
  [
    Products(),
    Cateogries(),
    FavoritesScreen(),
    Settings(),
  ];

  void changeBottom(int index)
  {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }


Map<int,bool> favorites = {};


  HomeModel? homeModel;

  void getHomeData()
  {
    emit(ShopLoadingHomeDataState());

    DioHelper.getData(
      url: HOME,
      token: token
      )
    .then((value)
     {
      homeModel = HomeModel.fromJson(value.data);
      print(homeModel!.data!.products[0]);
      emit(ShopSuccessHomeDataState());
      homeModel!.data!.products.forEach((element){
        favorites.addAll({
          element.id! : element.inFavorites!,
        });
      });
      print(favorites.toString());
     }).
     catchError((error)
     {
      print(error.toString());
      emit(ShopErrorHomeDataState());
     });
  }




  CategoriesModel? categoriesModel;

  void getCategories()
  {
    DioHelper.getData(
      url: GET_CATEGORIES,
      token: token
      )
    .then((value)
     {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(ShopSuccessCategoriesState());
     }).
     catchError((error)
     {
      print(error.toString());
      emit(ShopErrorCategoriesState());
     });
  }

ChangeFavoritesModel? changeFavoritesModel;


void changeFavorites(int? productId)
{
  favorites[productId!] = !favorites[productId]!;
   emit(ShopChangeFavoritesState());
  DioHelper.postData(
    url: FAVORITES, 
    data: 
    {
      'product_id' : productId
    },
    token: token
    ).then((value)
     {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      if(!changeFavoritesModel!.status!)
      {
        favorites[productId] = !favorites[productId]!;
      }
      else
      {
        getFavorites();
      }
      emit(ShopSuccessChangeFavoritesState(changeFavoritesModel!));
     }).catchError((error)
     {
      favorites[productId] = !favorites[productId]!;
      emit(ShopErrorChangeFavoritesState());
     });
}


  FavoritesModel? favoritesModel;

  void getFavorites()
  {
    emit(ShopLoadingGetFavoritesState());
    DioHelper.getData(
      url: FAVORITES,
      token: token
      )
    .then((value)
     {
      favoritesModel = FavoritesModel.fromJson(value.data);
      emit(ShopSuccessGetFavoritesState());
     }).
     catchError((error)
     {
      print(error.toString());
      emit(ShopErrorGetFavoritesState());
     });
  }



  LoginModel? userModel;

  void getUserData()
  {
    emit(ShopLoadingUserDataState());
    DioHelper.getData(
      url: PROFILE,
      token: token
      )
    .then((value)
     {
      userModel = LoginModel.fromJson(value.data);
      emit(ShopSuccessUserDataState(userModel!));
     }).
     catchError((error)
     {
      print(error.toString());
      emit(ShopErrorUserDataState());
     });
  }



  void updateUserData({
    @required String? name,
    @required String? email,
    @required String? phone,
  })
  {
    emit(ShopLoadingUpdateUserState());
    DioHelper.putData(
      url: UPDATE,
      token: token,
      data: 
      {
        'name':name,
        'email':email,
        'phone':phone,
      }
      )
    .then((value)
     {
      userModel = LoginModel.fromJson(value.data);
      emit(ShopSuccessUpdateUserState(userModel!));
     }).
     catchError((error)
     {
      print(error.toString());
      emit(ShopErrorUpdateUserState());
     });
  }






}