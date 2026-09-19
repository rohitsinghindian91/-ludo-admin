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

  String getDate(dynamic d) {
    if (d == null) return "Not set";
    try {
      if (d is Timestamp) {
        var t = d.toDate();
        return "${t.day}-${t.month}-${t.year}";
      }
      return d.toString();
    } catch (e) {
      return d.toString();
    }
  }

  String getVal(Map<String, dynamic> data, List<String> keys, String def) {
    for (var k in keys) {
      if (data.containsKey(k) && data[k] != null && data[k].toString().isNotEmpty) {
        return data[k].toString();
      }
    }
    return def;
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
            return ListView.builder(
              itemCount: snap.data!.docs.length,
              itemBuilder: (context, index) {
                var doc = snap.data!.docs[index];
                var data = doc.data() as Map<String, dynamic>;
                bool isPremium = data['isPremium'] == true;

                String phone = doc.id;
                String upi = getVal(data, ['upi', 'upiId', 'UPI'], 'No UPI');
                String pass = getVal(data, ['password', 'pass', 'pwd'], 'No Pass');
                String myCode = getVal(data, ['referralCode', 'myReferralCode', 'referCode'], 'No Code');
                String usedCode = getVal(data, ['usedReferralCode', 'referredBy', 'referBy', 'appliedReferral', 'referralBy', 'parentCode', 'usedCode'], 'Kisi ka nahi');
                String expiry = getDate(data['premiumExpiry']);

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(phone, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("UPI: $upi", style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                        Text("Pass: $pass"),
                        Text("Uska Code: $myCode", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                        Text("Use Kiya: $usedCode", style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                        Text("Expiry: $expiry", style: const TextStyle(color: Colors.red)),
                      ],
                    ),
                    trailing: Switch(
                      value: isPremium,
                      onChanged: (v) async {
                        var newExpiry = v ? Timestamp.fromDate(DateTime.now().add(const Duration(days: 30))) : null;
                        await FirebaseFirestore.instance.collection('users').doc(doc.id).update({
                          'isPremium': v,
                          'premiumExpiry': newExpiry,
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
}
