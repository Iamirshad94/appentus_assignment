import 'dart:async';
import 'package:assignment/views/grid_view.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../model/user_model.dart';
import 'login_page.dart';

class MainPage extends StatefulWidget {

  // required parameter
  UserModel? userData;
  MainPage(this.userData, {Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  // google Controller
  Completer<GoogleMapController>? _controller = Completer();

  // list and variables
  LatLng _center = LatLng(0.00, 0.00);
  List<Marker> _markers = [];
  double long = 0.00;
  String? username;
  CameraPosition? cameraPosition;
  Position? currentPos;
  bool isLoading = true;


  // timer function for loadingIndicator
  void startTimer() {
    Timer.periodic(const Duration(seconds: 3), (t) {
      setState(() {
        isLoading = false; //set loading to false
      });
      t.cancel(); //stops the timer
    });
  }


  // onmapCreate function
  void _onMapCreated(GoogleMapController controller) {
    _controller?.complete(controller);
  }


  // function for requesting permission and fetch location
  Future<Position?> getCurrentLoc() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("error+ $error");
    });
    return await Geolocator.getCurrentPosition().then((value) async {
      _center = LatLng(value.latitude, value.longitude);
      _markers.add(Marker(
        markerId: MarkerId('1'),
        position: LatLng(value.latitude, value.longitude),
        infoWindow: InfoWindow(title: "Current Location"),
      ));
      CameraPosition cameraPosition = CameraPosition(
        zoom: 12,
        target: _center,
      );

      final GoogleMapController controller = await _controller!.future;

      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition!));
      setState(() {});
    });
  }

  // get current loc in variable
  getUserLocation() async {
    currentPos = await getCurrentLoc();
    setState(() {});
    print('center ');
  }

  @override
  void initState() {
    startTimer();
    super.initState();
    username = widget.userData!.username.toString();
    setState(() {
      getUserLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Mediaquery variable to get device screen size
    Size screenSize = MediaQuery.of(context).size;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => LoginPage()));
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          title: Text("Hello ${username}"),
          backgroundColor: Colors.green[700],
        ),
        body: isLoading
            ? Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        )
            : GoogleMap(
          markers: Set<Marker>.of(_markers),
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            zoom: 20,
            target: _center,
          ),
        ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: FloatingActionButton(
                      onPressed: () => {},
                      child: Icon(Icons.location_searching),
                      heroTag: "fab1",
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.loose,
                    child: Container(
                      child: FloatingActionButton.extended(
                        backgroundColor: Colors.white,
                        label: Text("Next Screen",style: TextStyle(color: Colors.blue),),
                        onPressed: () => {
                        Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => GridViewApi()),
                        (Route<dynamic> route) => false),
                        },
                        heroTag: "fab2",
                      ),
                    ),
                  ),
                ]
            ),
          )
      ),
    );
  }
}
