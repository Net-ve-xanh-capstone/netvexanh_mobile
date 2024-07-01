import 'package:flutter/material.dart';
import 'package:netvexanh_mobile/services/account1.dart';

class AccountDetailScreen extends StatelessWidget {
  final Account1 account;

  const AccountDetailScreen({Key? key, required this.account}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(account.email ?? 'Account Detail'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            account.thumbnail != null
                ? Image.network(account.thumbnail!)
                : const Icon(Icons.person, size: 100),
            const SizedBox(height: 20),
            Text(account.email ?? 'No email', style: const TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
