import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(home: AdminPage()));
}

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('LUDO PREMIUM ADMIN'), backgroundColor: Colors.deepPurple),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          var docs = snapshot.data!.docs;
          if (docs.isEmpty) return Center(child: Text('Koi user nahi hai'));
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) {
              var data = docs[i].data() as Map<String, dynamic>;
              bool isPremium = data['isPremium']?? false;
              return ListTile(
                title: Text(data['email']?? data['uid']?? 'User'),
                subtitle: Text('Premium Expiry: ${data['premiumExpiry']?? "Not set"}'),
                trailing: Switch(
                  value: isPremium,
                  onChanged: (val) {
                    FirebaseFirestore.instance.collection('users').doc(docs[i].id).update({
                      'isPremium': val,
                      'premiumExpiry': val? DateTime.now().add(Duration(days: 30)).toString() : null,
                    });
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}                      IconButton(icon: const Icon(Icons.check, color: Colors.green), onPressed: ()=> doc.reference.update({'status':'approved'})),
                      IconButton(icon: const Icon(Icons.close, color: Colors.red), onPressed: ()=> doc.reference.update({'status':'rejected'})),
                    ]),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
