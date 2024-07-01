import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:netvexanh_mobile/screens/detail.dart';
import 'package:netvexanh_mobile/services/AccountService.dart';
import 'package:netvexanh_mobile/services/account1.dart';

class AccountListScreen extends StatefulWidget {
  const AccountListScreen({Key? key}) : super(key: key);

  @override
  _AccountListScreenState createState() => _AccountListScreenState();
}

class _AccountListScreenState extends State<AccountListScreen> {
  late Future<List<Account1>> futureAccounts;
  List<Account1> selectedAccounts = [];
  final int maxSelection = 3; // Set your maximum selection limit here

  @override
  void initState() {
    super.initState();
    futureAccounts = AccountService.fetchAccounts();
  }

  void toggleSelection(Account1 account) {
    setState(() {
      if (selectedAccounts.contains(account)) {
        selectedAccounts.remove(account);
      } else if (selectedAccounts.length < maxSelection) {
        selectedAccounts.add(account);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You can select up to $maxSelection items only.'),
          ),
        );
      }
    });
  }

  void goToDetail(Account1 account) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountDetailScreen(account: account),
      ),
    );
  }

  void sendRequest() async {
    // Prepare your request data here
    List<Map<String, dynamic>> requestData = selectedAccounts
        .map((account) => {
              'email': account.email,
              'thumbnail': account.thumbnail,
              // Add other fields you need to send
            })
        .toList();

    // Example of sending JSON data
    final url = Uri.parse('YOUR_API_ENDPOINT'); // Replace with your API endpoint
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(requestData);

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        // Handle successful response
        print('Request successful');
      } else {
        // Handle other response status codes
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error sending request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selected: ${selectedAccounts.length}'),
        actions: [
          IconButton(
            onPressed: sendRequest,
            icon: Icon(Icons.send),
          ),
        ],
      ),
      body: FutureBuilder<List<Account1>>(
        future: futureAccounts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No accounts found'));
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final account = snapshot.data![index];
                final isSelected = selectedAccounts.contains(account);
                return GestureDetector(
                  onTap: () => toggleSelection(account),
                  onLongPress: () => goToDetail(account),
                  child: GridTile(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          account.thumbnail ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error),
                        ),
                        if (isSelected)
                          Container(
                            color: Colors.black54,
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: AccountListScreen(),
  ));
}
