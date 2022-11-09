import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';

void signOut(context)
{
   CacheHelper.removeData(key: 'token')!.then((value) 
            {
              if(value)
              {
                navigateAndFinis(context, Login());
              }
            });
}


void PrintFullText (String text)
{
  final pattern = RegExp('.{1,800}');
  // pattern.allMatches(text).forEach((element) => print(match.group(0)));
}


String? token = '';