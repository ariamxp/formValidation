import 'package:flutter/material.dart';
import 'package:form_validation/src/blocs/provider.dart';
import 'package:form_validation/src/models/producto_model.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final productosBloc = new ProductosBloc();
    productosBloc.cargarProductos();
    
    return Scaffold(
      appBar: AppBar(title: Text('Home Page'),),
      body: _crearListado(productosBloc),
      floatingActionButton: _crearBotonFlotante(context),
    );
  }

  Widget _crearBotonFlotante(BuildContext context) {

    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: ()=> Navigator.pushNamed(context, 'producto'),
      backgroundColor: Theme.of(context).primaryColor,
    );

  }

  Widget _crearListado(ProductosBloc productosBloc){

    return StreamBuilder(
      stream: productosBloc.productosStream ,
      builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot){
        if (snapshot.hasData) {

          final productos = snapshot.data;
          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, i) => _crearItem(context, productosBloc, productos[i]),
          );

        } else {
          return Center(child: CircularProgressIndicator(),);
        }
      },
    );

  }

  Widget _crearItem( BuildContext context, ProductosBloc productosBloc, ProductoModel producto ){
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red
        ),
        onDismissed: ( direcion ){
          productosBloc.borrarProductos(producto.id);
        },
        child: Card(
          child: Column(
            children: <Widget>[
              (producto.fotoUrl == null)
                ? Image(image: AssetImage('assets/img/no-image.png'),)
                : FadeInImage(
                  image: NetworkImage(producto.fotoUrl),
                  placeholder: AssetImage('assets/img/jar-loading.gif'),
                  height: 300.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                ListTile(
                  title: Text('${ producto.titulo } - ${ producto.valor }'),
                  subtitle: Text(producto.id),
                  onTap: () => Navigator.of(context).pushNamed('producto', arguments: producto))
            ],
          ),
        )

    );
  }

}


