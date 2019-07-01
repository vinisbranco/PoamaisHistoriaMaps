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
      debugShowCheckedModeBanner: false,
      title: 'PoaMaisHistória',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        hintColor: Colors.white,
        unselectedWidgetColor: Colors.white,

      ),
      home: MyHomePage(),
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
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child:ListView(
                children: <Widget>[
                  Padding(padding: EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Image.asset('assets/appIcon.png'),
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
        )
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
        debugShowCheckedModeBanner: false,
        home: Scaffold(

          body: SafeArea(
            child: Padding(padding: EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.center,
                child: ListView(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topCenter,
                      child: Image.asset('assets/appIcon.png', scale: 15,),
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
        )
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
    Markers(2,-30.027717, -51.227780, "Mercado Público de Porto Alegre", ['assets/mercado público.jpg','assets/mercado5-np.jpg', 'assets/mercado1.jpg','assets/MercadoPublico2.jpg','assets/MercadoPublico3.jpg'], "      Centro Histórico, Porto Alegre - RS", "O Mercado Público foi construído em 1869 com o objetivo de abrigar os comerciantes que vinham trabalhar em Porto Alegre. O prédio chegou a sobreviver à grande enchente de Porto Alegre, em 1941 e à quatro grandes incêndios, tendo o último ocorrido em 2013. \n     Entretanto, existem significados maiores para o Mercado do que ser apenas um centro comercial. Ele é um dos pontos mais importante para as religiosidades de matriz africana que estão presentes na cidade até hoje. Desde sua construção ele é considerado um ponto com grande concentração de  energia.  Essa crença era sustentada por trabalhadores escravizados, que fizeram um assentamento no local, transformando-o em um lugar sagrado, onde seus ritos poderiam ser respeitados mesmo em épocas de intolerância religiosa.\n      As fontes históricas divergem quanto a esse assentamento do Bará (nome dado a energia que se acreditava estar naquele local) em questões como quem o fez e onde foi feito. Não há confirmação sobre sua formação, já que ela pode ter sido feita por trabalhadores negros, pelo Príncipe Custódio. O valor simbólico desse prédio, entretanto, continua sendo muito forte, o que transforma o Mercado em um ponto primordial das religiosidades africanas em todo estado do Rio Grande do Sul.\n \n      Se você se interessou e quer saber mais sobre o assunto, nossa recomendação é o documentário “A Tradição do Bará do Mercado”. Ele está disponível, em edição completa, no Youtube."),
    Markers(4,-30.027160, -51.231004, "Av. Mauá - Muro da Mauá", ['assets/mauá sem muro.jpg','assets/portaon cais da mauá 1922.jpg', 'assets/pos.jpg','assets/maua.jpg','assets/enchente.jpg','assets/cais12.jpg'], " Centro Histórico, Porto Alegre - RS", "Em 1941, Porto Alegre passou pela pior enchente da sua história. As águas do guaíba subiram mais de 4 metros. As águas chegaram até o mercado público e o único meio de se locomover era com canoas. \n   Finalizado em 1974 o Muro da Mauá conta com 3 metros de altura e 3 metros abaixo do solo e 2647 metros de comprimento, representando uma parte do complexo de diques para impedir outras enchentes no centro de Porto Alegre. \n   Hoje, considerado um ponto turístico, o muro é repleto de grafites por toda a sua extensão."),
    Markers(5,-30.035058, -51.237809, "Rua Fernando Machado", ['assets/castelo.jpg','assets/Castelinho.jpg'], "Castelinho do Alto da Bronze", "Localizado na esquina da Fernando Machado com a Vasco da Gama, uma construção no mínimo diferente pode ser encontrada:  castelo em estilo medieval. \n  Construído no final dos anos 40, pelo político Carlos Eurico Gomes para viver com a amante, desquitada e mãe de um filho. Quando sua traição foi descoberta, ele se separou da esposa e se mudou para o castelo. Existem boatos de  que ele era extremamente ciumento e não deixava a amante sair do terceiro andar e nem mesmo se aproximar das janelas… A jovem  desapareceu depois de algum tempo, supostamente teria fugido por causa dos abusos, alguns até dizem que faleceu no local. \n  O Castelo tem esse nome porque fica na região chamada de Alto da Bronze, nome dado a uma figura famosa que viveu na região. Atualmente o Castelinho abriga um espaço cultural."),
    Markers(7,-30.035138, -51.230561, "Rua Fernando Machado 707", ['assets/arvoredo.jpg','assets/Rua do Arvoredo.jpg', 'assets/arvoredo-.jpg'], "Rua do Arvoredo", "Em 1864, os cidadãos de Porto Alegre foram surpreendidos com um caso violento e macabro. O açougueiro João Ramos e sua esposa Catarina Palse são acusados de assassinar de nove pessoas. Os dois matavam para se apossar dos pertences das vítimas, com a exceção de um caixeiro que foi morto por ter testemunhado um dos atos. \n   Os corpos foram encontrado no porão da casa dos assassinos, esquartejados. E assim um dos maiores mitos de porto alegre foi criado. As linguiças vendidas por Ramos eram conhecidas por seu sabor… diferenciado… Isso logo começou a criar boatos inquietantes de que os embutidos eram feitos com partes dos corpos de suas vítimas. Isso, no entanto, nunca foi provado... A dúvida sobre o Caso do Arvoredo existe até hoje, e vem sendo usado como inspiração para vários contos, livros e até mesmo musicais sobre esse. \n   Os crimes aconteceram na então chamada rua do Arvoredo, que hoje é conhecida como Fernando Machado, número 707. Os arquivos desse caso podem ser acessados no Arquivo Público do Rio Grande do Sul, localizado na Rua Riachuelo 1031."),
    Markers(8,-30.032809, -51.239032, "Praça Brigadeiro Sampaio", ['assets/casaCorrecao.jpg','assets/CasadeCorrecao.jpg', 'assets/correcao.jpg','assets/Correção.jpg','assets/Correção1.jpg','assets/orla.jpg'], "Casa de Correção de Porto Alegre", "Nacionalmente conhecida como um dos maiores cartões postais de Porto Alegre, a Usina do Gasômetro e toda sua orla oferecem uma opção de lazer para a cidade. Inaugurada em 1928 com o objetivo de gerar energia a partir de carvão mineral, a construção hoje em dia abriga galerias de arte, uma sala de cinema e diversas outras atividades culturais. Antes da construção da Usina, esse canto do centro de Porto Alegre tinha outra referência muito forte, sendo conhecido por boa parte da população como “Ponta da Cadeia”. \n  A Casa de Correção de Porto Alegre foi idealizada em 1835, em função da deterioração da antiga cadeia da cidade, que já se tornara pequena demais para uma população que crescia muito rapidamente. Sua construção foi adiada em função dos conflitos da Guerra dos Farrapos, sendo inaugurada somente em 1855 A Casa de Correção trazia uma proposta diferente, pensada com salas de aula para instrução dos apenados com oficinas. O prédio não existe mais pela dinamitação feita mais de cem anos depois, em 1962. Seus internos foram transferidos para o Presídio Central da cidade. \n  Uma instituição que se propunha a trazer uma visão mais humanista para o sistema prisional, com o avançar do século XX acabou por ficar negligenciado e suas condições começaram a piorar, aumentando a fama do lugar de ser o mais temido de Porto Alegre."),
    Markers(9,-30.032443, -51.230163, "Monumento do Julio de Castilhos", ['assets/monumento.jpg','assets/monumento2.jpg', 'assets/monumento3.jpg','assets/palaciopiratini.jpg'], "Simbologias Republicanas", "Localizada em uma posição muito privilegiada do centro da cidade, em frente aos prédios administrativos mais importantes do estado do Rio Grande do Sul, localiza-se a Praça da Matriz. Mesmo com tantos prédios vistosos e atraentes que preenchem a Rua Duque de Caxias e seus arredores, um ponto dessa praça se destaca dos demais: o Monumento Júlio de Castilhos. \n  Júlio de Castilhos foi um jornalista e político pertencente ao Partido Republicano Riograndense. Foi um dos principais idealizadores da Constituição e o primeiro presidente da província eleito por voto direto em 1891. Idealizado após a morte do homenageado em questão mas inaugurado somente 10 anos depois, em 1913, o monumento é uma representação física das ideias da política positivista do político: Liberdade, paz e fraternidade. \n  Na construção é possível ver diversos símbolos utilizados e celebrados pelo governo. A figura do Tiradentes ganha destaque, representando as batalhas travadas pela ideia republicana no Brasil, bem como a figura do entregador de jornais, mostrando com o pensamento era divulgado pelo próprio governador. Na frente de Júlio, vemos um dos símbolos mais estranhos do monumento, o dragão, símbolo da família real brasileira, que havia sido substituído pela república, simbolizada pela mulher no topo da construção. \n  Para mais informações sobre Júlio de Castilhos e seu monumento, visite o Museu Júlio de Castilhos, na Rua Duque de Caxias, 1205. "),
    Markers(10,-30.033517, -51.230744, "Palácio Piratini", ['assets/Palácio_Piratini_07.jpg','assets/paratiniAntigo.jpg', 'assets/palaciopiratini.jpg','assets/palacio2.jpg'], "História da Campanha da Legalidade", "O Palácio do Piratini é a terceira sede do poder executivo do Rio Grande do Sul. sendo antecedido pelo Palácio de Barro, que era no mesmo local do atual Piratini, e pelo conhecido “Forte Apache”, o Palácio do Ministério Público do estado. O atual prédio foi solicitado por Júlio de Castilhos em 1896, mas, em função do ritmo das obras, o então Presidente do Rio Grande do Sul não chegou a ver a sua ocupação oficial, em 1921. \n  Palácio carrega em si muitas histórias que nos explicam sobre a história do estado do Rio Grande do Sul. Uma delas está contida no próprio nome da edificação.  A cidade de Piratini foi a primeira de quatro capitais da República do Rio Grande do Sul, período em que o estado se separou do Império do Brasil em função da Guerra Farroupilha (1835 – 1845). \n  Outro episódio histórica importante neste local foi a Campanha da Legalidade, promovida pelo então governador Leonel Brizola. Essa campanha ocorreu em função da instabilidade que assolou o país após o então presidente Jânio Quadros anunciar a sua renúncia do cargo enquanto o vice, João Goulart, estava em viagem diplomática. Ao saber da intenção dos militares de vetarem a posse de João Goulart, Leonel Brizola começou a organizar um movimento de resistência em defesa da legalidade; da posse de “Jango”. Dois dos episódios mais memoráveis aconteceram quando os equipamentos da Rádio Guaíba foram transferidos para o porão do Palácio Piratini onde os discursos de Brizola passaram a mobilizar não só a população gaúcha, mas também nacional, e quando o Palácio foi ameaçado de ser bombardeado pela base aérea de Canoas, operação que, no final das contas, foi abortada pelos próprios militares legalistas. "),
    Markers(11,-30.033992, -51.235390, "Duque de Caxias com General Canabarro", ['assets/Rua_Duque_de_Caxias_final_s_c._XIX.jpg','assets/duque.jpg', 'assets/duque2.jpg','assets/farrapos.jpg','assets/duqueNovo.png'], "Esquina Farroupilha", "  A Guerra dos Farrapos foi um confronto que marcou a história política do Rio Grande do Sul e do Império Brasileiro. Esse conflito ocorreu quando o Brasil era governado pela Regência do padre Feijó, e se estendeu até o reinado de Dom Pedro II, onde foi finalizado de maneira diplomática. Foi a guerra mais duradoura do período, iniciada em 1835 e finalizada em 1845. \n  O conflito teve seu início em função da insatisfação de estancieiros do interior do estado com as políticas tributárias do Império em relação ao charque, encarecendo o produto e dificultando a sua venda para o resto do país, onde era utilizado comumente para alimentar trabalhadores escravizados. Com o passar do tempo, entretanto, o confronto desenvolveu-se para uma guerra entre visões políticas, com o estado do Rio Grande do Sul, em 1836, conseguindo uma separação do Império Brasileiro, formando a República do Piratini, reconhecida somente pelo Uruguai. \n  Essa história está presente nesse cruzamento pois essas ruas carregam os nomes dos dois maiores responsáveis por trazerem essa guerra ao fim. O Tratado do Poncho Verde foi assinado, pelo lado do Império Brasileiro, pelo Barão de Caxias,  que estava alcançando notoriedade mas que ainda teria mais sucesso diplomático e militar na futura Guerra do Paraguai e, do lado farroupilha, pelo General David Canabarro. \n\n  Para mais informações sobre a guerra dos farrapos, visite o Museu Júlio de Castilhos, na Rua Duque de Caxias, 1205."),
    Markers(16,-30.031975, -51.235696, "Igreja Nossa Senhora das Dores", ['assets/igrejaDores.jpg','assets/igreja.jpg', 'assets/Igreja_.jpg','assets/igrejadores1.jpg','assets/igrejadores23.jpg'], "R. dos Andradas, 587 - Centro Histórico", "A Igreja da Nossa Senhora das Dores é a mais antiga de Porto Alegre. Ela está localizada na rua dos Andradas 587. Com sua construção iniciada em 1807,Porém, ela só foi ficar pronta em 1904 o motivo para  tal atraso tem uma lenda em seu âmago. \n   Um escravo que trabalhava na construção foi acusado de um crime, ele havia sido acusado de roubar a tiara de Nossa Senhora e foi levado a forca. No dia da sua execução ele disse que se tivesse culpa, seu senhor, havia de terminar a obra da igreja das Dores, mas se fosse inocente(o que ele de fato era) nunca haveria, pois elas não terminariam, como castigo do céu à crueldade porque iam fazê-lo passar. Segundo Augusto Porto Alegre(Historiador), o senhor deste escravo era Domingos José. Devidos aos vários incidentes e prolongadas interrupções da obra Domingos faleceu antes do final da construção da igreja \n   Uma das maiores curiosidades sobre essa Igreja é que ela possui traços nos estilos barroco e neoclássico. Dado o tempo que levou  para a finalização, os planos originais não existiam mais ou foram deliberadamente abandonados. Então a Ordem Terceira, irmandade que tomava conta da obra, arrecadou fundos para terminar a igreja, e o arquiteto Julio Weise se voluntariou a fazer o restante do projeto, sem custos, conseguindo inaugurar a primeira torre em 1900 e segunda em 1901 para finalmente terminar  as obras em 1904."),
    Markers(17,-30.039169, -51.227255, "Av. João Alfredo", ['assets/joaoalfredo2.jpg','assets/josealfredo.jpg', 'assets/ruamargem.jpg'], "Rua da Margem/Ponte de Pedra", "A cidade de Porto Alegre está acostumada com mudanças em seu visual, principalmente na região central. O bairro da Cidade Baixa, desde as suas primeiras delimitações no século XVIII, já passou por diversas modificações, desde seu visual até de suas populações. Uma das ruas que evoca fortemente trajetória histórica da Cidade Baixa é a João Alfredo. \n   Originalmente, a denominação “Cidade Baixa” servia para toda a região localizada ao sul da colina da atual Rua Duque de Caxias, em função da posição geograficamente inferior do atual bairro em relação ao Centro Histórico.  A denominação mudou durante o século XIX, passando para “Arraial da Baronesa”, fazendo referência tanto à chácara da Baronesa do Gravataí, bem como uma região de “Emboscadas”, por ser uma região ainda semi-rural com um alto índice de ocupação de trabalhadores escravizados que haviam conseguido escapar do centro da cidade, bem como ladrões que atacavam viajantes. \n   Avenida João Alfredo conta um pouco dessa história em dois tempos. O nome atual é uma homenagem ao abolicionista João Alfredo Correia de Oliveira, que teve participação na elaboração da Lei Áurea(1888), e o seu nome mais antigo, Rua da Margem, conta um pouco da história do Riachinho, cujo percurso cortava a cidade baixa e desembocava na Ponte de Pedra. O riachinho começou a ser canalizado na Avenida Ipiranga, onde leva o nome de Arroio Dilúvio, na década de 1940. \n \n   Para mais informações sobre a Cidade Baixa e suas mudanças, visite o Museu Joaquim Felizardo, na Rua João Alfredo, 582."),
    Markers(18,-30.038995, -51.224043, "José do Patrocínio", ['assets/republica.jpg','assets/republica 2.PNG', 'assets/republica2.jpg','assets/ruadarepublica.jpg'], "Rua República", " A decisão do nome de uma cidade ou das ruas e bairros da mesma não é uma escolha feita em vão. Nomes de políticos, médicos, feriados, santos e grandes desbravadores europeus podem ser vistos em todo o Brasil em todos os níveis administrativos, em alguns locais sendo só uma pequena rua enquanto, em outros estados, tendo o seu próprio município. \n  O nome “República”, entretanto, representa uma ideia que é defendida pelo país, o regime político que representa o país desde o final do Império, em 15 de novembro de 1889. Durante o período monárquico, uma das principais vias da atual Cidade Baixa levava o nome de “Rua do Imperador”, desde quando fora construída em 1845. Para acompanhar o Imperador existia uma rua paralela, de igual tamanho, chamada Rua da Imperatriz, atual Avenida Venâncio Aires. \n  Outro ponto de destaque é que a Rua da República cruza com a Rua José do Patrocínio, nome de um aclamado ativista político brasileiro, participante do movimento negro, bem como do polêmico grupo Guarda Negra e como voz forte nos movimentos republicanos no final do século XIX."),
    Markers(19,-30.045491, -51.219386, "Ginásio Tesourinha", ['assets/ilhota.jpg','assets/ilhota6.jpg', 'assets/mapailhota.jpg'], "Ilhota", "A geografia de uma cidade é, por vezes, um agente que guia os caminhos históricos, econômicos e sociais do local, e, por outras, um obstáculo a ser ultrapassado pela modernização e pela demanda de uma população em crescimento. Vocês sabiam que existia uma ilha dentro de Porto Alegre? \n  A Ilhota era uma região em torno da região da atual Avenida Érico Veríssimo, que hoje em dia pertence ao bairro Azenha. Esse nome começou a ser utilizado a partir de 1905 quando o então intendente José Montaury autorizou uma intervenção no fluxo do Riachinho, que cortava a Cidade Baixa, criando uma pequena ilha no bairro. Essa Ilhota sofria com constantes inundações e transformou-se em uma área ocupada pela população mais pobre da cidade. \n  A região da Ilhota começou a modificar-se na década de 1940, com a construção do Arroio Dilúvio na Avenida Ipiranga. A Cidade Baixa então passou por um processo de gentrificação nos anos 70, com a expulsão da população que ali morava para o desenvolvimento de obras na região centro-sul da cidade. Essa região foi de extrema importância cultural para Porto Alegre, sendo casa de figuras conhecidas a nível nacional como Lupicínio Rodrigues e o jogador Tesourinha."),
    Markers(20,-30.027717, -51.227780, "Rua Lopo Gonçalves, 498", ['assets/custodio.jpg','assets/principe.jpg', 'assets/principe_cust.jpg','assets/Principe-custodio.jpg'], "Príncipe Custódio", "A Cidade Baixa se transformou muito desde sua primeira delimitação, no século XVIII. De uma região própria sem marcações muito claras, tendo como referência apenas o fato de ser a parte mais baixa atrás da Rua Duque de Caxias e, muitas vezes, até sendo resumida pelo conjunto de posses da Baronesa do Gravataí, várias pessoas transitaram por essas terras, inclusive, no início do século XX, até mesmo um príncipe e sua corte. \n  O Príncipe de Ajudá teria chegado ao Brasil pouco após o final da escravidão no país. Ele veio para cá por consequência de um ataque Inglês à África Ocidental, anexando diversos terrenos ao seu império. Era de interesse inglês exilar o Príncipe, o que aconteceu após uma negociação que o expulsou do continente africano, onde já havia adotado o nome de Joaquim Custódio de Almeida. \n  Antes de vir para Porto Alegre, ele havia morado em lugares como: Bahia, Rio de Janeiro. Se tratando do Rio Grande do Sul: também em Rio Grande e Bagé. Aqui no nosso Estado, ele já ganhava fama por ter fundado centros de religiosidade africana e pela suas curas de diversos problemas de saúde a partir do uso de ervas. Em Porto Alegre, sua casa na Lopo Gonçalves era ponto de visita, sendo requisitado por diversos políticos do  período que buscavam curas e aconselhamentos. Um de seus principais pacientes foi o ex-presidente do Rio Grande do Sul, Júlio de Castilhos. \n\n  Para mais informações sobre o Príncipe Custódio, visite o Museu de Porto Alegre Joaquim Felizardo, na rua João Alfredo, 582."),
    Markers(21,-30.045228, -51.225078, "Areal da Baronesa", ['assets/areal.jpg','assets/areal2.jpg', 'assets/areal3.jpg','assets/quilombo.jpg'], "Quilombos em POA", "O processo de mudança é normal para todas as cidades do mundo. Com o crescimento populacional da cidade de Porto Alegre após a Lei Aurea (1888), as regiões que ficavam nas proximidades do centro histórico, área fortemente urbanizada de Porto Alegre, começaram a ser afetadas. Mas essas regiões já possuíam tradições fortíssimas antes das suas primeiras remodelagens. \n  Boa parte da atual Cidade Baixa pertencia ao Barão de Gravataí, um nobre estancieiro português que viveu boa parte de sua vida em Porto Alegre com sua esposa, Maria Emília de Meneses. Pouco após o final da Guerra dos Farrapos, onde o Barão havia caído as graças do Império Brasileiro, falece e deixa as terras para sua esposa. Em função disso a Cidade Baixa ainda é conhecida por muitos como o Areal da Baronesa. \n  A Baronesa morou em uma mansão que se localizava onde hoje é a Fundação Pão dos Pobres mas, o que mais se destacava do bairro naquela época era a sua característica semi-rural, que possibilitava a região de ser povoada por vários ex-trabalhadores escravizados, que conseguiam fugir do centro da cidade e tinham, em espaços como os atuais bairros Cidade Baixa, Farroupilha e Moinhos de Vento, espaço para perpetuarem seus costumes e cultos religiosos. \n \n Para mais informações sobre o Areal da Baronesa, visite o Museu de Porto Alegre Joaquim Felizardo, na João Alfredo, 582. "),
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
        debugShowCheckedModeBanner: false,
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
                  Image.asset('assets/appIcon.png'),
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
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            appBar: AppBar(
              leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){Navigator.pop(context);}),
              title: Text('POA+HISTÓRIA'),
              backgroundColor: Colors.deepOrange,
            ),
            body:SafeArea(
              child: Stack(
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
          )
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