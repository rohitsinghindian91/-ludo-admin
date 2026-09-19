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
        appBar: AppBar(title: const Text('LUDO PREMIUM ADMIN'), backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snap) {
            if (!snap.hasData) return const Center(child: CircularProgressIndicator());
            return ListView(
              children: snap.data!.docs.map((doc) {
                var data = doc.data() as Map<String, dynamic>;
                bool isPremium = data['isPremium'] == true;
                String phone = doc.id;
                String upi = data['upi'] ?? data['upiId'] ?? "No UPI";
                String pass = data['password'] ?? data['pass'] ?? "No Pass";
                String myCode = data['referralCode'] ?? data['myReferralCode'] ?? data['referCode'] ?? "No Code";
                // Ye wala usne register karte time dala tha
                String usedCode = data['usedReferralCode'] ?? data['referredBy'] ?? data['referBy'] ?? data['appliedReferral'] ?? data['referralBy'] ?? data['parentCode'] ?? "Kisi ka nahi dala";

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(phone, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("UPI: $upi", style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                        Text("Pass: $pass"),
                        Text("Uska Code: $myCode", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                        Text("Use Kiya: $usedCode", style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                        Text("Expiry: ${formatDate(data['premiumExpiry'] ?? data['expiry'])}", style: const TextStyle(color: Colors.red)),
                      ],
                    ),
                    trailing: Switch(
                      value: isPremium,
                      activeColor: Colors.deepPurple,
                      onChanged: (v) async {
                        var newExpiry = v ? Timestamp.fromDate(DateTime.now().add(const Duration(days: 30))) : null;
                        await FirebaseFirestore.instance.collection('users').doc(doc.id).update({
                          'isPremium': v, 'premium': v, 'isPremiumActive': v,
                          'premiumExpiry': newExpiry, 'expiryDate': newExpiry,
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
}        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snap) {
            if (!snap.hasData) return const Center(child: CircularProgressIndicator());
            return ListView(
              children: snap.data!.docs.map((doc) {
                var data = doc.data() as Map<String, dynamic>;
                bool isPremium = data['isPremium'] == true;
                
                String phone = doc.id;
                String upi = data['upi'] ?? data['upiId'] ?? data['UPI'] ?? "No UPI";
                String pass = data['password'] ?? data['pass'] ?? data['pwd'] ?? "No Pass";
                String referral = data['referralCode'] ?? data['referCode'] ?? data['myReferralCode'] ?? data['referral'] ?? "No Code";
                var expiry = data['premiumExpiry'] ?? data['expiry'];

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(phone, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text("UPI: $upi", style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                        Text("Pass: $pass", style: const TextStyle(color: Colors.black87)),
                        Text("Refer Code: $referral", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                        Text("Expiry: ${formatDate(expiry)}", style: const TextStyle(color: Colors.red)),
                      ],
                    ),
                    trailing: Switch(
                      value: isPremium,
                      activeColor: Colors.deepPurple,
                      onChanged: (v) async {
                        var newExpiry = v ? Timestamp.fromDate(DateTime.now().add(const Duration(days: 30))) : null;
                        await FirebaseFirestore.instance.collection('users').doc(doc.id).update({
                          'isPremium': v,
                          'premium': v,
                          'isPremiumActive': v,
                          'premiumExpiry': newExpiry,
                          'expiryDate': newExpiry,
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
