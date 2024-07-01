// import 'package:flutter/material.dart';
// import 'package:netvexanh_mobile/models/account.dart';
// import 'package:netvexanh_mobile/services/AccountService.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   List<Account> users = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchUsers();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Rest Api '),
//       ),
//       body: ListView.builder(
//         itemCount: users.length,
//         itemBuilder: (context, index) {
//           final user = users[index];
//           final email = user.email;
//           final color = user.gender == 'male' ? Colors.blue : Colors.green;
//           return ListTile(
//             // leading: ClipRRect(
//             //     borderRadius: BorderRadius.circular(100),
//             //     child: Image.network(imageUrl)),
//             title: Text(email),
//             tileColor: color,
//           );
//         },
//       ),
//     );
//   }

//   Future<void> fetchUsers() async {
//     final response = await AccountService.fetchUsers();
//     int count = response.length;
//     print('count');
//     print('count $count');
//     setState(() {
//       users = response;
//     });
//   }
// }
