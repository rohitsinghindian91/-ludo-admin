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
    if (d == null) return "Not set";
    try {
      DateTime dt;
      if (d is Timestamp) dt = d.toDate();
      else if (d is String) dt = DateTime.parse(d);
      else return d.toString();
      return "${dt.day.toString().padLeft(2,'0')}-${dt.month.toString().padLeft(2,'0')}-${dt.year}";
    } catch (e) {
      return d.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('LUDO PREMIUM ADMIN'),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snap) {
            if (!snap.hasData) return const Center(child: CircularProgressIndicator());
            if (snap.data!.docs.isEmpty) return const Center(child: Text('Koi user nahi hai'));
            return ListView(
              children: snap.data!.docs.map((doc) {
                var data = doc.data() as Map<String, dynamic>;
                bool isPremium = data['isPremium'] == true;
                String phone = doc.id;
                String upi = data['upi'] ?? data['upiId'] ?? data['UPI'] ?? data['upi_id'] ?? "No UPI";
                var expiry = data['premiumExpiry'] ?? data['expiry'];

                return Card(
                  margin: const EdgeInsets.all(6),
                  child: ListTile(
                    title: Text(phone, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("UPI: $upi", style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                        Text("Expiry: ${formatDate(expiry)}"),
                      ],
                    ),
                    trailing: Switch(
                      value: isPremium,
                      activeColor: Colors.deepPurple,
                      onChanged: (v) async {
                        var newExpiry = v ? Timestamp.fromDate(DateTime.now().add(const Duration(days: 30))) : null;
                        // Saare possible naam se update kar raha hu taki Ludo App pakka unlock ho jaye
                        await FirebaseFirestore.instance.collection('users').doc(doc.id).update({
                          'isPremium': v,
                          'premium': v,
                          'isPremiumActive': v,
                          'is_premium': v,
                          'premiumExpiry': newExpiry,
                          'expiryDate': newExpiry,
                          'premium_expiry': newExpiry,
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
