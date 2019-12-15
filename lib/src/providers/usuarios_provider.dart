import 'dart:convert';

import 'package:form_validation/src/shared/preferencias_shared.dart';
import 'package:http/http.dart' as http;

class UsuarioProvider {

  final String _firebaseToken = 'AIzaSyDlUR9mzUqczLaAwUUBDYFaI8Kas6dfSAE';
  final _prefs = new PreferenciasUsuarios();

  Future<Map<String, dynamic>> nuevoUsuario( String email, String password) async{

    final authData = {
      'email'             : email,
      'password'          : password,
      'returnSecureTpken' : true
    };

    final _url = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken';
    final resp = await http.post(
                        _url,
                        body: json.encode(authData)
                        );

    Map<String, dynamic> decodeResp = json.decode(resp.body);

    print(decodeResp);
    if (decodeResp.containsKey('idToken')) {
      _prefs.token = decodeResp['idToken'];
      return { 'ok': true, 'token': decodeResp['idToken'] };
    } else {
      return { 'ok': false, 'mensaje': decodeResp['error']['message'] };
    }

  }


  Future<Map<String, dynamic>> loginUsuario( String email, String password) async{

    final authData = {
      'email'             : email,
      'password'          : password,
      'returnSecureTpken' : true
    };

    final _url = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken';
    final resp = await http.post(
                        _url,
                        body: json.encode(authData)
                        );

    Map<String, dynamic> decodeResp = json.decode(resp.body);

    print(decodeResp);
    if (decodeResp.containsKey('idToken')) {
      _prefs.token = decodeResp['idToken'];
      return { 'ok': true, 'token': decodeResp['idToken'] };
    } else {
      return { 'ok': false, 'mensaje': decodeResp['error']['message'] };
    }

  }
  
}