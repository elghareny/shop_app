
import 'package:flutter/material.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';




class BoardingModel{
  final String? image;
  final String? title;
  final String? body;

  BoardingModel({
    required this.image,
    required this.title,
    required this.body});

}


class OnBoarding extends StatefulWidget {
  
    @override
  State<OnBoarding> createState() => _OnBoardingState();
}

var boardController = PageController();

bool? islast;

  List <BoardingModel> boarding =[
    BoardingModel(
      image: 'assets/images/boarding.jpg',
      title: 'on boarding 1 title',
      body: 'on boarding 1 body'),
    BoardingModel(
      image: 'assets/images/boarding.jpg',
      title: 'on boarding 2 title',
      body: 'on boarding 2 body'),
    BoardingModel(
      image: 'assets/images/boarding.jpg',
      title: 'on boarding 2 title',
      body: 'on boarding 2 body'),
  ];


class _OnBoardingState extends State<OnBoarding> {
  @override
  Widget build(BuildContext context) {




    void submit()
{
  CacheHelper.saveData(key: 'onBoarding',
   value: true)
   !.then((value) 
   {
    navigateAndFinis(context, Login());
   });
}



    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(onPressed: submit,
          child: Text('Skip',style: TextStyle(fontSize: 25),))
      ]),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: boardController,
                itemBuilder: (context, index) => buildBoardingItem(boarding[index]),
                itemCount: boarding.length,
                physics: BouncingScrollPhysics(),
                onPageChanged: (int index)
                {
                  if(index == boarding.length - 1)
                  {
                    setState(() {
                      islast = true;
                    });
                    print('last');
                  }else
                  {
                    islast = false;
                    print('not last');
                  }
                },
              
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: boardController,
                  count: boarding.length,
                  effect: ExpandingDotsEffect(
                    dotColor: Colors.grey,
                    dotHeight: 10,
                    expansionFactor: 4,
                    dotWidth: 10,
                    spacing: 5,
                    activeDotColor: Colors.blue
                  ),
                ),
                Spacer(),
                FloatingActionButton(onPressed: ()
                {
                  if(islast == true)
                  {
                    submit();
                  }else
                  {
                    boardController.nextPage(duration: Duration(milliseconds: 750), curve: Curves.fastLinearToSlowEaseIn);
                  }
                },
                child: Icon(Icons.arrow_forward_ios),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

Widget buildBoardingItem(BoardingModel model)=> Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Image.asset("${model.image}")),
            Text('${model.title}',style: TextStyle(fontSize: 34),),
            SizedBox(height: 30,),
            Text('${model.body}',style: TextStyle(fontSize: 24),),
          ],
        );

}
