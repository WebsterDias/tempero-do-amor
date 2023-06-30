import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tempero_do_amor/views/AgendarCasamentoView.dart';

List<String> sessao = <String>[
  "acompanhamentos",
  "entradas",
  "guarnicoes",
  "pratos_principais"
];

Map<String, bool> db = {};
var cont = 0;

class CadastrarCardapioView extends StatefulWidget {
  const CadastrarCardapioView({Key? key}) : super(key: key);

  @override
  State<CadastrarCardapioView> createState() => _CadastrarCardapioViewState();
}

class Cardapios {
  List<String>? acompanhamentos;
  List<String>? entradas;
  List<String>? guarnicoes;
  List<String>? pratos;

  Cardapios({
    this.acompanhamentos,
    this.entradas,
    this.guarnicoes,
    this.pratos,
  });

  factory Cardapios.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Cardapios(
      acompanhamentos: data?['acompanhamentos'] is Iterable
          ? List.from(data?['acompanhamentos'])
          : null,
      entradas:
          data?['entradas'] is Iterable ? List.from(data?['entradas']) : null,
      guarnicoes: data?['guarnicoes'] is Iterable
          ? List.from(data?['guarnicoes'])
          : null,
      pratos: data?['pratos'] is Iterable ? List.from(data?['pratos']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (Cardapios != null) "acompanhamentos": acompanhamentos,
      "entradas": entradas,
      "guarnicoes": guarnicoes,
      "pratos_principais": pratos,
    };
  }
}

var cardapio = Cardapios(
  acompanhamentos: [""],
  entradas: [""],
  guarnicoes: [""],
  pratos: [""],
);

class _CadastrarCardapioViewState extends State<CadastrarCardapioView> {
  TextEditingController nomeCardapio = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastrar Cardápio"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Text("Nome do Cardápio"),
                  TextFormField(
                    controller: nomeCardapio,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      mapearDoBanco(cont);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ComposicaoCardapio(nomeCardapio.text);
                      }));
                    },
                    child: const Text("Continuar"),
                  ),
                ],
              ),
              Column(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/listar_cardapios");
                      },
                      child: const Text("Voltar")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ComposicaoCardapio extends StatefulWidget {
  final nomeCardapio;
  const ComposicaoCardapio(this.nomeCardapio, {Key? key}) : super(key: key);

  @override
  State<ComposicaoCardapio> createState() => _ComposicaoCardapio();
}

class _ComposicaoCardapio extends State<ComposicaoCardapio> {

  var contador = 0;
  var prato = "Acompanhamentos";
  var textoBotao = "Próximo";
  var textoPagina = "Selecione os Acompanhamentos";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nomeCardapio),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(prato),
                  const Text("(máx 5)"),
                ],
              ),
            ),
            //------------aqui-----
            Container(
              height: MediaQuery.of(context).size.height * 0.62,
              decoration: BoxDecoration(
                  border: BorderDirectional(
                      top: BorderSide(color: Colors.grey.shade400))),
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection(sessao[cont])
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      final snap = snapshot.data!.docs;
                      return SingleChildScrollView(
                        child: ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: snap.length,
                            itemBuilder: (context, index) {
                              return CheckboxListTile(
                                title: Text(db.keys.elementAt(index)),
                                value: db.values.elementAt(index),
                                onChanged: (value) {
                                  setState(() {
                                    if (contador < 5 &&
                                        db.values.elementAt(index) == false) {
                                      db[db.keys.elementAt(index)] = value!;
                                      contador++;
                                    } else if (db.values.elementAt(index) ==
                                        true) {
                                      db[db.keys.elementAt(index)] = value!;
                                      contador--;
                                    }
                                  });
                                },
                              );
                            }),
                      );
                    }
                    return const Text("nada encontrado...");
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                ElevatedButton(
                  onPressed: () {
                    limparVariaveis();
                    contador = 0;
                    textoBotao = "Próximo";
                    Navigator.pushNamed(context, "/listar_cardapios");
                  },
                  child: const Text("Voltar"),
                ),

                ElevatedButton(
                    onPressed: () async {

                      switch (cont) {
                        case 0:
                          salvarSelecao(cardapio.acompanhamentos);
                          prato = "Entradas";
                          break;

                        case 1:
                          salvarSelecao(cardapio.entradas);
                          prato = "Guarnições";
                          break;

                        case 2:
                          salvarSelecao(cardapio.guarnicoes);
                          prato = "Pratos Principais";
                          break;

                        default:
                          salvarSelecao(cardapio.pratos);
                          var bd = FirebaseFirestore.instance
                              .collection('cardapios')
                              .doc(widget.nomeCardapio);

                          await bd.set(cardapio.toFirestore());

                          break;
                      }

                      cont++;
                    
                      if (cont == 4) {
                        contador = 0;
                        textoBotao = "Próximo";
                        limparVariaveis();
                        Navigator.pushNamed(context, "/listar_cardapios");
                      }

                      mapearDoBanco(cont);

                      setState(() {
                        contador = 0;
                        cont == 3 ? textoBotao = "Finalizar" : null;
                      });

                    },
                    child: Text(textoBotao)),
              ],
            ),
            //--------------fim-------
          ],
        ),
      ),
    );
  }
}

Future mapearDoBanco(contador) async {
  final ref =
      FirebaseFirestore.instance.collection(sessao[contador]).withConverter(
            fromFirestore: Cardapios.fromFirestore,
            toFirestore: (Cardapios Cardapios, _) => Cardapios.toFirestore(),
          );

  final docSnap = await ref.get();

  db.clear();

  for (var i = 0; i < docSnap.size; i++) {
    var temporario = <String, bool>{docSnap.docs[i].id.toString(): false};
    db.addAll(temporario);
  }
}

void salvarSelecao(prato) {
  db.forEach((key, value) {
    value == true ? prato.add(key) : null;
  });
  prato!.remove("");
}

void limparVariaveis() {
  cont = 0;
  cardapio.acompanhamentos?.clear();
  cardapio.entradas?.clear();
  cardapio.guarnicoes?.clear();
  cardapio.pratos?.clear();
}
