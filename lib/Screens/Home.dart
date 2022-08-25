import 'package:flutter/material.dart';
import 'AddItems.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Post", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
        centerTitle: true,

      ),
      body: ListView(
        children: [
            Card(
              child: ListTile(
                leading: CircleAvatar(),
                title: Text("dsd"),
                subtitle: Text("swdx"),
              ),
            )
          ]
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddItemsScreen()));

            },
          child: Icon(Icons.add, size: 20,),

      ),
    );
  }
}
