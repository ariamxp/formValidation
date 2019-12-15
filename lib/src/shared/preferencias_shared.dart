import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuarios {
  
  static final PreferenciasUsuarios _instancia = new PreferenciasUsuarios._internal();

  factory PreferenciasUsuarios(){
    return _instancia;
  }

  PreferenciasUsuarios._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  //GET y SET Genero
  get genero{
    return _prefs.getInt('genero') ?? 1;
  }
  set genero (int value){
    _prefs.setInt('genero', value);
  }

  //GET y SET Color Secundario
  get colorSecundario{
    return _prefs.getBool('colorSecundario') ?? false;
  }
  set colorSecundario (bool value){
    _prefs.setBool('colorSecundario', value);
  }

  //GET y SET Nombre
  get token{
    return _prefs.getString('token') ?? '';
  }
  set token (String value){
    _prefs.setString('token', value);
  }

  //GET y SET Ultima Pagina
  get ultimaPagina{
    if (_prefs.getString('token') != null) {
      return 'home';
    } else {
      return 'login';
    }
    
  }

}