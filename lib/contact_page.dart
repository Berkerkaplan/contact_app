import 'package:contact_app/add_contact_page.dart';
import 'package:contact_app/database/db_helper.dart';
import 'package:contact_app/model/contact.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  DbHelper _dbHelper;

  @override
  void initState() {
    _dbHelper = DbHelper();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddContactPage(
                        contact: Contact(),
                      )));
          setState(() {});
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('Phone Book'),
      ),
      body: FutureBuilder(
        future: _dbHelper.getContact(),
        builder: (BuildContext context, AsyncSnapshot<List<Contact>> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          if (snapshot.data.isEmpty) return Text('Your contact list empty');

          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                Contact contact = snapshot.data[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddContactPage(
                                  contact: contact,
                                )));
                  },
                  child: Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection
                        .endToStart, //Sondan başlangıca bir kaydırma yaptık
                    background: Container(
                      alignment: Alignment
                          .centerRight, //Iconun nereye geleceğini belirledik
                      color: Colors.red,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Icon(
                          Icons.delete, //Arkada ki icon
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onDismissed: (direction) async {
                      _dbHelper.removeContact(contact.id);
                      setState(() {
                        // contacts.removeAt(index); silmeyi db üzerinden yaptık.
                      });
                      Scaffold.of(context).showSnackBar(SnackBar(
                        duration: Duration(milliseconds: 500),
                        content: Text('${contact.name} has been deleted'),
                        action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () async {
                            await _dbHelper.insertContact(contact);
                            setState(() {
                              // contacts.add(contact); burada da geri almayı db den yaptık
                            });
                          },
                        ),
                      ));
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(contact.avatar == null
                            ? 'assets/images/person.jpg'
                            : contact.avatar),
                        child: Text(
                          contact.name[0].toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      title: Text(contact.name),
                      subtitle: Text(contact.phoneNumber),
                      trailing: IconButton(
                        icon: Icon(Icons.phone),
                        onPressed: () async {
                          _callContact(contact.phoneNumber);
                        },
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }

  _callContact(String phoneNumber) async {
    String tel = 'tel:$phoneNumber';
    if (await canLaunch(tel)) {
      await launch(tel);
    }
  }
}

//Bu kısım kodumuzun listtile eklenmeden ama aynı işi yaptığı kısım listtile daha az caba ile yaptığımız için listtile kullanyoruz.
/*

Container(
padding: EdgeInsets.all(5.0),
child: Row(
children: [
CircleAvatar(
backgroundImage:
NetworkImage('https://placekitten.com/200/200'),
child: Text(
contact.name[0],
style: TextStyle(
fontWeight: FontWeight.bold,
fontSize: 24,
),
),
),
Padding(
padding: const EdgeInsets.only(left: 8.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: <Widget>[
Text(contact.name),
Text(contact.phoneNumber),
],
),
),
],
),
);


*/
