import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String currentAddress="My Address";
  Position? currentposition ;

  determinePosition()async{
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled=await Geolocator.isLocationServiceEnabled();
  if(!serviceEnabled){
    Fluttertoast.showToast(msg: "Location service is Disabled");
  }
  permission=await Geolocator.checkPermission();
  if(permission==LocationPermission.denied){
    permission=await Geolocator.requestPermission();
    if(permission==LocationPermission.denied){
      Fluttertoast.showToast(msg: "You Denied the Permission");
    }
  }
  if(permission==LocationPermission.deniedForever){
    Fluttertoast.showToast(msg: "You Denied Permission Forever");
  }
  Position position=await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high
  );
  try{
    List<Placemark> placemarks=await placemarkFromCoordinates(position.latitude,  position.longitude);
    Placemark place=placemarks[0];
    setState(() {
      currentposition=position;
      currentAddress="${place.locality},${place.postalCode},${place.country}";
    });
  }
  catch(e){
    print(e);
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Geo Location")),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(currentAddress),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               currentposition!=null? Text("Latitude="+currentposition!.latitude.toString()):Container(),
                currentposition!=null? Text("Logitude="+currentposition!.longitude.toString()):Container(),
              ],
            ),

            ElevatedButton(onPressed: (){
              determinePosition();
            }, child: Text("Get Current locatation"))
          ],
        ),
      ),
    );

  }
}
