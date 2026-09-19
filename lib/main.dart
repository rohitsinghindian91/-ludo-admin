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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('LUDO PREMIUM ADMIN'), backgroundColor: Colors.deepPurple),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snap) {
            if (!snap.hasData) return const Center(child: CircularProgressIndicator());
            if (snap.data!.docs.isEmpty) return const Center(child: Text('Koi user nahi hai'));
            return ListView(
              children: snap.data!.docs.map((doc) {
                var data = doc.data() as Map<String, dynamic>;
                bool isPremium = data['isPremium'] == true;
                return ListTile(
                  title: Text(data['email'] ?? doc.id),
                  subtitle: Text('Expiry: ${data['premiumExpiry'] ?? "Not set"}'),
                  trailing: Switch(
                    value: isPremium,
                    onChanged: (v) {
                      FirebaseFirestore.instance.collection('users').doc(doc.id).update({
                        'isPremium': v,
                        'premiumExpiry': v ? DateTime.now().add(const Duration(days: 30)).toIso8601String() : null,
                      });
                    },
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
