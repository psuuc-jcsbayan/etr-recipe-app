import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // Profile Picture and Name Section
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Profile picture
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    'https://i.pinimg.com/736x/9d/31/b5/9d31b5a2954ec3bf706a3e24b3bb0ba2.jpg', // Replace with actual image URL
                  ),
                ),
                SizedBox(height: 12),
                // User name
                Text(
                  "Marie Jean",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                // Status
              ],
            ),
          ),
          const Divider(),
          // Menu Options
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: const Text("Account"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text("About the Developer"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text("Log out"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
