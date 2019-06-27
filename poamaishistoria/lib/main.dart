import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PoaMaisHistória',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        hintColor: Colors.white,
        unselectedWidgetColor: Colors.white,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// This is the stateless widget that the main application instantiates.
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<MyHomePage> {
  _InitPageState({Key key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
            children: <Widget>[
              Padding(padding: EdgeInsets.all(10),
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Image.asset('assets/POA+história.png'),
                      ),

                      Container(
                        padding: EdgeInsets.only(top: 20),
                        child: new Column(


                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child:Container(
                                  width: 170,
                                  child: FloatingActionButton.extended(
                                    label: Text('Abrir Mapa') ,
                                    heroTag: "btn3",
                                    onPressed: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => StatelessMap()),
                                      ); },

                                    backgroundColor: Colors.deepOrange,
                                    icon: const Icon(Icons.map, size:35.5),
                                  )) ,
                            ),

                            Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Container(
                                    width: 170,
                                    child:  FloatingActionButton.extended(
                                      label: Text('Sobre nós') ,
                                      heroTag: "btn4",
                                      onPressed: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => StatelessInfo()),
                                        );
                                      },
                                      materialTapTargetSize: MaterialTapTargetSize.padded,
                                      backgroundColor: Colors.deepOrange,
                                      icon: const Icon(Icons.info_outline, size:35.5),
                                    )
                                )
                            ),

                            Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Container(
                                    width: 170,
                                    child:  FloatingActionButton.extended(
                                      label: Text("Instagram", ),
                                      heroTag: "btn5",
                                      onPressed: (){
                                        _launchURL();
                                      },
                                      materialTapTargetSize: MaterialTapTargetSize.padded,
                                      backgroundColor: Colors.deepOrange,
                                      icon: new Image.asset('assets/instagram-icon.png',scale: 10),
                                    )
                                )
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]
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
    Markers(1,-30.057999, -51.175179, "FAMECOS", ['assets/famecos.jpg', 'assets/famecosAntiga.jpg'], "Avenida Ipiranga 6681 - Prédio 7 - Partenon", "Em 1965, surgia na PUCRS — Pontifícia Universidade Católica do Rio Grande do Sul, a Famecos — Faculdade dos Meios de Comunicação Social. A raiz dessa criação foi o Jornalismo, ativado em 1952, junto à Faculdade de Filosofia. Em 1964, o curso foi desmembrado da Filosofia, surgindo a Escola de Jornalismo. No ano seguinte, com a criação do curso universitário de Publicidade e Propaganda (o 1º do Brasil), entendeu-se que era possível criar uma faculdade voltada para a comunicação social. Nesse mesmo ano, em 1º de dezembro, a até então Escola de Jornalismo passou a se chamar Faculdade dos Meios de Comunicação Social. Em 1967, com o lançamento do curso de Relações Públicas, o segundo do Brasil, a faculdade dá um salto e o ensino de comunicação se torna polivalente. João Guilherme Barone, com 22 anos de Famecos, é o atual diretor. Ao se referir sobre essa época, Barone comenta que “naquele momento, esse pensamento da comunicação social reunindo essas três áreas, possibilitou uma definição de caminho da faculdade, considerando que esses eram estudos relativamente novos”. Ainda fazem parte da história da Famecos os cursos de Turismo, criado em 1971, Tecnologia em Produção Audiovisual e Hotelaria, de 2004. No decorrer desses 50 anos, surgiram diversos laboratórios, dentre os quais o de Jornalismo Gráfico, Foto, Cinema, Televisão, Publicidade e Propaganda, Relações Públicas, Eventos, Imagem Digital e outros. Além disso, foram instalados programas de Mestrado e Doutorado, Programa de Pós Graduação, Agências Experimentais e o Festival de Laboratórios em Comunicação — SET Universitário." ),
    Markers(2,-30.027717, -51.227780, "Mercado Público de Porto Alegre", ['assets/mercado público.jpg','assets/mercado5-np.jpg', 'assets/mercado1.jpg','assets/MercadoPublico2.jpg','assets/MercadoPublico3.jpg'], "      Centro Histórico, Porto Alegre - RS", "O Mercado Público foi construído em 1869 com o objetivo de abrigar os comerciantes que vinham trabalhar em Porto Alegre. O prédio chegou a sobreviver à grande enchente de Porto Alegre, em 1941 e à quatro grandes incêndios, tendo o último ocorrido em 2013. \n     Entretanto, existem significados maiores para o Mercado do que ser apenas um centro comercial. Ele é um dos pontos mais importante para as religiosidades de matriz africana que estão presentes na cidade até hoje. Desde sua construção ele é considerado um ponto com grande concentração de  energia.  Essa crença era sustentada por trabalhadores escravizados, que fizeram um assentamento no local, transformando-o em um lugar sagrado, onde seus ritos poderiam ser respeitados mesmo em épocas de intolerância religiosa.\n      As fontes históricas divergem quanto a esse assentamento do Bará (nome dado a energia que se acreditava estar naquele local) em questões como quem o fez e onde foi feito. Não há confirmação sobre sua formação, já que ela pode ter sido feita por trabalhadores negros, pelo Príncipe Custódio. O valor simbólico desse prédio, entretanto, continua sendo muito forte, o que transforma o Mercado em um ponto primordial das religiosidades africanas em todo estado do Rio Grande do Sul.\n \n      Se você se interessou e quer saber mais sobre o assunto, nossa recomendação é o documentário “A Tradição do Bará do Mercado”. Ele está disponível, em edição completa, no Youtube.")
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
  void _changeClickMarker(LatLng c){
    setState(() {
      clickMarker = false;
    });

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
            leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){Navigator.pop(context);}),
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
                onTap:_changeClickMarker,
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
                      FloatingActionButton.extended(
                        label: Text("Informações"),
                        heroTag: "btn2",
                        onPressed: (){ Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MarkerOpen(marker: pin)),
                        );},
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        backgroundColor: Colors.deepOrange,
                        icon: const Icon(Icons.info_outline, size: 36.0),
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
              Align(
                alignment: Alignment.topCenter,
                child: Text(marker.nome,textAlign: TextAlign.center,style: TextStyle( fontSize: 30, letterSpacing: 0.5, color: Colors.black87,) ),
              ),
              Padding(
                  padding: EdgeInsets.only(top:20,left: 5,right: 5, bottom: 20),
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