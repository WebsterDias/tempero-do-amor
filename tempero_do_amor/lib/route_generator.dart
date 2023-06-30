import 'package:flutter/material.dart';
import 'package:tempero_do_amor/views/AgendarCasamentoView.dart';
import 'package:tempero_do_amor/views/CadastrarEntradaView.dart';
import 'package:tempero_do_amor/views/CadastrarPratoView.dart';
import 'package:tempero_do_amor/views/ListarCardapiosView.dart';
import 'package:tempero_do_amor/views/ListarCasamentosView.dart';
import 'package:tempero_do_amor/views/ListarEntradasView.dart';
import 'package:tempero_do_amor/views/ListarPratosView.dart';
import 'package:tempero_do_amor/views/LoginView.dart';
import 'package:tempero_do_amor/views/ProximosCasamentosView.dart';
import 'package:tempero_do_amor/views/HomeAdminView.dart';
import 'package:tempero_do_amor/views/HomeUserView.dart';

import 'views/CadastrarCardapioView.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {

    final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => const LoginView());

      case "/proximos_casamentos_view":
        return MaterialPageRoute(
            builder: (_) => const ProximosCasamentosView());

      case "/cadastrar_prato_view":
        return MaterialPageRoute(builder: (_) => const CadastrarPratoView());

      case "/cadastrar_entrada_view":
        return MaterialPageRoute(builder: (_) => const CadastrarEntradaView());

      case "/cadastrar_casamento_view":
        return MaterialPageRoute(builder: (_) => const CadastrarCasamentoView());

      case "/cadastrar_cardapio_view":
        return MaterialPageRoute(builder: (_) => const CadastrarCardapioView());

      case "/home_admin_view":
        return MaterialPageRoute(builder: (_) => const HomeAdminView());

      case "/home_user_view":
        return MaterialPageRoute(builder: (_) => const HomeUserView());
      
      case "/listar_entradas":
        return MaterialPageRoute(builder: (_) => const ListarEntradasView());
      
      case "/listar_casamentos":
        return MaterialPageRoute(builder: (_) => const ListarCasamentosView());
      
      case "/listar_pratos":
        return MaterialPageRoute(builder: (_) => const ListarPratosView());
      
      case "/listar_cardapios":
        return MaterialPageRoute(builder: (_) => const ListarCardapiosView());
      
      default:
        _erroRota();
    }

    throw '';
  }

  static Route<dynamic> _erroRota() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Erro Rota"),
        ),
        body: const Text("Tela não encontada!"),
      );
    });
  }
}
