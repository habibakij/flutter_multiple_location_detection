import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late GoogleMapController myController;
  final LatLng _center = const LatLng(23.7428604, 90.3892620);
  MapType _currentMapType= MapType.normal;
  final Set<Marker> _markers = {};
  late LatLng _currentMapPosition= _center;

  void _onMapCreated(GoogleMapController controller) {
    myController = controller;
  }
  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType= _currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  void _onCameraMove(CameraPosition position) {
    _currentMapPosition = position.target;
  }
  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(_currentMapPosition.latitude.toString()), /// _lastMapPosition.toString()
        position: _currentMapPosition,
        infoWindow: const InfoWindow(title: "User"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        onTap: (){
          setState(() {
            //showToast("Current User: ${_currentMapPosition.latitude.toString()}", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
            print("user_location: ${_currentMapPosition.latitude.toString()}");
          });
        }
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Multiple User Detection'),
          backgroundColor: Colors.green,
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              markers: _markers,
              mapType: _currentMapType,
              onCameraMove: _onCameraMove,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentMapPosition,
                zoom: 10.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Align(
                alignment: Alignment.topRight,
                child: FloatingActionButton(
                  onPressed: () => _onAddMarkerButtonPressed(),
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.my_location, size: 30.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*void showToast(String msg, {required int duration, required int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }*/

}
