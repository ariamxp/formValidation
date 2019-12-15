import 'package:flutter/material.dart';
import 'package:form_validation/src/blocs/provider.dart';
import 'package:form_validation/src/models/producto_model.dart';
import 'package:form_validation/src/providers/productos_provider.dart';

class HomePage extends StatelessWidget {

  final productoProvider = new ProductosProvider();

  @override
  Widget build(BuildContext context) {

    final bloc = Provider.of(context);
    
    return Scaffold(
      appBar: AppBar(title: Text('Home Page'),),
      body: _crearListado(context),
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

  Widget _crearListado(BuildContext context) {

    return FutureBuilder(
      future: productoProvider.cargarProductos(),
      builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if (snapshot.hasData) {

          final productos = snapshot.data;
          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, i) => _crearItem(context, productos[i]),
          );

        } else {
          return Center(child: CircularProgressIndicator(),);
        }
      },
    );

  }

  Widget _crearItem( BuildContext context, ProductoModel producto ){
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red
        ),
        onDismissed: ( direcion ){
          productoProvider.borrarProducto(producto.id);
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


