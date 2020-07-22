import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'material.dart';
void main() => runApp(Planner());

class Planner extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
         theme: ThemeData(fontFamily: 'Manrope'),
			title: 'Yaayyay',
			home: Home(),
		);
	}
}

class Home extends StatelessWidget {
	Widget build(BuildContext context) {
      WidgetsBinding.instance.renderView.automaticSystemUiAdjustment=false;
		SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
			statusBarIconBrightness: Brightness.dark,
			systemNavigationBarColor: Color(0xFFF7F7FC),
			statusBarColor: Color(0x00BABADB),
		));
      var todo = [{'title': 'Testt'},{'title': 'Testt'},{'title': 'Testt'},{'title': 'Testt'},{'title': 'Testt'},{'title': 'Testt'},{'title': 'Testt'},{'title': 'Testt'},{'title': 'Testt'},{'title': 'Testt'},{'title': 'Testt'},{'title': 'Testt'},{'title': 'Testt'},{'title': 'Testt'},{'title': 'Testt'}];
		return Scaffold(
         backgroundColor: Color(0xFFF7F7FC),
         floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
         floatingActionButton: Container(
            child: FloatingButton(title: 'Create', icon: Icons.add),
            margin: EdgeInsets.only(bottom: 14),
         ),
         body: SafeArea(
				top: true,
            child: CustomScrollView(
               physics: BouncingScrollPhysics(),
               slivers: <Widget>[
                  SliverAppBar( expandedHeight: 300.0, backgroundColor: Color(0xFFF7F7FC) ),
                  SliverAppBar(
                     backgroundColor: Color(0xFFF7F7FC),
                     expandedHeight: 70.0,
                     flexibleSpace: FlexibleSpaceBar(  
                        collapseMode: CollapseMode.pin, 
                        background: Text('Heyyyy', style: TextStyle(fontSize: 36.0), textAlign: TextAlign.center,),
                     ),
                  ),
                  SliverAppBar(
                     elevation: 0,
                     pinned: true,
                     titleSpacing: 0,
                     expandedHeight: 52,
                     backgroundColor: Colors.transparent,
                     title: SearchBar(),
                  ),
                  SliverToBoxAdapter(    
                     child: Container(
                        height: 220,
                        clipBehavior: Clip.none,
                        child: ListView.builder(
                           physics: BouncingScrollPhysics(),
                           padding: EdgeInsets.only(top: 30, bottom: 50),
                           scrollDirection: Axis.horizontal,
                           itemCount: todo.length,
                           itemBuilder: (BuildContext context, int i) {
                              return Container(
                                 margin: EdgeInsets.only(right: i==todo.length-1 ? 30 : 20, left: i==0 ? 30 : 0),
                                 height: 140,
                                 width: 110,
                                 child: Layer(
                                    accent: Color(0xFF6666FF),
                                    type: LayerType.card,
                                    position: 1,
                                    child: Container(
                                       padding: EdgeInsets.all(12), 
                                       child: Text('${todo[i]['title']} $i  ')
                                    ),
                                 )
                              );
                           }
                        ),
                     )
                  ),
               ],
            )
			)
      );
	}
}

class SearchBar extends StatelessWidget {
   @override
   Widget build(BuildContext context) {
      return Padding(
         padding: EdgeInsets.symmetric(horizontal: 30),
         child: TextField(
            style: TextStyle(
               fontSize: 16.5,
               color: Color(0xFF1F1F33)                 
            ),
            decoration: new InputDecoration(
               prefixIcon: Container(
                  padding: EdgeInsets.all(15),
                  child: new Icon( Icons.search, size: 22.0, color: Color(0xFF1F1F33)),
               ),
               contentPadding: EdgeInsets.all(17),
               border: new OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
               ),
               hintText: 'Search for anything',
               hintStyle: TextStyle( color: Color(0x88A1A1B2), fontWeight: FontWeight.w600, ),
               filled: true,
               fillColor: Color(0xCCEDEDF7),
            ),
         )
      );
   }
}

