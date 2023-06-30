import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tempero_do_amor/views/ListarPratosView.dart';

Map<String, dynamic> dados = {};

List acompanhamentos = [];
List entradas = [];
List guarnicoes = [];
List pratosPrincipais = [];

var dropdownValueGuarnicao;
var dropdownValueAcompanhamento;
var dropdownValueEntrada;
var dropdownValuePrato;

int cont = 0;

var idCardapio;

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
      if (Cardapios != null) "acompanhamantos": acompanhamentos,
      "entradas": entradas,
      "guarnicoes": guarnicoes,
      "pratos": pratos,
    };
  }
}

var cardapio = Cardapios(
  acompanhamentos: [""],
  entradas: [""],
  guarnicoes: [""],
  pratos: [""],
);

class ListarCardapiosView extends StatefulWidget {
  const ListarCardapiosView({super.key});

  @override
  State<ListarCardapiosView> createState() => _ListarCardapiosViewState();
}

class _ListarCardapiosViewState extends State<ListarCardapiosView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gerenciar Cardápios"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: ListView(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("cardapios")
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        final snap = snapshot.data!.docs;
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            primary: false,
                            itemCount: snap.length,
                            itemBuilder: (context, index) {
                              return SingleChildScrollView(
                                // width: double.infinity,
                                // margin: const EdgeInsets.only(bottom: 12),
                                child: Stack(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              snap[index].id,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color(0xFF3DBBE7),
                                                    shape: CircleBorder()),
                                                onPressed: () async {
                                                  var docRef =
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              "cardapios")
                                                          .doc(snap[index].id);

                                                  await docRef.get().then(
                                                    (DocumentSnapshot doc) {
                                                      dados = doc.data() as Map<
                                                          String, dynamic>;
                                                    },
                                                    onError: (e) => print(
                                                        "Error getting document: $e"),
                                                  );

                                                  var tabela = [
                                                    "acompanhamentos",
                                                    "guarnicoes",
                                                    "entradas",
                                                    "pratos_principais"
                                                  ];

                                                  cardapio.acompanhamentos!
                                                      .clear();
                                                  cardapio.entradas!.clear();
                                                  cardapio.guarnicoes!.clear();
                                                  cardapio.pratos!.clear();

                                                  for (var i = 0; i < 4; i++) {
                                                    final ref =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                tabela[i])
                                                            .withConverter(
                                                              fromFirestore:
                                                                  Cardapios
                                                                      .fromFirestore,
                                                              toFirestore: (Cardapios
                                                                          Cardapios,
                                                                      _) =>
                                                                  Cardapios
                                                                      .toFirestore(),
                                                            );

                                                    final docSnap =
                                                        await ref.get();

                                                    for (var j = 0;
                                                        j < docSnap.size;
                                                        j++) {
                                                      if (i == 0)
                                                        cardapio
                                                            .acompanhamentos!
                                                            .add(docSnap
                                                                .docs[j].id
                                                                .toString());
                                                      else if (i == 1)
                                                        cardapio.guarnicoes!
                                                            .add(docSnap
                                                                .docs[j].id
                                                                .toString());
                                                      else if (i == 2)
                                                        cardapio.entradas!.add(
                                                            docSnap.docs[j].id
                                                                .toString());
                                                      else
                                                        cardapio.pratos!.add(
                                                            docSnap.docs[j].id
                                                                .toString());
                                                    }
                                                  }

                                                  transformarEmObjeto(index);

                                                  idCardapio = snap[index].id;

                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return detalhar();
                                                  }));
                                                },
                                                child: const Icon(
                                                  Icons.edit,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    shape: CircleBorder()),
                                                onPressed: () {
                                                  showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            "Excluir ${snap[index].id}"),
                                                        content: const Text(
                                                            "Tem certeza que deseja excluir este cardápio?"),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                Navigator.pop(
                                                                    context);
                                                              });
                                                            },
                                                            child: const Text(
                                                                "Cancelar"),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              var db = FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "cardapios")
                                                                  .doc(snap[
                                                                          index]
                                                                      .id)
                                                                  .delete();
                                                              setState(() {
                                                                Navigator.pop(
                                                                    context);
                                                              });
                                                            },
                                                            child: const Text(
                                                              "Exluir",
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF3DBBE7),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: const Icon(Icons.delete,
                                                    size: 20),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            });
                      } else {
                        return const SizedBox(
                          child: Text("Nenhum dado encontrado."),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width * 0.9,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3DBBE7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.5),
                    )),
                onPressed: () {
                  Navigator.pushNamed(context, "/cadastrar_cardapio_view");
                },
                child: const Text("CADATRAR NOVO CARDÁPIO"),
              ),
            ),
            Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/home_admin_view");
                    },
                    child: const Text("Voltar")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class detalhar extends StatefulWidget {
  const detalhar({super.key});

  @override
  State<detalhar> createState() => _detalharState();
}

class _detalharState extends State<detalhar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gerenciar Cardápios"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.90,
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                color: Colors.grey,
                width: 1.5,
              ))),
              child: Column(
                children: [
                  const Text(
                    "Acompanhamentos",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton<String>(
                    value: dropdownValueAcompanhamento,
                    icon: const Icon(Icons.arrow_drop_down),
                    elevation: 16,
                    style: const TextStyle(color: Color(0xFF3DBBE7)),
                    underline: Container(
                      height: 2,
                      color: Color(0xFF3DBBE7),
                    ),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValueAcompanhamento = value!;
                        if (!acompanhamentos
                                .contains(dropdownValueAcompanhamento) &&
                            acompanhamentos.length < 5) {
                          acompanhamentos.add(dropdownValueAcompanhamento);
                        }
                      });
                    },
                    items: cardapio.acompanhamentos!
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: const EdgeInsets.all(30),
              itemCount: acompanhamentos.length,
              itemBuilder: (BuildContext context, int index) {
                return SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              acompanhamentos.elementAt(index),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: CircleBorder()),
                              onPressed: () {
                                setState(() {
                                  acompanhamentos.removeAt(index);
                                });
                              },
                              child: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: const BoxDecoration(
                  border: Border.symmetric(
                horizontal: BorderSide(
                  width: 1.5,
                  color: Colors.grey,
                ),
              )),
              child: Column(
                children: [
                  const Text(
                    "Guarnições",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton<String>(
                    value: dropdownValueGuarnicao,
                    icon: const Icon(Icons.arrow_drop_down),
                    elevation: 16,
                    style: const TextStyle(color: Color(0xFF3DBBE7)),
                    underline: Container(
                      height: 2,
                      color: Color(0xFF3DBBE7),
                    ),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValueGuarnicao = value!;
                        if (!guarnicoes.contains(dropdownValueGuarnicao) &&
                            guarnicoes.length < 5) {
                          guarnicoes.add(dropdownValueGuarnicao);
                        }
                      });
                    },
                    items: cardapio.guarnicoes!
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: const EdgeInsets.all(30),
              itemCount: guarnicoes.length,
              itemBuilder: (BuildContext context, int index) {
                return SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              guarnicoes.elementAt(index),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: CircleBorder()),
                              onPressed: () {
                                setState(() {
                                  guarnicoes.removeAt(index);
                                });
                              },
                              child: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: const BoxDecoration(
                  border: Border.symmetric(
                horizontal: BorderSide(
                  width: 1.5,
                  color: Colors.grey,
                ),
              )),
              child: Column(
                children: [
                  const Text(
                    "Entradas",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton<String>(
                    value: dropdownValueEntrada,
                    icon: const Icon(Icons.arrow_drop_down),
                    elevation: 16,
                    style: const TextStyle(color: Color(0xFF3DBBE7)),
                    underline: Container(
                      height: 2,
                      color: Color(0xFF3DBBE7),
                    ),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValueEntrada = value!;
                        if (!entradas.contains(dropdownValueEntrada) &&
                            entradas.length < 5) {
                          entradas.add(dropdownValueEntrada);
                        }
                      });
                    },
                    items: cardapio.entradas!
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: const EdgeInsets.all(30),
              itemCount: entradas.length,
              itemBuilder: (BuildContext context, int index) {
                return SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              entradas.elementAt(index),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: CircleBorder()),
                              onPressed: () {
                                setState(() {
                                  entradas.removeAt(index);
                                });
                              },
                              child: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: const BoxDecoration(
                  border: Border.symmetric(
                horizontal: BorderSide(
                  width: 1.5,
                  color: Colors.grey,
                ),
              )),
              child: Column(
                children: [
                  const Text(
                    "Pratos principais",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton<String>(
                    value: dropdownValuePrato,
                    icon: const Icon(Icons.arrow_drop_down),
                    elevation: 16,
                    style: const TextStyle(color: Color(0xFF3DBBE7)),
                    underline: Container(
                      height: 2,
                      color: Color(0xFF3DBBE7),
                    ),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValuePrato = value!;
                        if (!pratosPrincipais.contains(dropdownValuePrato) &&
                            pratosPrincipais.length < 5) {
                          pratosPrincipais.add(dropdownValuePrato);
                        }
                      });
                    },
                    items: cardapio.pratos!
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: const EdgeInsets.all(30),
              itemCount: pratosPrincipais.length,
              itemBuilder: (BuildContext context, int index) {
                return SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              pratosPrincipais.elementAt(index),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: CircleBorder()),
                              onPressed: () {
                                setState(() {
                                  pratosPrincipais.removeAt(index);
                                });
                              },
                              child: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/listar_cardapios");
                    },
                    child: const Text("Voltar")),
                ElevatedButton(
                    onPressed: () {
                      salvarAlteracoes();

                      dados = {};
                      acompanhamentos.clear();
                      entradas.clear();
                      guarnicoes.clear();
                      pratosPrincipais.clear();

                      cardapio.acompanhamentos!.clear();
                      cardapio.entradas!.clear();
                      cardapio.guarnicoes!.clear();
                      cardapio.pratos!.clear();

                      idCardapio = "";

                      dropdownValueAcompanhamento = "";
                      dropdownValueEntrada = "";
                      dropdownValueGuarnicao = "";
                      dropdownValuePrato = "";

                      Navigator.pushNamed(context, "/listar_cardapios");
                    },
                    child: Text("Salvar alterações")),
              ],
            )
          ],
        ),
      ),
    );
  }
}

void salvarAlteracoes() async {
  final json = {
    "acompanhamentos": acompanhamentos,
    "entradas": entradas,
    "guarnicoes": guarnicoes,
    "pratos_principais": pratosPrincipais,
  };

  await FirebaseFirestore.instance
      .collection("cardapios")
      .doc(idCardapio)
      .set(json);
}

void transformarEmObjeto(indice) {

  for (var i = 0; i < dados.values.length; i++) {
    for (var j = 0; j < dados.values.elementAt(i).length; j++) {
      if (dados.keys.elementAt(i) == "guarnicoes")
        guarnicoes.add(dados.values.elementAt(i)[j]);
      else if (dados.keys.elementAt(i) == "pratos_principais")
        pratosPrincipais.add(dados.values.elementAt(i)[j]);
      else if (dados.keys.elementAt(i) == "entradas")
        entradas.add(dados.values.elementAt(i)[j]);
      else
        acompanhamentos.add(dados.values.elementAt(i)[j]);
    }
  }

  dropdownValueAcompanhamento = cardapio.acompanhamentos!.first;
  dropdownValueEntrada = cardapio.entradas!.first;
  dropdownValueGuarnicao = cardapio.guarnicoes!.first;
  dropdownValuePrato = cardapio.pratos!.first;
}
