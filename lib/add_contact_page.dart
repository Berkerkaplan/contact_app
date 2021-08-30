import 'package:contact_app/database/db_helper.dart';
import 'package:contact_app/model/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AddContactPage extends StatelessWidget {
  final Contact contact;

  const AddContactPage({Key key, this.contact}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contact.id == null ? 'Add New Contact' : contact.name),
      ),
      body: SingleChildScrollView(
          child: ContactForm(contact: contact, child: AddContactForm())),
    );
  }
}

class ContactForm extends InheritedWidget {
  final Contact contact;

  ContactForm({Key key, Widget child, this.contact})
      : super(key: key, child: child);

  static ContactForm of(BuildContext context) {
    // return context.inheritFromWidgetOfExactType(ContactForm);

    return context.dependOnInheritedWidgetOfExactType();
  }

  @override
  bool updateShouldNotify(ContactForm oldWidget) {
    return contact.id != oldWidget.contact.id;
  }
}

class AddContactForm extends StatefulWidget {
  @override
  _AddContactFormState createState() => _AddContactFormState();
}

class _AddContactFormState extends State<AddContactForm> {
  final _formKey = GlobalKey<FormState>();

  DbHelper _dbHelper;

  @override
  void initState() {
    _dbHelper = DbHelper();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Contact contact = ContactForm.of(context).contact;

    return Column(
      children: <Widget>[
        Stack(
          children: [
            Image.asset(
              contact.avatar == null
                  ? 'assets/images/person.jpg'
                  : contact.avatar,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 250.0,
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: getFile,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0), //horizantol :8
                  child: TextFormField(
                    initialValue: contact.name,
                    decoration: InputDecoration(
                      hintText: 'Contact Name',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Name Required";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      contact.name = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0), //, horizontal: 8.0
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    initialValue: contact.phoneNumber,
                    decoration: InputDecoration(
                      hintText: 'Phone Number',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Phone Number Required';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      contact.phoneNumber = value;
                    },
                  ),
                ),
                RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text(
                    'Submit',
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();

                      if (contact.id == null) {
                        await _dbHelper.insertContact(contact);
                      } else {
                        await _dbHelper.updateContact(contact);
                      }

                      await _dbHelper.insertContact(contact);

                      var snackBar = Scaffold.of(context).showSnackBar(SnackBar(
                          duration: Duration(milliseconds: 500),
                          content: Text('${contact.name} has been saved')));

                      snackBar.closed.then(
                        (value) => Navigator.pop(context),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void getFile() async {
    Contact contact = ContactForm.of(context).contact;

    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      // _file = image;
      contact.avatar = image.path;
    });

    // Contact contact = ContactForm.of(context).contact;
    // var image = await ImagePicker.pickImage(source: ImageSource.camera);
    // setState(() {
    //   contact.avatar = path.String();
    // });
  }
}
