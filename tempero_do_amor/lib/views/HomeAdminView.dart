import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tempero_do_amor/presentation/my_flutter_app_icons.dart';

class HomeAdminView extends StatefulWidget {
  const HomeAdminView({Key? key}) : super(key: key);

  @override
  State<HomeAdminView> createState() => _HomeAdminViewState();
}

class _HomeAdminViewState extends State<HomeAdminView> {
  
  var tamanho = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 60,
                    bottom: 60,
                  ),
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(95)
                    ),
                    child: const Image(
                      image: ResizeImage(AssetImage('assets/images/logo_dark.png'), width: 95, height: 95),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey,
                      )
                    )
                  ),
                ),
                ListTile(
                  leading: const Icon(MyFlutterApp.aliancas_de_casamento),
                  title: const Text("Casamentos"),
                  onTap: () => {
                    Navigator.pushNamed(context, "/listar_casamentos"),
                  },
                ),
                ListTile(
                  leading: const Icon(MyFlutterApp.talheres),
                  title: const Text("Pratos"),
                  onTap: () => {
                    Navigator.pushNamed(context, "/listar_pratos"),
                  },
                ),
                ListTile(
                  leading: const Icon(MyFlutterApp.aperitivo),
                  title: const Text("Entradas"),
                  onTap: () => {
                    Navigator.pushNamed(context, "/listar_entradas"),
                  },
                ),
                ListTile(
                  leading: const Icon(MyFlutterApp.cardapio),
                  title: const Text("Cardápios"),
                  onTap: () => {
                    Navigator.pushNamed(context, "/listar_cardapios"),
                  },
                ),
              ],
            ),
            Column(
              children: [
                ListTile(
                  leading: const Icon(MyFlutterApp.saida),
                  title: const Text("Sair"),
                  onTap: () => {
                    Navigator.pushNamed(context, "/"),
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Bem vindo!"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text("\nPróximos casamentos"),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("casamentos").snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if(snapshot.hasData) {
                  final snap = snapshot.data!.docs;
                  
                  snap.length >= 5 ? tamanho = 5 : tamanho = snap.length;
                  
                  return ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: tamanho, 
                    itemBuilder: (context, index){
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Stack(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                child: Column(
                                  children: [
                                    Text(
                                    snap[index].id,
                                  ),
                                  ],
                                ),
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
    );
  }
}
