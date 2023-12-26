import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';
import 'package:animated_background/animated_background.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Screen1 createState() => Screen1();
}

class Screen1 extends State<MyApp> with SingleTickerProviderStateMixin {

  String imageLink='images/img.jpg';
  var particles=ParticleOptions(
    baseColor: Colors.cyan,
    spawnOpacity: 0.0,
    minOpacity: 0.1,
    maxOpacity: 0.4,
    particleCount: 100,
    spawnMinSpeed: 30,
    spawnMaxSpeed: 100,
    spawnMinRadius: 7,
    spawnMaxRadius: 15,
  );

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds:10), () {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>myApp1()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('BMI Demo'),),
      body: AnimatedBackground(
        vsync: this,
        behaviour: RandomParticleBehaviour(options:particles),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 300,
                height: 400,
                decoration: BoxDecoration(
                  border: Border.all(color:Colors.purple,
                      width:5,
                      style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(image: AssetImage(imageLink),
                      fit: BoxFit.cover),
                  color: Colors.white,
                ),
              ),
              SizedBox(height:10),
              Text("我的BMI程式", textAlign: TextAlign.center,
                style: TextStyle(fontSize: 40,
                    fontFamily: "kai",
                    color: Colors.amber,
                    fontWeight: FontWeight.bold),),
            ],
          ),
        ),
      ),
    );
  }
}

class myApp1 extends StatelessWidget {
  const myApp1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(primaryColor: Colors.amber,
        colorScheme: ColorScheme.light(
          primary: Colors.amber,
          secondary: Colors.pinkAccent,),
        appBarTheme: AppBarTheme(backgroundColor: Colors.amber,
          titleTextStyle: TextStyle(color:Colors.deepPurpleAccent,
              fontSize: 20),
          iconTheme: IconThemeData(color: Colors.grey),
          toolbarTextStyle: TextStyle(color: Colors.deepPurpleAccent,
              fontSize: 20),),
        elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(
          elevation: 10,
          shape: BeveledRectangleBorder(),
        )),
      ),
      darkTheme: ThemeData(primaryColor: Colors.deepPurpleAccent,
        colorScheme: ColorScheme.dark(
          primary: Colors.purple,
          secondary: Colors.red,
        ),),
      home: demo(),
    );
  }
}

class demo extends StatefulWidget {
  const demo({Key? key}) : super(key: key);

  @override
  State<demo> createState() => _demoState();
}

class _demoState extends State<demo> {

  final heightController=TextEditingController();
  final weightController=TextEditingController();
  double? result1;
  var status;
  bool validateh=false, validatew=false;
  bool visible1=true;

  @override
  void dispose() {
    super.dispose();
    heightController.dispose();
    weightController.dispose();
  }

  void calculateBMI() {
    if (heightController.text!="" && weightController.text!="") {
      setState(() {
        double h=double.parse(heightController.text)/100;
        double w=double.parse(weightController.text);
        result1=w/(h*h);
        if (result1!<18.5) status="${S.of(context).status01}";
        else if (result1!>24) status="${S.of(context).status03}";
        else status="${S.of(context).status02}";
      });
    }
    else {
      setState(() {
        result1=null;
        status=null;
      });
      String a1=S.of(context).alarm1;
      String a2=S.of(context).alarm2;
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: Text(a1),
          content: Text(a2),
          actions: [
            TextButton(child: Text('OK'),
              onPressed: ()=>Navigator.of(context).pop(),),
          ],
        );
      });
    }
  }

  Color? getTextColor(var s1) {
    if (s1=="${S.of(context).status02}") return Colors.green;
    else if (s1=="${S.of(context).status01}") return Colors.amber;
    else if (s1=="${S.of(context).status03}") return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).title),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
      ),
      body: Container(
        //插入背景圖片，若覺得視覺過於混亂可將圖片抽走或不顯示
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/test01.jpg'),
              fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '${S.of(context).height1}',
                hintText: 'cm',
                errorText: validateh? '${S.of(context).error_text}': null,
                icon: Icon(Icons.trending_up),
              ),
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(height: 20,),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '${S.of(context).weight1}',
                hintText: 'Kg',
                errorText: validatew? '${S.of(context).error_text}': null,
                icon: Icon(Icons.trending_down),
              ),
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(height: 35,),
            ElevatedButton(child: Text('${S.of(context).button1}', style: TextStyle(color: Colors.white),),
              onPressed: () {
                setState(() {
                  heightController.text.isEmpty? validateh=true : validateh=false;
                });
                calculateBMI();
              },
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(fontSize: 22),
              ),
            ),
            SizedBox(height: 15,),
            Text(result1==null? "":"${S.of(context).result1}=${result1!.toStringAsFixed(2)}",
              style: TextStyle(color: Colors.blueAccent,
                  fontSize: 22,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 15,),
            RichText(text: TextSpan(
              style: TextStyle(color: Colors.blue,
                  fontSize: 22,
                  fontWeight: FontWeight.w500),
              children: [
                TextSpan(text: status==null? "":"${S.of(context).status00}"),
                TextSpan(text: status==null? "":"${status}", style: TextStyle(
                  //color: Colors.greenAccent, 固定顏色
                    color: getTextColor(status),
                    fontSize: 22,
                    fontWeight: FontWeight.w500
                )),
              ],
            ),),
            //Text(status==null? "":"您的狀態為：${status}",
            //     style: TextStyle(color: Colors.blue,
            //                      fontSize: 22,
            //                      fontWeight: FontWeight.w500),
            //),
          ],
        ),
      ),
    );
  }
}


