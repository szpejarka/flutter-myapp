import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

final dummySnapshot = [
 {"name": "Filip", "votes": 15},
 {"name": "Abraham", "votes": 14},
 {"name": "Richard", "votes": 11},
 {"name": "Ike", "votes": 10},
 {"name": "Justin", "votes": 1},
];

class MyApp extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     title: 'Baby Names',
     home: MyHomePage(),
   );
 }
}

class MyHomePage extends StatefulWidget {
 @override
 _MyHomePageState createState() {
   return _MyHomePageState();
 }
}

class _MyHomePageState extends State<MyHomePage> {
 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(title: Text('Skałki')),
     body: _buildBody(context),
   );
 }

Widget _buildBody(BuildContext context) {
 return StreamBuilder<QuerySnapshot>(
   stream: Firestore.instance.collection('rocks').snapshots(),
   builder: (context, snapshot) {
     if (!snapshot.hasData) return LinearProgressIndicator();

     return _buildList(context, snapshot.data.documents);
   },
 );
}

 Widget _buildList(BuildContext context,  List<DocumentSnapshot> snapshot) {
   return ListView(
     //padding: const EdgeInflutters.only(top: 20.0),
     children: snapshot.map((data) => _buildListItem(context, data)).toList(),
   );
 }

Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
 final record = Record.fromSnapshot(data);

   return Padding(
     key: ValueKey(record.name),
     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
     child: Container(
       decoration: BoxDecoration(
         border: Border.all(color: Colors.grey),
         borderRadius: BorderRadius.circular(5.0),
       ),
       child: ListTile(
         title: Text(record.name),
         trailing: Text(record.address.toString()),
         onTap: () {  
           _navigate(record);
         }
       ),
     ),
   );
 }

 _navigate(Record record) async {
    var newRecord = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditRecord(record: record)),
    );
    record.reference.updateData(newRecord);
 }

}

class Record {
 final String name;
 final String address;
 final DocumentReference reference;

 Record.fromMap(Map<String, dynamic> map, {this.reference})
     : assert(map['nazwa'] != null),
       assert(map['adres'] != null),
       name = map['nazwa'],
       address = map['adres'];

 Record.fromSnapshot(DocumentSnapshot snapshot)
     : this.fromMap(snapshot.data, reference: snapshot.reference);

 @override
 String toString() => "Record<$name:$address>";
}

class EditRecord extends StatelessWidget {
  final Record record;

   EditRecord({Key key, @required this.record}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Skałka"),
      ),
      body: Center(
        child: Column( 
          children: <Widget>[
            RecordPage(record: this.record),
            RaisedButton(
              onPressed: () {
                Navigator.pop(context, {name:"dupa",adres:"dupaa"});
              },
              child: Text("Save")
            )
          ]
        )
      )
    );
  }
}
class RecordState extends State<RecordPage> {
  final Record record;

  RecordState({@required this.record});
  @override
  Widget build(BuildContext context){
    return Column(
      children: <Widget>[
        Text("Nazwa"),
        TextField(
          controller: TextEditingController(text: this.record.name),         
          
        ),
        Text("Adres"),
        TextField(
          controller: TextEditingController(text: this.record.address),         
        )
      ],
    );
  }
}
class RecordPage extends StatefulWidget {
  final Record record;
  RecordPage({Key key, @required this.record}) : super(key: key);
  @override
  RecordState createState() {
      return RecordState(record: this.record);
  }
}