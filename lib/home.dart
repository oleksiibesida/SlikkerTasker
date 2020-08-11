import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'material.dart';
import 'parts.dart';

class HomeView extends StatefulWidget { @override _HomeViewState createState() => _HomeViewState(); }

class _HomeViewState extends State<HomeView> {
   var pullPercent = 0;
	@override
	Widget build(BuildContext context) {
		var todo = [{'title': 'Testt'},{'title': 'Testt'},{'title': 'Testt'},{'title': 'Testt'},];
		return NotificationListener<ScrollNotification>(
         onNotification: (scrollInfo) {
            var scroll = scrollInfo.metrics.pixels.round();
            var tempPercent = scroll <= 0 ? ( scroll >= -100 ? 0-scroll : 100 ) : 0;
            if (tempPercent != pullPercent) setState(() { pullPercent = tempPercent; if (pullPercent == 100) { HapticFeedback.lightImpact(); } });
            return false;
         },
         child: CustomScrollView(
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            slivers: <Widget>[
               SliverFixedExtentList( itemExtent: 50,
                  delegate: SliverChildListDelegate([Container()]),
               ),
               SliverToBoxAdapter(
                  child: Center(
                     child: Layer(
                        accent: 240,
                        corningStyle: CorningStyle.full,
                        objectType: ObjectType.field,
                        padding: EdgeInsets.fromLTRB(14, 13, 17, 14),
                        child: Row(
                           mainAxisSize: MainAxisSize.min,
                           children: <Widget>[
                              pullPercent == 0 ? 
                                 Icon(
                                    Icons.settings, 
                                    color: Color(0xFF1F1F33), 
                                    size: 22,
                                 ) : 
                                 Padding(
                                    padding: EdgeInsets.all(3),
                                    child: SizedBox(
                                       child: CircularProgressIndicator(
                                          value: pullPercent/100,
                                          strokeWidth: 3,
                                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1F1F33)),
                                       ),
                                       height: 16,
                                       width: 16,
                                    ),
                                 ),
                              Container(width: 8, height: 24),
                              Text('Settings', style: TextStyle(
                                 color: Color(0xFF1F1F33), fontWeight: FontWeight.w600, fontSize: 16
                              ))
                           ]
                        ),
                     )
                  )
               ),
               SliverFixedExtentList( itemExtent: MediaQuery.of(context).size.height/3.7,
                  delegate: SliverChildListDelegate([Container()]),
               ),
               SliverAppBar(
                  backgroundColor: Color(0xFFF7F7FC),
                  expandedHeight: 70.0,
                  flexibleSpace: FlexibleSpaceBar(  
                     collapseMode: CollapseMode.pin, 
                     background: Text('Heyheyy', style: TextStyle(fontSize: 36.0), textAlign: TextAlign.center,),
                  ),
               ),
               SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverPersistentHeaderDlgt(
                     minHeight: 54.0,
                     maxHeight: 54.0,
                     child: SearchBar(),
                  ),
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
                                 accent: 240,
                                 padding: EdgeInsets.all(20),
                                 corningStyle: CorningStyle.partial,
                                 objectType: ObjectType.floating,
                                 child: Text('${todo[i]['title']} $i  ')
                              )
                           );
                        }
                     ),
                  )
               ), 
               SliverToBoxAdapter(child: Container(height: 200),)
            ],
         )
      );
	}
}

class Home extends StatelessWidget {
   toCreate(context) => Navigator.pushNamed(context, '/create');
	Widget build(BuildContext context) {
		return Scaffold(
         backgroundColor: Color(0xFFF7F7FC),
         floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
         floatingActionButton: Container(
            child: Layer(
               accent: 240,
               corningStyle: CorningStyle.full,
               objectType: ObjectType.floating,
               padding: EdgeInsets.fromLTRB(14, 15, 16, 15),
               onTap: () => toCreate(context),
               child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                     Icon(Icons.add, color: Color(0xFF6666FF),), 
                     Container(width: 7, height: 24),
                     Text('Create', style: TextStyle(
                        color: Color(0xFF6666FF), fontWeight: FontWeight.w600, fontSize: 16
                     ),)
                  ]
               ),
            ),
            margin: EdgeInsets.only(bottom: 14),
         ),
         body: SafeArea(
				top: true,
            child: HomeView()
			)
      );
	}
}
