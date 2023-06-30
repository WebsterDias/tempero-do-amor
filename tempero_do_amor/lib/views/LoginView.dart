import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

var valUs = false;
var tipoUs = 0;

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginView();
}

class _LoginView extends State<LoginView> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController usController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Entrar"),
        automaticallyImplyLeading: false,
      ),
      body: Form(
        key: _formkey,
        child: Container(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: const Image(
                        image: AssetImage(
                        'assets/images/logo_transparent.png'
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                    SizedBox(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: usController,
                            decoration: const InputDecoration(
                              labelText: "E-mail",
                            ),
                          ),
                          TextFormField(
                            controller: pwController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: "Senha",
                            ),
                          ),
                          const SizedBox(height: 40),
                          ElevatedButton (
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              )
                            ),
                            onPressed: () async {
                              if (usController.text.isEmpty) {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Campo \"E-mail\" vazio"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              Navigator.pop(context);
                                            });
                                          },
                                          child: const Text("Fechar"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else if (pwController.text.isEmpty) {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Campo \"Senha\" vazio"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              Navigator.pop(context);
                                            });
                                          },
                                          child: const Text("Fechar"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                await validUser(usController.text, pwController.text);
              
                                if(valUs == true){
                                  if(tipoUs == 0) {
                                    Navigator.pushNamed(context, "/home_user_view");
                                  }
                                  else Navigator.pushNamed(context, "/home_admin_view");
                                  usController.text = "";
                                  pwController.text = "";
                                  valUs = false;
                                } else {
                                  // ignore: use_build_context_synchronously
                                  showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("E-mail ou senha inválidos"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              Navigator.pop(context);
                                            });
                                          },
                                          child: const Text("Fechar"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                }
                              }
                              
                            },
                            child: const Text("Entrar"),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
            ),
          ),
        ),
      ),
    );
  }
}

Future validUser(usController, pwController) async {
  await FirebaseFirestore.instance.collection("usuarios").get().then((value) {
      for (var i = 0; i < value.docs.length; i++) {
        if(value.docs[i].data().values.elementAt(1) == usController){
          if(value.docs[i].data().values.first == pwController) {
            valUs = true;
            tipoUs = int.parse(value.docs[i].data().values.last);
          }
        }
      }
    }
  );
}