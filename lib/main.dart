import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: AdminHome()));
}

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});
  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int tab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tab==0 ? "Withdraw - Paisa Bhejna" : "All Users"), backgroundColor: Colors.black, foregroundColor: Colors.white),
      body: tab==0 ? WithdrawTab() : UsersTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tab,
        onTap: (i)=>setState(()=>tab=i),
        items: const [BottomNavigationBarItem(icon: Icon(Icons.money), label: "Withdraw"), BottomNavigationBarItem(icon: Icon(Icons.people), label: "Users")],
      ),
    );
  }
}

class WithdrawTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("withdraw_requests").where("status", isEqualTo: "pending").snapshots(),
      builder: (c, snap) {
        if(!snap.hasData) return const Center(child: CircularProgressIndicator());
        if(snap.data!.docs.isEmpty) return const Center(child: Text("Koi request nahi"));
        return ListView(children: snap.data!.docs.map((d){
          var data = d.data() as Map<String,dynamic>;
          return Card(margin: const EdgeInsets.all(8), child: ListTile(
            title: Text("Rs.${data['amount']} -> ${data['upi']}", style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("Phone: ${data['phone']}\nUPI: ${data['upi']}"),
            isThreeLine: true,
            trailing: ElevatedButton(onPressed: () async {
              await FirebaseFirestore.instance.collection("withdraw_requests").doc(d.id).update({"status":"paid"});
            }, child: const Text("PAID")),
          ));
        }).toList());
      },
    );
  }
}

class UsersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("users").snapshots(),
      builder: (c, snap) {
        if(!snap.hasData) return const Center(child: CircularProgressIndicator());
        return ListView(children: snap.data!.docs.map((d){
          var data = d.data() as Map<String,dynamic>;
          return ListTile(title: Text("${data['phone']} - Rs.${data['wallet']??0}"), subtitle: Text("Code: ${data['myReferralCode']}"));
        }).toList());
      },
    );
  }
}
