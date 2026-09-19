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

  String formatDate(dynamic d) {
    try {
      if (d is Timestamp) {
        var dt = d.toDate();
        return "${dt.day}-${dt.month}-${dt.year}";
      }
      if (d is String) {
        var dt = DateTime.parse(d);
        return "${dt.day}-${dt.month}-${dt.year}";
      }
      return d.toString();
    } catch (e) {
      return d.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('LUDO PREMIUM ADMIN'), backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snap) {
            if (!snap.hasData) return Center(child: CircularProgressIndicator());
            return ListView(
              children: snap.data!.docs.map((doc) {
                var data = doc.data() as Map<String, dynamic>;
                bool isPremium = data['isPremium'] == true;
                String phone = doc.id;
                String upi = data['upi'] ?? data['upiId'] ?? data['UPI'] ?? "No UPI";
                var expiry = data['premiumExpiry'] ?? data['expiry'];
                return Card(
                  margin: EdgeInsets.all(6),
                  child: ListTile(
                    title: Text(phone, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("UPI: $upi", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                        Text("Expiry: ${expiry == null ? 'Not set' : formatDate(expiry)}"),
                      ],
                    ),
                    trailing: Switch(
                      value: isPremium,
                      onChanged: (v) {
                        FirebaseFirestore.instance.collection('users').doc(doc.id).update({
                          'isPremium': v,
                          'premiumExpiry': v ? Timestamp.now() : null,
                        });
                      },
                    ),
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
