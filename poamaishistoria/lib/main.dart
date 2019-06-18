import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatelessWidget(),
    );
  }
}

/// This is the stateless widget that the main application instantiates.
class MyStatelessWidget extends StatefulWidget {
  MyStatelessWidget({Key key}) : super(key: key);
  @override
  _Map createState() => _Map();
}

class _Map extends State<MyStatelessWidget>{
  Completer<GoogleMapController> _controller = Completer();

  static LatLng _center;

  final Set<Marker> _markers = {};
  bool loading = false;
  LatLng _lastMapPosition = _center;
  static Map<String, double> userLocation;
  MapType _currentMapType = MapType.normal;
  Position position;

  Markers pin;
  bool clickMarker = false;

  @override
  void initState() {
    // TODO: implement initState
    loading = true;
    getStatus();
    super.initState();
  }

  void getStatus()async {
    GeolocationStatus geolocationStatus = await Geolocator()
        .checkGeolocationPermissionStatus();
    try{
    position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.lowest);
    _center = await LatLng(position.latitude, position.longitude);
    }catch(e){
      print(e);
      setState(() {
        _center =  LatLng(-30.0277,-51.2287);
      });

    } finally{
      await AddMarker();
      print(_markers);
      loading = false;
    }
    print(_center);
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }
  static final List<Markers> pins = <Markers>[
    Markers(1,-30.057999, -51.175179, "FAMECOS",  'assets/famecos.jpg', "Avenida Ipiranga 6681 - Prédio 7 - Partenon" ),
    Markers(2,-30.103138, -51.235952, "Restaurante", 'assets/divino.jpg', "Av. Otto Niemeyer, 2364 - Tristeza")
  ];

  void AddMarker() {
    try{
      setState(() {
        for(int i=0; i<pins.length; i++){
          _markers.add(Marker(
            markerId: MarkerId(pins[i].nome),
            position: LatLng(pins[i].latitude,pins[i]._longitude),
            onTap: (){
              setState(() {
                clickMarker = true;
                pin = pins[i];
              });
            },
            infoWindow: InfoWindow(
                title: pins[i].nome,
                    snippet: pins[i]._end
            ),
            icon: BitmapDescriptor.defaultMarker,
          ));
        }
      });
    }catch(e){
      print(e);
    } finally{
      print(_markers);
    }

  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    if(loading){
      return MaterialApp(
          home: Scaffold(
          appBar: AppBar(
          title: Text('POA+HISTÓRIA'),
    backgroundColor: Colors.orange,
    ),
    body: Padding(padding: EdgeInsets.all(10),
    child: Align(
    alignment: Alignment.topRight,
    child: Column(
    children: <Widget>[
      Text("loading")
    ],
    ),
    ),
          ),
          ),
      );
    }else {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('POA+HISTÓRIA'),
            backgroundColor: Colors.orange,
          ),
          body: Stack(
            children: <Widget>[
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 15.0,
                ),
                mapType: _currentMapType,
                markers: _markers,
                onCameraMove: _onCameraMove,
                myLocationEnabled: true,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Column(
                    children: <Widget>[
                      FloatingActionButton(
                        heroTag: "btn1",
                        onPressed: _onMapTypeButtonPressed,
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        backgroundColor: Colors.orange,
                        child: const Icon(Icons.map, size: 36.0),
                      ),
                      SizedBox(height: 16.0),
                    (clickMarker)
                    ?
                      FloatingActionButton(
                        heroTag: "btn2",
                        onPressed: (){ Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MarkerOpen(marker: pin)),
                        );},
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        backgroundColor: Colors.orange,
                        child: const Icon(Icons.info_outline, size: 36.0),
                      )
                      :
                    Text("")
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
//  Future<void> _goToTheLake() async {
//    final GoogleMapController controller = await _controller.future;
//    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
//  }
}
class MarkerOpen extends StatefulWidget {
  MarkerOpen({Key key, this.marker}) : super(key: key);

  Markers marker;
  @override
  _MarkerOpenState createState() => _MarkerOpenState(marker: marker);
}

class _MarkerOpenState extends State<MarkerOpen> {
  _MarkerOpenState({Key key, this.marker});

  Markers marker;


  @override
  Widget build(BuildContext context) {
    print("Marker: " + marker.pathFoto);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){Navigator.pop(context);}),
        title: Text(marker.nome),

      ),
      body:SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 00),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: CarouselSlider(
                  height: 400.0,
                  items: [Image.asset(marker.pathFoto, height: 200, width: MediaQuery.of(context).size.width ,),Image.asset(marker.pathFoto, height: 200, width: MediaQuery.of(context).size.width ,),3,4,5].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                                color: Colors.amber
                            ),
                            child: Text('text $i', style: TextStyle(fontSize: 16.0),)
                        );
                      },
                    );
                  }).toList(),
                )
                //new Image.asset(marker.pathFoto, height: 200, width: MediaQuery.of(context).size.width ,),
              ),

            ],
          )),

    );

  }

}

class Markers {
  int _id;
  double _latitude;
  double _longitude;
  String _nome;
  String _pathFoto;
  String _end;

  Markers(this._id, this._latitude,this._longitude, this._nome, this._pathFoto, this._end);

  double get latitude => _latitude;
  double get longitude => _longitude;
  String get nome => _nome;
  String get pathFoto => _pathFoto;
  int get id => _id;
  String get end => _end;
}