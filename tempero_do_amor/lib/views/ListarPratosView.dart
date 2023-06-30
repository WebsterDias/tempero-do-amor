import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tempero_do_amor/views/CadastrarPratoView.dart';

Map<String, dynamic> dados = {};
List<Ingredientes> listinha = [];

List unidades = ["Kilogramas (kg)", "Gramas (g)", "Litros (L)", "Unidade (u)"];
String dropdownValue = unidades.first;

var prato = "";

List ingid = [];
List temp = [];

var pratovalue = "";
var pratokey = "";

String? tipo_prato = 'acompanhamentos';

String nomePrato = "Acompanhamento";

class Ingredientes {
  String? nome;
  String? quantidade;
  String? unidade_medida;

  Ingredientes({
    this.nome,
    this.quantidade,
    this.unidade_medida,
  });
}

class ListarPratosView extends StatefulWidget {
  const ListarPratosView({super.key});

  @override
  State<ListarPratosView> createState() => _ListarPratosViewState();
}

class _ListarPratosViewState extends State<ListarPratosView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gerenciar Pratos"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(padding: EdgeInsets.all(20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Visualizar:"),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: ElevatedButton(
                          onPressed: () => {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              tipo_prato = "acompanhamentos";
                              nomePrato = "Acompanhamentos";
                              return tipoPrato();
                            }))
                          },
                          child: const Text("Acompanhamentos"),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: ElevatedButton(
                          onPressed: () => {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              tipo_prato = "guarnicoes";
                              nomePrato = "Guarnições";
                              return tipoPrato();
                            }))
                          },
                          child: const Text("Guarnições"),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: ElevatedButton(
                          onPressed: () => {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              tipo_prato = "pratos_principais";
                              nomePrato = "Pratos Principais";
                              return tipoPrato();
                            }))
                          },
                          child: const Text("Pratos Principais"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                          Navigator.pushNamed(context, "/cadastrar_prato_view");
                        },
                        child: const Text("CADATRAR NOVO PRATO"),
                      ),
                    ),
                  ],
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
        ],
      ),
    );
  }
}

class tipoPrato extends StatefulWidget {
  const tipoPrato({Key? key}) : super(key: key);

  @override
  State<tipoPrato> createState() => _tipoPratoState();
}

class _tipoPratoState extends State<tipoPrato> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gerenciar ${nomePrato}"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric (
                  horizontal: MediaQuery.of(context).size.width * 0.08,
                  vertical: 20,
                ),
                height: MediaQuery.of(context).size.height * 0.65,
                child: ListView(
                  children: [
                    SingleChildScrollView(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                        .collection(tipo_prato.toString())
                        .snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                          if(snapshot.hasData) {
                            final snap = snapshot.data!.docs;
                            return ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: snap.length, 
                              itemBuilder: (context, index){
                                return Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(bottom: 12),
                                  child: Stack(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                          children: [
                                            Text(
                                              snap[index].id,
                                            ),
                                          ],
                                          ),
                                          Row(children: [
                                            SizedBox(
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Color(0xFF3DBBE7),
                                                  shape: CircleBorder()
                                                ),
                                                onPressed: () async {
                                                 setState(() {
                                                  listinha.clear();
                                                  dados = {};
                                                  prato = snap[index].id;
                                                  });
                                                            
                                                  final docRef =
                                                    await FirebaseFirestore.instance
                                                        .collection(
                                                            tipo_prato.toString())
                                                        .doc(snap[index].id);

                                                await docRef.get().then(
                                                  (DocumentSnapshot doc) {
                                                    dados = doc.data()
                                                        as Map<String, dynamic>;
                                                  },
                                                  onError: (e) => print(
                                                      "Error getting document: $e"),
                                                );
                                                  
                                                  dados.values.forEach((element) => ingid.add(element));
                                                            
                                                  await transformarEmObjeto();
                                                            
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                                              shape: CircleBorder()
                                            ),
                                            onPressed: () {
                                              showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                      title: Text(
                                                          "Excluir: ${snap[index].id}"),
                                                      content: const Text(
                                                          "Tem certeza que deseja excluir este prato?"),
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
                                                            var doodle =
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        tipo_prato
                                                                            .toString())
                                                                    .doc(snap[index]
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
                                                              color: Color(0xFF3DBBE7),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                },
                                              );
                                            }, 
                                            child: const Icon(
                                              Icons.delete, 
                                              size: 20
                                            ),
                                          ),
                                        ),
                                        ],
                                      ),
                                    ],
                                  ),
                                    ],
                                  ),
                                );
                              }
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.9,
                child:
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF3DBBE7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.5),
                        )
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, "/cadastrar_prato_view");
                      }, 
                      child: const Text("CADATRAR NOVO PRATO"),
                    ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: () {
                                    Navigator.pushNamed(context, "/listar_pratos");
                                  }, child: const Text("Voltar")),
                  ],
                ),
              ),
            ],
          ),
      ),
    );
  }
}

class detalhar extends StatefulWidget {
  const detalhar({Key? key}) : super(key: key);

  @override
  State<detalhar> createState() => _detalharState();
}

class _detalharState extends State<detalhar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes de ${prato}"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: const [
                Text("Ingrediente"),
                Text("      "),
                Text("Quantidade"),
              ],
            ),
            Container(
              height: 15,
              decoration: const BoxDecoration(
                border: BorderDirectional(
                  bottom: BorderSide(),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.68,
              child: StreamBuilder(
                builder: (BuildContext context, data) {
                  return ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: dados.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: 10,
                        ),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: Row(
                                children: [
                                  Text(
                                    listinha.elementAt(index).nome.toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.20,
                              child: Row(
                                children: [
                                  Text(
                                      "${listinha.elementAt(index).quantidade} ${listinha.elementAt(index).unidade_medida}",
                                      textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                            Container(
                              height: 20,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF3DBBE7),
                                      shape: CircleBorder()),
                                  onPressed: () async {
                                    setState(() {
                                      temp.clear();
                                    });

                                    pratovalue = dados.values.elementAt(index);

                                    pratokey = listinha
                                        .elementAt(index)
                                        .nome
                                        .toString();

                                    temp.add(listinha
                                        .elementAt(index)
                                        .nome
                                        .toString());
                                    temp.add(listinha
                                        .elementAt(index)
                                        .quantidade
                                        .toString());
                                    temp.add(listinha
                                        .elementAt(index)
                                        .unidade_medida
                                        .toString());

                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return editarIngrediente();
                                    }));
                                  },
                                  child: const Icon(
                                    Icons.edit,
                                    size: 15,
                                  )),
                            ),
                            Container(
                              height: 20,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                                "Excluir ${listinha.elementAt(index).nome.toString()}"),
                                            content: Text(
                                                "Tem certeza que deseja excluir este ingrediente de ${prato}?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    Navigator.pop(context);
                                                  });
                                                },
                                                child: const Text("Cancelar"),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  excluirIngredientePrato(dados
                                                      .values
                                                      .elementAt(index));

                                                  if (atualizaEntrada(dados
                                                          .values
                                                          .elementAt(index)) ==
                                                      true) {
                                                    Navigator.pop(context);
                                                  } else {
                                                    Navigator.pushNamed(context,
                                                        "/listar_pratos");
                                                  }
                                                },
                                                child: const Text(
                                                  "Exluir",
                                                  style: TextStyle(
                                                    color: Color(0xFF3DBBE7),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    size: 15,
                                  )),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
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

class editarIngrediente extends StatefulWidget {
  const editarIngrediente({super.key});

  @override
  State<editarIngrediente> createState() => _editarIngredienteState();
}

class _editarIngredienteState extends State<editarIngrediente> {
  TextEditingController nome = TextEditingController(text: temp.first);
  TextEditingController quantidade =
      TextEditingController(text: temp.elementAt(1));
  String un = "u";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar ${pratokey}'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: nome,
                            decoration: const InputDecoration(
                              label: Text("Nome do Ingrediente"),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Este campo não pode estar vazio.';
                              } else {
                                return null;
                              }
                            },
                          ),
                          TextFormField(
                            controller: quantidade,
                            decoration: const InputDecoration(
                              label: Text("Quantidade"),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Este campo não pode estar vazio.';
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 1,
                            child: DropdownButton<String>(
                              value: dropdownValue,
                              icon: const Icon(Icons.arrow_drop_down),
                              onChanged: (String? value) {
                                setState(() {
                                  dropdownValue = value!;
                                  if (dropdownValue.contains("kg")) {
                                    un = "kg";
                                  } else if (dropdownValue.contains("Gramas")) {
                                    un = "g";
                                  } else if (dropdownValue.contains("L")) {
                                    un = "L";
                                  } else {
                                    un = "u";
                                  }
                                });
                              },
                              items: unidades.map<DropdownMenuItem<String>>(
                                  (dynamic value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Voltar")),
                        ElevatedButton(
                          onPressed: () {
                            List ing = [];
                            ing.add(nome.text);
                            ing.add(quantidade.text);
                            ing.add(un.toString());
                            atualizarIngrediente(ing);
                            setState(() {
                              nome.text = "";
                              quantidade.text = "";
                              un = "";
                            });
                            Navigator.pushNamed(context, "/listar_pratos");
                          },
                          child: const Text("Finalizar"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future transformarEmObjeto() async {
  for (var i = 0; i < dados.length; i++) {
    await FirebaseFirestore.instance
        .collection("ingredientes")
        .doc(dados.values.elementAt(i).toString())
        .get()
        .then((value) {
      var mapa = value.data() as Map<String, dynamic>;
      Ingredientes teste = Ingredientes(
        nome: mapa.values.last.toString(),
        quantidade: mapa.values.first.toString(),
        unidade_medida: mapa.values.elementAt(1).toString(),
      );

      listinha.add(teste);
    });
  }
}

void atualizarIngrediente(List ing) async {
  var firebase = await FirebaseFirestore.instance
      .collection("ingredientes")
      .doc(pratovalue);

  var json = {
    'nome': ing.first.toString(),
    'quantidade': ing.elementAt(1).toString(),
    'unidade': ing.last.toString(),
  };

  firebase.set(json);

  firebase = FirebaseFirestore.instance.collection(tipo_prato!).doc(prato);

  Map<String, dynamic> mapaTemp = {};

  for (var i = 0; i < dados.length; i++) {
    if (!dados.keys.elementAt(i).contains(pratokey)) {
      mapaTemp.addAll({dados.keys.elementAt(i): dados.values.elementAt(i)});
    } else {
      mapaTemp.addAll({
        ing.first.toString(): pratovalue,
      });
    }
  }

  firebase.set(mapaTemp);
}

Future excluirIngredientePrato(element) async {
  await FirebaseFirestore.instance
      .collection("ingredientes")
      .doc(element)
      .delete();
}

Future atualizaEntrada(ingrediente) async {
  Map<String, dynamic> mapaTemp = {};

  for (var i = 0; i < dados.length; i++) {
    if (!(dados.values.elementAt(i) == ingrediente)) {
      mapaTemp.addAll({
        dados.keys.elementAt(i): dados.values.elementAt(i),
      });
    }
  }

  dados.clear();
  dados.addAll(mapaTemp);

  if (dados.length > 0) {
    await FirebaseFirestore.instance
        .collection(tipo_prato!)
        .doc(prato)
        .set(dados);
    return true;
  } else {
    await FirebaseFirestore.instance
        .collection(tipo_prato!)
        .doc(prato)
        .delete();
    return false;
  }
}
