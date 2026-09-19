import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  String formatDate(dynamic expiry) {
    try {
      DateTime dt;
      if (expiry is Timestamp) dt = expiry.toDate();
      else if (expiry is String) dt = DateTime.parse(expiry);
      else return expiry.toString();
      return "${dt.day.toString().padLeft(2,'0')}-${dt.month.toString().padLeft(2,'0')}-${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2,'0')}";
    } catch (e) {
      return expiry.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('LUDO PREMIUM ADMIN'), backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').orderBy(FieldPath.documentId).snapshots(),
          builder: (context, snap) {
            if (!snap.hasData) return const Center(child: CircularProgressIndicator());
            if (snap.data!.docs.isEmpty) return const Center(child: Text('Koi user nahi hai'));
            return ListView.builder(
              itemCount: snap.data!.docs.length,
              itemBuilder: (context, i) {
                var doc = snap.data!.docs[i];
                var data = doc.data() as Map<String, dynamic>;
                bool isPremium = data['isPremium'] == true;
                
                // Saare fields nikal lo
                String phone = doc.id;
                String upi = data['upi'] ?? data['upiId'] ?? data['UPI'] ?? "UPI nahi diya";
                String name = data['name'] ?? data['email'] ?? "";
                var expiry = data['premiumExpiry'] ?? data['expiry'] ?? "Not set";

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(phone, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(name.isNotEmpty) Text("Name: $name"),
                        Text("UPI: $upi", style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                        Text("Expiry: ${formatDate(expiry)}"),
                      ],
                    ),
                    trailing: Switch(
                      value: isPremium,
                      activeColor: Colors.deepPurple,
                      onChanged: (v) {
                        FirebaseFirestore.instance.collection('users').doc(doc.id).update({
                          'isPremium': v,
                          'premiumExpiry': v ? Timestamp.fromDate(DateTime.now().add(const Duration(days: 30))) : null,
                        });
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}                    },
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
