import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tempero_do_amor/views/ListarCasamentosView.dart';

Map<String, dynamic> casamento = {};

class ProximosCasamentosView extends StatefulWidget {
  const ProximosCasamentosView({Key? key}) : super(key: key);

  @override
  State<ProximosCasamentosView> createState() => _ProximosCasamentosView();
}

class _ProximosCasamentosView extends State<ProximosCasamentosView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Próximos Casamentos"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("casamentos")
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      final snap = snapshot.data!.docs;
                      return ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: snap.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                color: const Color(0xFFD8363A),
                              )),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              snap[index].id,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color(0xFF3DBBE7),
                                              ),
                                              onPressed: () async {
                                                await buscarNoBanco(
                                                    snap[index].id);

                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return detalhar(
                                                      snap[index].id);
                                                }));
                                              },
                                              child: const Icon(Icons
                                                  .arrow_right_alt_outlined),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ],
            ),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/home_user_view");
              },
              child: const Text("Voltar")),
        ],
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Text("${casamento.values.last} convidados"),
                  const SizedBox(
                    height: 15,
                  ),
                  Text("Cardápio: ${casamento.values.first}"),
                  const SizedBox(
                    height: 15,
                  ),
                  Text("Data: ${casamento.values.elementAt(3)}"),
                  const SizedBox(
                    height: 15,
                  ),
                  Text("Hora: ${casamento.values.elementAt(1)}"),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                      "Endereço: Rua ${casamento.values.elementAt(2).values.first} ${casamento.values.elementAt(2).values.last},"
                      "${casamento.values.elementAt(2).values.elementAt(1)} ${casamento.values.elementAt(2).values.elementAt(2)}"),
                ],
              ),
            ),
          ),
          ElevatedButton(onPressed: () {
            Navigator.pop(context);
          }, child: const Text("Voltar")),
        ],
      ),
    );
  }
}

Future buscarNoBanco(idCasamento) async {
  var db = await FirebaseFirestore.instance
      .collection("casamentos")
      .doc(idCasamento);
  var dados;
  await db.get().then(
    (DocumentSnapshot doc) {
      dados = doc.data() as Map<String, dynamic>;
    },
    onError: (e) => print("Error getting document: $e"),
  );

  casamento.addAll(dados);
}
