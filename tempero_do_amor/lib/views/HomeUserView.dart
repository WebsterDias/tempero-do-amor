import 'package:flutter/material.dart';

class HomeUserView extends StatefulWidget {
  const HomeUserView({Key? key}) : super(key: key);

  @override
  State<HomeUserView> createState() => _HomeUserViewState();
}

class _HomeUserViewState extends State<HomeUserView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tempero Do Amor"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Bem Vindo!",
                    style: TextStyle(
                      fontSize: 35,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => {
                      Navigator.pushNamed(context, "/proximos_casamentos_view"),
                    },
                    child: const Text(
                      "Ver próximos casamentos",
                      style: TextStyle(),
                    ),
                  ), //Icon(Icons.login)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
