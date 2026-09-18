import 'package:flutter/material.dart';
void main() => runApp(const LudoAdmin());
class LudoAdmin extends StatelessWidget {
  const LudoAdmin({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ludo Admin',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
      home: Scaffold(
        appBar: AppBar(title: const Text('LUDO PREMIUM - ADMIN PANEL'), centerTitle: true),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Dashboard Ready ✅', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('Ab isme Firebase connect hoga'),
            const SizedBox(height: 20),
            Card(child: ListTile(title: const Text('Total Users'), subtitle: const Text('Firebase se ayega'), trailing: const Icon(Icons.people), onTap: () {})),
            Card(child: ListTile(title: const Text('Payment Requests'), subtitle: const Text('UPI Approve / Reject'), trailing: const Icon(Icons.payments), onTap: () {})),
            Card(child: ListTile(title: const Text('Withdraw Requests'), subtitle: const Text('Approve karne ke liye'), trailing: const Icon(Icons.money), onTap: () {})),
            const SizedBox(height: 20),
            const Text('Build Success - Ab Firebase ka code jodna baaki hai', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}