import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:slikker_ripple/slikker_ripple.dart';

export 'package:slikker_ripple/slikker_ripple.dart';
export 'package:flutter/material.dart';

/// Widget that helps to build a page. 
/// Full documentation will be later
class SlikkerScaffold extends StatefulWidget {
   /// Widget that is displayed on top of `header`. Useally is a text which 
   /// indicates which page is it. In Material design it wuld be `AppBarTitle`
   final Widget title; 

   /// Widget that is displayed on top of `content`. In Material Design it 
   /// would be the `AppBar`.
   final Widget header; 

   /// Widget, usually `ListView`/`GridView` that contains other widgets. 
   /// Content of the page.
   final Widget content; 

   /// `TopButton`'s title. Usually text that hints which action will be taken 
   /// when user taps the button or pulls the page.
   final String topButtonTitle; 

   /// `TopButton`'s icon. Usually used for hinting which action will be taken 
   /// when user taps the button or pulls the page.
   final IconData topButtonIcon; 

   /// The function that will be called when user pulls the page or taps the 
   /// `TopButton`.
   final Function topButtonAction;
   
   /// Widget that is placed in the bottom of the screen, always visible, and 
   /// floats above the `content`.
   final Widget floatingButton; 

   SlikkerScaffold({ this.title, this.header, this.content, 
   this.topButtonAction, this.floatingButton,this.topButtonTitle, 
   this.topButtonIcon, });

   @override _SlikkerScaffoldState createState() => _SlikkerScaffoldState();
}

class _SlikkerScaffoldState extends State<SlikkerScaffold> {
   bool pull100; bool pullAct; bool startedAtZero; Function refreshTopButton;

   @override void initState() {
      super.initState();
      pull100 = false; 
      pullAct = false;
      startedAtZero = false;
   }

   void topButtonCallback(Function topButtonFunction) => refreshTopButton = topButtonFunction;
   
   @override Widget build(BuildContext context) {
  		return Material(
         color: Color(0xFFF6F6FC),
         child: SafeArea(
				top: true,
            child: Stack(
               children: [
                  NotificationListener<ScrollNotification>(
                     onNotification: (scrollInfo) {
                        if (scrollInfo is ScrollUpdateNotification && startedAtZero) {
                           int percent = -scrollInfo.metrics.pixels.round();
                           if (percent >= 100 && !pull100) { 
                              HapticFeedback.lightImpact(); 
                              pull100 = pullAct = true; 
                           }

                           if (percent < 100 && pull100) pull100 = pullAct = false; 

                           if (scrollInfo.dragDetails == null && pullAct) { 
                              pullAct = false; 
                              widget.topButtonAction(); 
                           }
                           refreshTopButton(percent);
                        } 
                        else if (scrollInfo is ScrollStartNotification) startedAtZero = scrollInfo.metrics.pixels <= 0; 
                        return false;
                     },
                     child: ListView(
                        scrollDirection: Axis.vertical,
                        physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                        children: <Widget>[
                           Container( height: 52 ),
                           Center( 
                              child: TopButton(
                                 title: widget.topButtonTitle, 
                                 icon: widget.topButtonIcon, 
                                 accent: 240,
                                 onTap: widget.topButtonAction,
                                 refreshFunction: topButtonCallback,
                              ) 
                           ),
                           Container( height: MediaQuery.of(context).size.height/3.7 ),
                           widget.title, 
                           Container( height: 20 ),
                           widget.header,
                           Padding(
                              child:widget.content,
                              padding: EdgeInsets.all(30),
                           ),
                           Container(height: 60)
                        ],
                     )
                  ),
                  Align(
                     alignment: Alignment.bottomCenter,
                     child: Container(
                        decoration: BoxDecoration(
                           gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment(0,0.25),
                              colors: [ Color(0x00F6F6FC), Color(0xFFF6F6FC) ]
                           )
                        ),
                        height: 84,
                     ),
                  ),
                  Align(
                     alignment: Alignment.bottomCenter,
                     child: Container(
                        child: widget.floatingButton,
                        margin: EdgeInsets.only(bottom: 25),
                     )
                  ),
               ],
            )
			)
      );
   }
}






class TopButton extends StatefulWidget {       
   final String title; final IconData icon; 
   final double accent; final Function onTap; 
   final Function refreshFunction;

   TopButton({ this.title, this.icon, this.accent, this.onTap, this.refreshFunction });

   @override _TopButtonState createState() => _TopButtonState();
}

class _TopButtonState extends State<TopButton> {
   int percent = 0; Color color;

   void refresh(p) { if (percent != p) setState(() => percent = p); }

   @override void initState() {
      super.initState();
      widget.refreshFunction(refresh);
      color = HSVColor.fromAHSV(1, widget.accent, 0.4, 0.2).toColor();
   }

   @override Widget build(BuildContext context) {
      return SlikkerCard(
         accent: 240,
         borderRadius: BorderRadius.circular(52),
         isFloating: false,
         onTap: this.widget.onTap,
         padding: EdgeInsets.fromLTRB(14, 13, 17, 14),
         child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
               percent == 0 ? 
                  Icon(
                     widget.icon, 
                     color: color, 
                     size: 22,
                  ) : Padding(
                     padding: EdgeInsets.all(3),
                     child: SizedBox(
                        child: CircularProgressIndicator(
                           value: percent/100,
                           strokeWidth: 3,
                           valueColor: AlwaysStoppedAnimation<Color>(color),
                        ),
                        height: 16,
                        width: 16,
                     ),
                  ),
               Container(width: 8, height: 24),
               Text(widget.title, style: TextStyle(
                  color: color, fontWeight: FontWeight.w600, fontSize: 16
               ))
            ]
         ),
      );
   }
}





class SlikkerCard extends StatefulWidget {
   /// The Hue which will be used for your card.
   final double accent; 

   /// If `true` *[DEFAULT]*, your widget gets shadows, pressing-like tap 
   /// feedback, and z-axis.
   final bool isFloating; 

   /// Decides how curved will be sides of your card. Default is 
   /// `BorderRadius.all(Radius.circular(12))`
   final BorderRadiusGeometry borderRadius; 

   /// The widget that is placed inside *SlikkerCard* widget
   final Widget child; 

   final EdgeInsetsGeometry padding; 

   /// The `Function` that will be invoked on user's tap.
   final Function onTap; 
   
   @override _SlikkerCardState createState() => _SlikkerCardState();

   static fun() {}

   SlikkerCard({ 
      this.accent = 240, 
      this.isFloating = true, 
      this.child = const Text('hey?'), 
      this.padding = const EdgeInsets.all(0), 
      this.onTap = fun, 
      this.borderRadius = const BorderRadius.all(Radius.circular(12)),
   });
}

class _SlikkerCardState extends State<SlikkerCard> with TickerProviderStateMixin{
   HSVColor color;
   AnimationController tapController;
   CurvedAnimation tapAnimation;

   @override void initState() {
      super.initState();
      color = HSVColor.fromAHSV(
         widget.isFloating ? 1 : 0.075, 
         widget.accent, 
         widget.isFloating ? 0.6 : 0.3, 
         widget.isFloating ? 1 : 0.75
      );

      tapController = AnimationController(
         vsync: this,
         duration: Duration(milliseconds: 175),
      );

      tapAnimation = CurvedAnimation(
         curve: Curves.easeOut,
         parent: tapController
      );
      
      tapAnimation.addListener(() => setState(() {}));
   }

   @override void dispose() {
      tapController.dispose();
      super.dispose();
   }

   @override Widget build(BuildContext context) {
      return Container( 
         decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            color: Colors.transparent,
            boxShadow: widget.isFloating ? [
               BoxShadow (
                  color: color.withSaturation(0.6).withAlpha(0.12 + tapAnimation.value * -0.05).toColor(),
                  offset: Offset(0, 7 + tapAnimation.value * -2),
                  blurRadius: 40 + tapAnimation.value * -10,
               ),
               BoxShadow (
                  color: color.withSaturation(0.05 + tapAnimation.value * 0.01).toColor(),
                  offset: Offset(0,3),
               ),
            ] : [],          
         ),
         child: Transform.translate(
            offset: Offset(0, widget.isFloating ? tapAnimation.value*3 : 0),
            child: Material(
               clipBehavior: Clip.hardEdge,
               color: widget.isFloating ? Colors.white : color.toColor(),
               borderRadius: widget.borderRadius,
               child: InkWell(
                  splashFactory: SlikkerRipple(),
                  splashColor: color.withAlpha(widget.isFloating ? 0.125 : 0.25)
                     .withValue(widget.isFloating ? 1 : 0.85)
                     .withSaturation(widget.isFloating ? 0.6 : 0.15)
                     .toColor(),
                  highlightColor: color.withAlpha(0.01).toColor(),
                  hoverColor: Colors.transparent,
                  onTapDown: (a) { 
                     HapticFeedback.lightImpact(); 
                     tapController.forward();
                  },
                  onTapCancel: () { 
                     tapController.reverse();
                  },
                  onTap: () { 
                     widget.onTap();
                     tapController.forward();
                     Future.delayed( 
                        Duration(milliseconds: 175), () { 
                           tapController.reverse(from: 1);
                        }
                     ); 
                  },
                  child: Padding(
                     padding: widget.padding,
                     child: widget.child
                  )
               ),
            ),
         )
      );
   }
}
