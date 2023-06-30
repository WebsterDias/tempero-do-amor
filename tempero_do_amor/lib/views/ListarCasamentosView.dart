import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

Map<String, dynamic> casamento = {};
List<String> cardapios = <String>[];
List<Ingrediente> ingredientes = [];

class Ingrediente{
  String? nome;
  String? quantidade;
  String? unidade;

  Ingrediente({
    this.nome,
    this.quantidade,
    this.unidade,
  });
}


class ListarCasamentosView extends StatefulWidget {
  const ListarCasamentosView({super.key});
  
  @override
  State<ListarCasamentosView> createState() => _ListarCasamentosViewState();
}

class _ListarCasamentosViewState extends State<ListarCasamentosView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gerenciar Casamentos"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
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
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection("casamentos").snapshots(),
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
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Color(0xFF3DBBE7),
                                                  shape: CircleBorder()
                                                ),
                                          onPressed: () async {
                                            
                                            await buscarNoBanco(snap[index].id);
                                            
                                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                                              return detalhar(snap[index].id);
                                            }));
                                          }, 
                                      child: const Icon(
                                                    Icons.edit,
                                                    size: 20,
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
                                                    title: Text("Excluir: ${snap[index].id}"),
                                                    content: const Text(
                                                      "Tem certeza que deseja excluir este casamento?"
                                                    ),
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
                                                        onPressed: () {
                                                          var db = FirebaseFirestore.instance.collection("casamentos").doc(snap[index].id).delete();
                                                          setState(() {
                                                          Navigator.pop(context);
                                                        });
                                                      },
                                                      child: const Text("Exluir", style: TextStyle(
                                                        color: Color(0xFF3DBBE7),
                                                      ),),
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
                        Navigator.pushNamed(context, "/cadastrar_casamento_view");
                      }, 
                      child: const Text("CADATRAR NOVO CASAMENTO"),
                    ),
              ),
            ElevatedButton(onPressed: () {
              Navigator.pushNamed(context, "/home_admin_view");
            }, child: const Text("Voltar")),
          ],
        ),
      ),
    );
  }
}

class detalhar extends StatefulWidget {
  final idCasamento;
  const detalhar(this.idCasamento, {super.key});

  @override
  State<detalhar> createState() => _detalharState();
}

class _detalharState extends State<detalhar> {
  
  TextEditingController timeinput = TextEditingController();

  @override
  void initState() {
    timeinput.text = ""; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.idCasamento}"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Column(
                    children: [
                      const SizedBox(
                  height: 15,
                ),
                Text("${casamento["convidados"]} convidados"),
                const SizedBox(
                  height: 15,
                ),
                Text("Cardápio: ${casamento["cardapio"]}"),
                const SizedBox(
                  height: 15,
                ),
                Text("Data: ${casamento["data"]}"),
                const SizedBox(
                  height: 15,
                ),
                Text("Hora: ${casamento["hora"]}"),
                const SizedBox(
                  height: 15,
                ),
                Text("Endereço: Rua ${casamento.values.elementAt(2).values.first} ${casamento.values.elementAt(2).values.last}," 
                "${casamento.values.elementAt(2).values.elementAt(1)} ${casamento.values.elementAt(2).values.elementAt(2)}"),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(onPressed: () async {

                    await FirebaseFirestore.instance.collection("cardapios").get().then((value) {
                      for (var i = 0; i < value.docs.length; i++) {
                        cardapios.add(value.docs[i].id);
                      }
                    } 
                    );

                    // ignore: use_build_context_synchronously
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return editarCasamento(widget.idCasamento);
                      }));
                    }, child: const Text("Editar"),
                  ),

                  ElevatedButton(onPressed: () async {
                    await listarIngredientes(casamento.values.first);

                    // ignore: use_build_context_synchronously
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return GerarLista(widget.idCasamento);
                    }));
                  }, 
                  child: const Text("Gerar lista"),
              ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 35,
                  ),
                  child: ElevatedButton(onPressed: (){
                    Navigator.pushNamed(context, "/listar_casamentos");
                  }, child: const Text("Voltar")),
                ),
              ],
            ),
          ),
        ),
    );
  }
}

class editarCasamento extends StatefulWidget {
  final idCasamento;
  const editarCasamento(this.idCasamento, {super.key});

  @override
  State<editarCasamento> createState() => _editarCasamentoState();
}

class _editarCasamentoState extends State<editarCasamento> {
  var dropdownValue = cardapios.first;
  String finaldate = casamento["data"];
  TextEditingController data = TextEditingController();
  TextEditingController timeinput = TextEditingController();
  TextEditingController convidados = TextEditingController(text: casamento["convidados"]);
  TextEditingController cardapio = TextEditingController(text: casamento.values.first);
  TextEditingController bairro = TextEditingController(text: casamento.values.elementAt(2).values.elementAt(1));
  TextEditingController cidade = TextEditingController(text: casamento.values.elementAt(2).values.elementAt(2));
  TextEditingController numero = TextEditingController(text: casamento.values.elementAt(2).values.last);
  TextEditingController rua = TextEditingController(text: casamento.values.elementAt(2).values.first);


  @override
  void initState() {
    timeinput.text = casamento.values.elementAt(1);
    data.text = casamento["data"];
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.idCasamento}"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Column(
                children: [
                  const Text("Cardápio"),
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
                          cardapio.text = dropdownValue;
                        });
                      },
                      items: cardapios.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              TextField(
                controller: convidados,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "N° de Convidados"
                ),
              ),
              TextField(
                controller: data,
                decoration: const InputDecoration(
                  icon: Icon(Icons.calendar_today_rounded),
                  labelText: "Selecione a data",
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
                  }else{
                    var dividido = finaldate.split('/');
                    finaldate = "${dividido.last}-${dividido[1]}-${dividido.first}";
                  }
                },
              ),
              TextField(
                controller: timeinput, //editing controller of this TextField
                decoration: InputDecoration( 
                   icon: Icon(Icons.timer), //icon of text field
                   labelText: "Enter Time" //label text of field
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
                  labelText: "Rua"
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
                controller: bairro,
                decoration: const InputDecoration(
                  labelText: "Bairro"
                ),
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

                    cardapios.clear();
                    casamento = {};
                    dropdownValue = "";
                    cardapio.text = "";
                    convidados.text = "";
                    data.text = "";
                    timeinput.text = "";
                    rua.text = "";
                    numero.text = "";
                    bairro.text = "";
                    cidade.text = "";

                    Navigator.pushNamed(context, "/listar_casamentos");
                  }, child: const Text("Voltar")),

                  ElevatedButton(onPressed: () async {
                    var bd =
                    FirebaseFirestore.instance.collection('casamentos').doc(widget.idCasamento);

                    final json = {
                      'cardapio': cardapio.text,
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

                    cardapios.clear();
                    casamento = {};
                    dropdownValue = "";
                    cardapio.text = "";
                    convidados.text = "";
                    data.text = "";
                    timeinput.text = "";
                    rua.text = "";
                    numero.text = "";
                    bairro.text = "";
                    cidade.text = "";

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

class GerarLista extends StatefulWidget {
  final idCasamento;
  const GerarLista(this.idCasamento, {super.key});

  @override
  State<GerarLista> createState() => _GerarListaState();
}

class _GerarListaState extends State<GerarLista> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista do casamento de ${widget.idCasamento}"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text("Ingrediente"),
                    Container(
                      height: 25,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        )
                      ),
                    ),
                    const Text("Quantidade"),
                  ],
                ),
                Container(
                  height: 15,
                  decoration: const BoxDecoration(
                    border: BorderDirectional(
                      bottom:  BorderSide(),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: StreamBuilder(
                  builder: (BuildContext context, data) {
                    return ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: ingredientes.length, 
                        itemBuilder: (context, index){
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(ingredientes.elementAt(index).nome.toString()),
                                  Text(ingredientes.elementAt(index).quantidade.toString() + " " + ingredientes.elementAt(index).unidade.toString()),
                                ],
                              )
                            ],
                          );
                        },
                    );
                  },
                ),
              ),
              ElevatedButton(onPressed: (){
                ingredientes.clear();
                Navigator.pop(context);
              }, child: const Text("Voltar"))
            ],
          ),
        ),
      ),
    );
  }
}

Future buscarNoBanco(idCasamento) async {
  var db = await FirebaseFirestore.instance.collection("casamentos").doc(idCasamento);
  var dados;
  await db.get().then(
    (DocumentSnapshot doc) {
      dados = doc.data() as Map<String, dynamic>;
    },
    onError: (e) => print("Error getting document: $e"),
  );

  var data = dados["data"].toString();

  var dividido = data.split('-');
  var ast = "${dividido.last}/${dividido[1]}/${dividido.first}";
  dados["data"] = ast;
  casamento.addAll(dados);
}

Future listarIngredientes(idCardapio) async {
  var banco = await FirebaseFirestore.instance.collection("cardapios").doc(idCardapio);
  var dados;

  var calc = casamento["convidados"];

  calc = int.parse(calc) / 100;

  await banco.get().then(
    (DocumentSnapshot doc) {
      dados = doc.data() as Map<String, dynamic>;
  });

  for (int i = 0; i < 4; i ++) {
    await buscarIngredientes(dados.keys.elementAt(i), dados.values.elementAt(i), calc);
  }
  
  for (var i = 0; i < ingredientes.length; i++) {
    for (var j = 0; j < ingredientes.length; j++) {
      if(i != j){
        if(ingredientes.elementAt(i).nome == ingredientes.elementAt(j).nome){
          if(ingredientes.elementAt(i).unidade == ingredientes.elementAt(j).unidade){

            var q1 = double.parse(ingredientes.elementAt(i).quantidade.toString());
            
            q1 += double.parse(ingredientes.elementAt(j).quantidade.toString());

            ingredientes.elementAt(i).quantidade = q1.toString();

            ingredientes.removeAt(j);
          }
        }
      }
    }
  }

}

Future buscarIngredientes(componente, ing, calc) async {

  for (var i = 0; i < ing.length; i++) {

    var ino = FirebaseFirestore.instance.collection(componente).doc(ing[i]);

    await ino.get().then((DocumentSnapshot doc) {

      var value = doc.data() as Map<String, dynamic>;

      value.values.forEach((element) {
        var db = FirebaseFirestore.instance.collection("ingredientes").doc(element);
        db.get().then(
          (DocumentSnapshot doc) {
            var db2 = doc.data() as Map<String, dynamic>;
            
            Ingrediente temp = Ingrediente(
              nome: db2.values.last.toString(),
              quantidade: (int.parse(db2.values.first) * calc).toString(),
              // quantidade: db2.values.first.toString(),
              unidade:  db2.values.elementAt(1),
            );

            ingredientes.add(temp);
        });
      });
    });
  }
}