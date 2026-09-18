import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const LudoAdmin());
}

class LudoAdmin extends StatelessWidget {
  const LudoAdmin({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('LUDO PREMIUM ADMIN'), centerTitle: true, backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('withdrawals').orderBy('timestamp', descending: true).snapshots(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            if (!snap.hasData || snap.data!.docs.isEmpty) {
              return const Center(child: Text('Koi withdraw request nahi hai\nGame se withdraw hoga to yaha UPI ID dikhega', textAlign: TextAlign.center));
            }
            return ListView(
              padding: const EdgeInsets.all(12),
              children: snap.data!.docs.map((doc) {
                var d = doc.data() as Map<String, dynamic>;
                return Card(
                  child: ListTile(
                    title: Text("₹${d['amount'] ?? '0'} - ${d['status'] ?? 'pending'}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("UPI: ${d['upiId'] ?? d['upi'] ?? 'N/A'}\nReferral: ${d['referralCode'] ?? ''}\nUser: ${d['userId'] ?? doc.id}"),
                    isThreeLine: true,
                    trailing: Wrap(children: [
                      IconButton(icon: const Icon(Icons.check, color: Colors.green), onPressed: ()=> doc.reference.update({'status':'approved'})),
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