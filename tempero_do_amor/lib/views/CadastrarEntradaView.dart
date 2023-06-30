import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

List lista = ["Kilogramas (kg)", "Gramas (g)", "Litros (L)", "Unidade (u)"];

String dropdownValue = lista.first;

class CadastrarEntradaView extends StatefulWidget {
  const CadastrarEntradaView({Key? key}) : super(key: key);

  @override
  State<CadastrarEntradaView> createState() => _CadastrarEntradaView();
}

class _CadastrarEntradaView extends State<CadastrarEntradaView> {
  final TextEditingController nomeEntrada = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastrar Nova Entrada"),
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
                      "Nome da Entrada",
                    ),
                    TextField(
                      controller: nomeEntrada,
                      decoration: const InputDecoration(
                        hintText: "Digite aqui",
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return CadastrarIngredientes(nomeEntrada.text);
                        }))
                      },
                      child: const Text("Próximo"),
                    ),
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(onPressed: () {
                      Navigator.pushNamed(context, "/listar_entradas");
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
  final nomeEntrada;
  const CadastrarIngredientes(this.nomeEntrada, {Key? key}) : super(key: key);

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
  var instancia_entrada;
  var instancia_ingrediente;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nomeEntrada),
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
                  Navigator.pushNamed(context, "/listar_entradas");
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

    if (contador == 1) {
      instancia_entrada = FirebaseFirestore.instance
          .collection('entradas')
          .doc(widget.nomeEntrada);
      insereEntrada();
    } else {
      instancia_entrada.update({
        nome.text: instancia_ingrediente.id,
      });
    }

    nome.text = "";
    quantidade.text = "";
    un = "";
    contador++;

    setState(() {
      textoIngrediente = "Ingrediente $contador";
    });
  }

  Future salvarEFinalizar() async {
    instanciaEInsereIngrediente();

    if (contador == 1) {
      instancia_entrada = FirebaseFirestore.instance
          .collection('entradas')
          .doc(widget.nomeEntrada);
    }
    insereEntrada();
    Navigator.pushNamed(context, "/listar_entradas");
  }

  void instanciaEInsereIngrediente() {

    final json_ing = {
      'nome': nome.text,
      'quantidade': quantidade.text,
      'unidade': un.toString(),
    };

    instancia_ingrediente =
        FirebaseFirestore.instance.collection('ingredientes').doc();

    instancia_ingrediente.set(json_ing);

  }

  void insereEntrada() {
    final json_entrada = {
      nome.text: instancia_ingrediente.id,
    };

    if (contador == 1) {
      instancia_entrada.set(json_entrada);
    } else {
      instancia_entrada.update({
        nome.text: instancia_ingrediente.id,
      });
    }
  }
}