import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tempero_do_amor/main.dart';

List lista = ["Kilogramas (kg)", "Gramas (g)", "Litros (L)", "Unidade (u)"];

String dropdownValue = lista.first;

class CadastrarPratoView extends StatefulWidget {
  const CadastrarPratoView({Key? key}) : super(key: key);

  @override
  State<CadastrarPratoView> createState() => _CadastrarPratoView();
}

class _CadastrarPratoView extends State<CadastrarPratoView> {
  final List<String> lista = ['Acompanhamento', 'Guarnição', 'Prato Principal'];
  String? tipo_prato = 'Acompanhamento';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastrar Novo Prato"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const Padding(padding: EdgeInsets.all(20)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("Cadastrar:"),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: ElevatedButton(
                            onPressed: () => {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                tipo_prato = "Acompanhamento";
                                return NomeDoPrato(tipo_prato);
                              }))
                            },
                            child: const Text("Acompanhamento"),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: ElevatedButton(
                            onPressed: () => {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                tipo_prato = "Guarnição";
                                return NomeDoPrato(tipo_prato);
                              }))
                            },
                            child: const Text("Guarnição"),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: ElevatedButton(
                            onPressed: () => {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                tipo_prato = "Prato Principal";
                                return NomeDoPrato(tipo_prato);
                              }))
                            },
                            child: const Text("Prato Principal"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(onPressed: () {
                  Navigator.pop(context);
                }, child: Text("Voltar"))  
               ],
      ),
    );
  }
}

class NomeDoPrato extends StatefulWidget {
  final tipo_prato;
  const NomeDoPrato(this.tipo_prato, {Key? key}) : super(key: key);

  @override
  State<NomeDoPrato> createState() => _NomeDoPratoState();
}

class _NomeDoPratoState extends State<NomeDoPrato> {
  TextEditingController nomePrato = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastrar Novo Prato"),
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
                    const Text(
                      "Nome do Prato",
                    ),
                    TextField(
                      controller: nomePrato,
                      decoration: const InputDecoration(
                        hintText: "Digite aqui",
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return CadastrarIngredientes(widget.tipo_prato, nomePrato.text);
                        }))
                      },
                      child: const Text("Próximo"),
                    ),
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(onPressed: () {
                      Navigator.pop(context);
                    }, child: const Text("Voltar")),
                  ],
                )
              ],
            ),
          ),
        ),
    );
  }
}

class CadastrarIngredientes extends StatefulWidget {
  final tipo_prato;
  final nomePrato;
  const CadastrarIngredientes(this.tipo_prato, this.nomePrato, {Key? key})
      : super(key: key);

  @override
  State<CadastrarIngredientes> createState() => _CadastrarIngredientesState();
}

class _CadastrarIngredientesState extends State<CadastrarIngredientes> {
  TextEditingController nome = TextEditingController();
  TextEditingController quantidade = TextEditingController();
  String un = "";
  final formkey = GlobalKey<FormState>();
  var contador = 1;
  var textoIngrediente = "Ingrediente 1";
  var instancia_prato;
  var instancia_ingrediente;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nomePrato),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: formkey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          textoIngrediente,
                        ),
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
                          keyboardType: TextInputType.number,
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
                              // This is called when the user selects an item.
                              setState(() {
                                dropdownValue = value!;
                                if ( dropdownValue.contains("kg") ) {
                                  un = "kg";
                                } else if ( dropdownValue.contains("Gramas") ) {
                                  un = "g";
                                }else if ( dropdownValue.contains("L") ) {
                                  un = "L";
                                } else {
                                  un = "u";
                                }
                              });
                            },
                            items: lista.map<DropdownMenuItem<String>>((dynamic value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                final isValidForm = formkey.currentState!.validate();
                
                                if (isValidForm) {
                                  salvarEContinuarInserindo();
                                }
                              },
                              child: const Text("+ ingredientes"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                final isValidForm = formkey.currentState!.validate();
                
                                if (isValidForm) {
                                  salvarEFinalizar();
                                }
                              },
                              child: const Text("Finalizar"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                ElevatedButton(onPressed: () {
                  Navigator.pushNamed(context, "/listar_pratos");
                }, child: const Text("Cancelar")),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future salvarEContinuarInserindo() async {
    instanciaEInsereIngrediente();

    var colecao = widget.tipo_prato;

    if (colecao == 'Guarnição') {
      colecao = 'guarnicoes';
    } else if (colecao == 'Prato Principal') {
      colecao = 'pratos_principais';
    } else {
      colecao = 'acompanhamentos';
    }

    if (contador == 1) {
      instancia_prato =
          FirebaseFirestore.instance.collection(colecao).doc(widget.nomePrato);
      inserePrato();
    } else {
      instancia_prato.update({
        nome.text: instancia_ingrediente.id,
      });
    }

    nome.text = "";
    quantidade.text = "";
    contador++;

    setState(() {
      textoIngrediente = "Ingrediente $contador";
    });
  }

  Future salvarEFinalizar() async {
    var colecao = widget.tipo_prato;

    if (colecao == 'Guarnição') {
      colecao = 'guarnicoes';
    } else if (colecao == 'Prato Principal') {
      colecao = 'pratos_principais';
    } else {
      colecao = 'acompanhamentos';
    }

    instanciaEInsereIngrediente();
    if (contador == 1) {
      instancia_prato =
          FirebaseFirestore.instance.collection(colecao).doc(widget.nomePrato);
    }
    inserePrato();
    Navigator.pushNamed(context, "/listar_pratos");
  }

  void instanciaEInsereIngrediente() {
    instancia_ingrediente =
        FirebaseFirestore.instance.collection('ingredientes').doc();

    final json_ing = {
      'nome': nome.text,
      'quantidade': quantidade.text,
      'unidade': un,
    };

    instancia_ingrediente.set(json_ing);
  }

  void inserePrato() {
    final json_prato = {
      nome.text: instancia_ingrediente.id,
    };

    if (contador == 1) {
      instancia_prato.set(json_prato);
    } else {
      instancia_prato.update({
        nome.text: instancia_ingrediente.id
      });
    }
  }
}
