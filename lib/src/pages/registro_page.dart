import 'package:flutter/material.dart';
import 'package:form_validation/src/blocs/provider.dart';
import 'package:form_validation/src/providers/usuarios_provider.dart';
import 'package:form_validation/src/utils/utils.dart';

class RegistroPage extends StatelessWidget {

  final userProvider = new UsuarioProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Stack(
         children: <Widget>[
           _crearFondo(context),
           _loginForm(context)
         ],
       ),
    );
  }

  _registro(LoginBloc bloc, BuildContext context) async{

    Map info = await userProvider.loginUsuario(bloc.email, bloc.password);
    if (info['ok']) {
      Navigator.pushReplacementNamed(context, 'home');
    }else{
      mostrarAlerta(context, info['mensaje']);
    }

  }

  Widget _crearFondo( BuildContext context ) {

    final size = MediaQuery.of(context).size;

    final fondoModaro = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color> [Color.fromRGBO(62, 62, 156, 1.0), Color.fromRGBO(90, 70, 178, 1.0)]
        )
      ),
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.05),
      ),
    );

    final logo = Container(
      padding: EdgeInsets.only(top: 80.0),
      child: Column(
        children: <Widget>[
          Icon( Icons.person_pin_circle, color: Colors.white, size: 100.0, ),
          SizedBox(height: 10.0, width: double.infinity,),
          Text('Ariam Blanco', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30.0, color: Colors.white),)
        ],
      ),
    );

    return Stack(
      children: <Widget>[
        fondoModaro,
        Positioned( top: 90.0, left: 40.0, child: circulo, ),
        Positioned( top: -20.0, right: -30.0, child: circulo, ),
        Positioned( bottom: -40.0, right: -10.0, child: circulo, ),
        Positioned( bottom: -10.0, left: -10.0, child: circulo, ),
        logo,
      ],
    );

  }

  Widget _loginForm( BuildContext context ) {

    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              height: 180.0,
            ),
          ),
          Container(
            width: size.width * 0.85,
            padding: EdgeInsets.symmetric(vertical: 50.0),
            margin: EdgeInsets.symmetric(vertical: 30.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 3.0),
                  spreadRadius: 1.0
                )
              ]
            ),
            child: Column(
              children: <Widget>[
                Text('Registro', style: TextStyle(fontSize: 20.0),),
                SizedBox(height: 40.0,),
                _crearEmail( bloc ),
                SizedBox(height: 20.0,),
                _crearPassword( bloc ),
                SizedBox(height: 20.0,),
                _crearBoton( bloc )
              ],
            ),
          ),
          FlatButton(
            child: Text('Ya tengo una cuenta'),
            onPressed: ()=> Navigator.pushReplacementNamed(context, 'login'),
            ),
          SizedBox( height: 100.0 ,)
        ],
      ),
    );
  }

  Widget _crearEmail( LoginBloc bloc ) {

    return StreamBuilder(
      stream: bloc.emailStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(Icons.alternate_email, color: Colors.deepPurple,),
              hintText: 'ejemplo@correo.com',
              labelText: 'Correo electrónico',
              counterText: snapshot.data,
              errorText: snapshot.error
            ),
            onChanged: bloc.changeEmail,
          ),
        );
      },
    );

    
  }

  Widget _crearPassword( LoginBloc bloc ) {

    return StreamBuilder(
      stream: bloc.passwordStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              icon: Icon(Icons.lock, color: Colors.deepPurple,),
              hintText: '******',
              labelText: 'Contraseña',
              labelStyle: TextStyle(color: Colors.deepPurple),
              counterText: snapshot.data,
              errorText: snapshot.error
            ),
            onChanged: bloc.changePassword,
          ),
        );
      },
    );

  }

  Widget _crearBoton( LoginBloc bloc) {

    return StreamBuilder(
      stream: bloc.formValidStream,
      initialData: null ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            child: Text('Ingresar')
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0)
            ),
            elevation: 0.0,
            color: Colors.deepPurple,
            textColor: Colors.white,
          onPressed: snapshot.hasData ? ()=> _registro(bloc, context) : null,
        );
      },
    );

    
  }
}