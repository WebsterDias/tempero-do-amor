import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

List<String> lista = <String>[];
var cont = 0;

String cardapio = "";
String finaldate = "";
TextEditingController convidados = TextEditingController();
TextEditingController bairro = TextEditingController();
TextEditingController cidade = TextEditingController();
TextEditingController numero = TextEditingController();
TextEditingController rua = TextEditingController();

class Cardapios {
  List<String>? cardapios;

  Cardapios({
    this.cardapios,
  });

  factory Cardapios.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Cardapios(
      cardapios:
          data?['cardapios'] is Iterable ? List.from(data?['cardapios']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      // ignore: unnecessary_null_comparison
      if (Cardapios != null) "cardapios": cardapios,
    };
  }
}

class CadastrarCasamentoView extends StatefulWidget {
  const CadastrarCasamentoView({Key? key}) : super(key: key);

  @override
  State<CadastrarCasamentoView> createState() => _CadastrarCasamentoViewState();
}

class _CadastrarCasamentoViewState extends State<CadastrarCasamentoView> {
  TextEditingController nomeNoivos = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastrar novo casamento"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const Text("Nome do noivo e da noiva"),
                TextFormField(
                  controller: nomeNoivos,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (cont == 0) {
                      final ref = FirebaseFirestore.instance
                          .collection("cardapios")
                          .withConverter(
                            fromFirestore: Cardapios.fromFirestore,
                            toFirestore: (Cardapios Cardapios, _) =>
                                Cardapios.toFirestore(),
                          );
      
                      final docSnap = await ref.get();
      
                      for (var i = 0; i < docSnap.size; i++) {
                        lista.add(docSnap.docs[i].id.toString());
                      }
                      cont += 1;
                    }
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return CadastrarDetalhesCasamento(nomeNoivos.text);
                    }));
                  },
                  child: const Text("Continuar"),
                ),
              ],
            ),
            Column(
              children: [
                ElevatedButton(onPressed: () {
                  Navigator.pushNamed(context, "/listar_casamentos");
                }, child: const Text("Voltar")),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CadastrarDetalhesCasamento extends StatefulWidget {
  final nomeNoivos;
  const CadastrarDetalhesCasamento(this.nomeNoivos, {Key? key})
      : super(key: key);

  @override
  State<CadastrarDetalhesCasamento> createState() =>
      _CadastrarDetalhesCasamento();
}

class _CadastrarDetalhesCasamento extends State<CadastrarDetalhesCasamento> {
  var dropdownValue = lista.first;
  TextEditingController data = TextEditingController();
  TextEditingController timeinput = TextEditingController();

  @override
  void initState() {
    timeinput.text = "";
    data.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nomeNoivos),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
                  Column(
                    children: [
                      const Text("Selecione o Cardápio"),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: DropdownButton<String>(
                                      value: dropdownValue,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      elevation: 16,
                                      underline: Container(
                        height: 1,
                        color: Colors.grey,
                                      ),
                                      onChanged: (String? value) {
                        setState(() {
                          dropdownValue = value!;
                          cardapio = dropdownValue.toString();
                        });
                                      },
                                      items: lista.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                                      }).toList(),
                                    ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      TextField(
                        controller: convidados,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "N° de convidados",
                        ),
                      ),
                    ],
                  ),
              SizedBox(
                child: Column(
                  children: [
                    TextField(
                      controller: data,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today_rounded),
                        labelText: "Selecione a Data",
                      ),
                      onTap: () async {
                        DateTime? pickDate = await showDatePicker(
                          context: context, 
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101));
              
                        if(pickDate != null){
                          setState(() {
                            data.text = DateFormat('dd/MM/yyyy').format(pickDate);
                            finaldate = DateFormat('yyyy-MM-dd').format(pickDate);
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              TextField(
                controller: timeinput, //editing controller of this TextField
                decoration: const InputDecoration( 
                   icon: Icon(Icons.timer), //icon of text field
                   labelText: "Horário" //label text of field
                ),
                readOnly: true,  //set it true, so that user will not able to edit text
                onTap: () async {
                  TimeOfDay? pickedTime =  await showTimePicker(
                    initialTime: TimeOfDay.now(),
                    context: context,
                  );
                  
                  var hora = pickedTime.toString();
                  hora = hora.replaceAll("TimeOfDay(", "");
                  hora = hora.replaceAll(")", "");

                  setState(() {
                    timeinput.text = hora;
                  }); 
                },
             ),
              TextFormField(
                controller: rua,
                decoration: const InputDecoration(
                  labelText: "Rua",
                ),
              ),
              TextField(
                controller: numero,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Número"
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Bairro"
                ),
                controller: bairro,
              ),
              TextFormField(
                controller: cidade,
                decoration: const InputDecoration(
                  labelText: "Cidade"
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(onPressed: () {
                    limparVariaveis();
                    Navigator.pushNamed(context, "/listar_casamentos");
                  }, child: const Text("Cancelar")),

                  ElevatedButton(onPressed: () async {
                    var bd =
                    FirebaseFirestore.instance.collection('casamentos').doc(widget.nomeNoivos);

                    final json = {
                      'cardapio': cardapio,
                      'convidados': convidados.text,
                      'data': finaldate,
                      'hora': timeinput.text,
                      'endereco': {
                        'rua': rua.text,
                        'numero': numero.text,
                        'bairro': bairro.text,
                        'cidade': cidade.text,
                      }
                    };

                    await bd.set(json);
                    limparVariaveis();
                    Navigator.pushNamed(context, "/listar_casamentos");
                  }, 
                  child: const Text("Salvar"),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void limparVariaveis() {
   convidados.text = "";
 bairro.text = "";
 cidade.text = "";
 numero.text = "";
 rua.text = "";
}