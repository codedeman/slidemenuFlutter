import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


//const background = const Color(0xffb74093);
final Color backgroundColor = Color(0xffb74093);

class MenuDasboardPage extends StatefulWidget{
  @override
  _MenuDasboardPageState createState() => _MenuDasboardPageState();
}

class _MenuDasboardPageState extends State<MenuDasboardPage> with SingleTickerProviderStateMixin{

  bool isCollapsed =  true ;
  double screenWidth, screenHeight;
  static const Duration duration = const Duration(microseconds: 3000);
  AnimationController _controller ;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;

  Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller =  AnimationController(vsync: this,duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    _menuScaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(_controller);

    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0)).animate(_controller);

  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(

        children: <Widget>[
          menu(context),
          dasboard(context)

        ],
      ),

    );
  }

  Widget menu(context){

    return SlideTransition(

      position: _slideAnimation,
      child: ScaleTransition(
        scale: _menuScaleAnimation,

        child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,

            child: Column(

                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,

              children: <Widget>[

                Text("Dasboars",
                  style: TextStyle(color: Colors.white,fontSize: 20),
                ),
                SizedBox(height: 10),

                Text("Messages",
                  style: TextStyle(color: Colors.white,fontSize: 20),
                ),
                SizedBox(height: 10),

                Text("Fund ",
                  style: TextStyle(color: Colors.white,fontSize: 20),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget dasboard(context){

    return AnimatedPositioned(
      duration: duration,
      top: isCollapsed ?0 : 0.2 * screenHeight,
      bottom: isCollapsed ?0 : 0.2 * screenWidth,
      left: isCollapsed ?0 : 0.6 * screenWidth,
      right: isCollapsed ?0 : -0.4 * screenHeight,

      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          animationDuration: duration,
          borderRadius: BorderRadius.all(Radius.circular(40)),
          elevation: 8,
          color: backgroundColor,
          child: SingleChildScrollView(

            scrollDirection: Axis.vertical,
            physics: ClampingScrollPhysics(),

            child: Container(
              padding: const EdgeInsets.only(left: 16,right: 16,top: 48),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[

                      InkWell(child: Icon(Icons.menu, color: Colors.white), onTap: (){
                        setState(() {
                          if(isCollapsed)
                            _controller.forward();
                          else
                            _controller.reverse();
                          isCollapsed = !isCollapsed;
                        });
                      },),
                      Text("My Card" ,style: TextStyle(fontSize: 24,color: Colors.white)),
                      Icon(Icons.settings, color: Colors.white),
                    ],
                  ),

                  SizedBox(height: 50),
                  Container(
                    height:200,

                    child: PageView(
                      controller: PageController(viewportFraction: 0.8),
                      scrollDirection: Axis.horizontal,
                      pageSnapping: true,
                      children: <Widget>[
                        Container(
                          margin:  const EdgeInsets.symmetric(horizontal: 8),
                          color: Colors.redAccent,
                          width: 100,
                        ),
                        Container(
                          margin:  const EdgeInsets.symmetric(horizontal: 8),
                          color: Colors.blueAccent,
                          width: 100,
                        ),
                        Container(
                          margin:  const EdgeInsets.symmetric(horizontal: 8),
                          color: Colors.greenAccent,
                          width: 100,
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Transactions", style: TextStyle(color: Colors.white, fontSize: 20),),
                  ListView.separated(
                    shrinkWrap: true,
                      itemBuilder: (context,index){
                      return ListTile(

                        title: Text("MacBook"),

                        subtitle: Text("Apple"),

                        trailing:  Text("-2900"),
                      );

                  }, separatorBuilder: (context,index){

                      return  Divider(height: 16);

                  }, itemCount: 10)
                  // PageView.builder(itemBuilder: (context,index){
                  //   return
                  // }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

