class Contact {
  int id;
  String name;
  String phoneNumber;
  String avatar;

  Contact({this.name, this.phoneNumber, this.avatar});

  // , this.id
  // static List<Contact> contacts = [
  //   Contact(name: 'Ali', phoneNumber: '0555 555 55 55', avatar: ''),
  //   Contact(name: 'Berk', phoneNumber: '0555 555 55 55', avatar: ''),
  //   Contact(name: 'Ayşe', phoneNumber: '0555 555 55 55', avatar: ''),
  //   Contact(name: 'Fatma', phoneNumber: '0555 555 55 55', avatar: ''),
  //   Contact(name: 'Busra', phoneNumber: '0555 555 55 55', avatar: ''),
  //   Contact(name: 'Kübra', phoneNumber: '0555 555 55 55', avatar: ''),
  //   Contact(name: 'Osman', phoneNumber: '0555 555 55 55', avatar: ''),
  //   Contact(name: 'Sema', phoneNumber: '0555 555 55 55', avatar: ''),
  //   Contact(name: 'Omer', phoneNumber: '0555 555 55 55', avatar: ''),
  // ];

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['name'] = name;
    map['phone_number'] = phoneNumber;
    map['avatar'] = avatar;

    return map;
  }

  Contact.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    phoneNumber = map['phone_number'];
    avatar = map['avatar'];
    id = map['id'];
  }
}
