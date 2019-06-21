import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const String _title = 'Poamaishistoria';

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
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<MyStatelessWidget> {
  _InitPageState({Key key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(padding: EdgeInsets.all(10),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Image.asset('assets/POA+história.png'),
                ),

                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                    children: <Widget>[
                      Container(
                          child: FloatingActionButton(
                            heroTag: "btn3",
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => StatelessMap()),
                              ); },
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                            backgroundColor: Colors.deepOrange,
                            child: const Icon(Icons.map, size:35.5),
                          )),

                      Container(
                          child:  FloatingActionButton(
                            heroTag: "btn4",
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => StatelessInfo()),
                              );
                            },
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                            backgroundColor: Colors.deepOrange,
                            child: const Icon(Icons.info_outline, size:35.5),
                          )
                      ),
                      Container(
                          child:  FloatingActionButton(
                            heroTag: "btn5",
                            onPressed: (){
                              _launchURL();
                            },
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                            backgroundColor: Colors.deepOrange,
                            child: Image.asset('assets/instagram-icon.png',scale: 10,),
                          )
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }
  _launchURL() async{
    const url = 'https://www.instagram.com/poamaishistoria/';
    if(await canLaunch(url)){
      await launch(url);
    }else{
      throw 'Could not launch $url';
    }

  }

}
class StatelessInfo extends StatefulWidget {
  StatelessInfo({Key key}) : super(key: key);
  @override
  _InfoPageState createState() => _InfoPageState();
}
class _InfoPageState extends State<StatelessInfo> {
  _InfoPageState({Key key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(

        body: Padding(padding: EdgeInsets.all(10),
          child: Align(
            alignment: Alignment.center,
            child: ListView(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset('assets/POA+história.png', scale: 15,),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text("Um pouco mais sobre nós",textAlign: TextAlign.center,style: TextStyle( fontSize: 30, letterSpacing: 0.5, color: Colors.black87,) ),
                ),

                Padding(padding: EdgeInsets.only(top:20,left: 7,right: 7,bottom: 20),
                  child: Text("Nosso intuito é mostrar as histórias ocultas de lugares que você frequenta. A capital dos gaúchos com suas diversas peculiaridades, histórias interessantes e outras nem tão encantadoras de locais que hoje são esquecidos",
                    textAlign: TextAlign.justify, style: TextStyle( fontSize: 15, letterSpacing: 0.5, color: Colors.black54),),
                ),

                MaterialButton(
                  color: Colors.deepOrange,
                    child: Text("Voltar", style: TextStyle(color: Colors.white),),
                    onPressed: (){
            Navigator.pop(context);
            })



              ],
            ),
          ),
        ),
      ),
    );

  }
  _launchURL() async{
    const url = 'https://www.instagram.com/poamaishistoria/';
    if(await canLaunch(url)){
      await launch(url);
    }else{
      throw 'Could not launch $url';
    }

  }

}

class StatelessMap extends StatefulWidget {
  StatelessMap({Key key}) : super(key: key);
  @override
  _Map createState() => _Map();
}

class _Map extends State<StatelessMap>{
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
    Markers(1,-30.057999, -51.175179, "FAMECOS", ['assets/famecos.jpg'], "Avenida Ipiranga 6681 - Prédio 7 - Partenon", "Faculda de Cominucação da PUCRS" ),
    Markers(2,-30.103138, -51.235952, "Restaurante", ['assets/divino.jpg','assets/famecos.jpg'], "Av. Otto Niemeyer, 2364 - Tristeza", "Performing hot restart..Syncing files to device Moto G 5S...I/Choreographer(25728): Skipped 46 frames!  The application may be doing too much work on its main thread.I/Adreno  (25728): DequeueBuffer: dequeueBuffer failedI/Adreno  (25728): DequeueBuffer: dequeueBuffer failed I/Adreno  (25728): DequeueBuffer: dequeueBuffer failed W/OpenGLRenderer(25728): swapBuffers encountered EGL error 12301 on 0x8b17b898, halting rendering... Restarted application in 4.942ms. I/flutter (25728): {Marker{markerId: MarkerId{value: FAMECOS}, alpha: 1.0, anchor: Offset(0.5, 1.0), consumeTapEvents: false, draggable: false, flat: false, icon: Instance of 'BitmapDescriptor', infoWindow: InfoWindow{title: FAMECOS, snippet: Avenida Ipiranga 6681 - Prédio 7 - Partenon, anchor: Offset(0.5, 0.0)}, position: LatLng(-30.057999, -51.175179000000014), rotation: 0.0, visible: true, zIndex: 0.0, onTap: Closure: () => Null}, Marker{markerId: MarkerId{value: Restaurante}, alpha: 1.0, anchor: Offset(0.5, 1.0), consumeTapEvents: false, draggable: false, flat: false, icon: Instance of 'BitmapDescriptor', infoWindow: InfoWindow{title: Restaurante, snippet: Av. Otto Niemeyer, 2364 - Tristeza, anchor: Offset(0.5, 0.0)}, position: LatLng(-30.103138, -51.235952), rotation: 0.0, visible: true, zIndex: 0.0, onTap: Closure: () => Null}} I/flutter (25728): {Marker{markerId: MarkerId{value: FAMECOS}, alpha: 1.0, anchor: Offset(0.5, 1.0), consumeTapEvents: false, draggable: false, flat: false, icon: Instance of 'BitmapDescriptor', infoWindow: InfoWindow{title: FAMECOS, snippet: Avenida Ipiranga 6681 - Prédio 7 - Partenon, anchor: Offset(0.5, 0.0)}, position: LatLng(-30.057999, -51.175179000000014), rotation: 0.0, visible: true, zIndex: 0.0, onTap: Closure: () => Null}, Marker{markerId: MarkerId{value: Restaurante}, alpha: 1.0, anchor: Offset(0.5, 1.0), consumeTapEvents: false, draggable: false, flat: false, icon: Instance of 'BitmapDescriptor', infoWindow: InfoWindow{title: Restaurante, snippet: Av. Otto Niemeyer, 2364 - Tristeza, anchor: Offset(0.5, 0.0)}, position: LatLng(-30.103138, -51.235952), rotation: 0.0, visible: true, zIndex: 0.0, onTap: Closure: () => Null}} I/flutter (25728): LatLng(-29.9651137, -50.11878530000001) I/Google Maps Android API(25728): Google Play services package version: 14366018 I/zygote  (25728): Compiler allocated 4MB to compile void android.widget.TextView.<init>(android.content.Context, android.util.AttributeSet, int, int) I/zygote  (25728): Do full code cache collection, code=1014KB, data=718KB I/zygote  (25728): After code cache collection, code=1011KB, data=654KB I/flutter (25728): Marker: [assets/divino.jpg, assets/famecos.jpg]")
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
                snippet: pins[i]._end,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MarkerOpen(marker: pin))
                  );
                }
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
            backgroundColor: Colors.deepOrange,
          ),
          body: Padding(padding: EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  Image.asset('assets/POA+história.png'),
                  Padding(padding: EdgeInsetsDirectional.only(top: 7),
                    child:Image.asset('assets/loading.gif', width: 40, height: 40,) ,
                  ),
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
            backgroundColor: Colors.deepOrange,
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
                        backgroundColor: Colors.deepOrange,
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
                        backgroundColor: Colors.deepOrange,
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
    print("Marker: " + marker.pathsFoto.toString());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){Navigator.pop(context);}),
        title: Text(marker.nome),

      ),
      //https://github.com/serenader2014/flutter_carousel_slider/blob/master/example/lib/main.dart
      body:SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 00),
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: CarouselSlider(
                    height: 300.0,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    pauseAutoPlayOnTouch: Duration(seconds: 10),
                    enlargeCenterPage: true,
                    items: marker.pathsFoto.map((url) {
                      return Builder(

                        builder: (BuildContext context) {
                          return Container(

                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),

                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                child:  Image.asset(url),
                              )
                          );
                        },
                      );
                    }).toList(),
                  )
                //new Image.asset(marker.pathFoto, height: 200, width: MediaQuery.of(context).size.width ,),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 5,right: 5, bottom: 20),
                  child: Text(marker.descricao, textAlign: TextAlign.justify, style: TextStyle( fontSize: 15, letterSpacing: 0.5, color: Colors.black54),)
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
  List<String> _pathsFoto;
  String _end;
  String _descricao;

  Markers(this._id, this._latitude,this._longitude, this._nome, this._pathsFoto, this._end, this._descricao);

  double get latitude => _latitude;
  double get longitude => _longitude;
  String get nome => _nome;
  List<String> get pathsFoto => _pathsFoto;
  int get id => _id;
  String get end => _end;
  String get descricao => _descricao;

}