import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navBarButton(
            icon: Icons.home_outlined,
            onPressed: () {},
          ),
          _navBarButton(
            icon: Icons.qr_code_2_outlined,
            onPressed: () {},
            iconSize: 40.0,
          ),
          Container(
            padding: const EdgeInsets.only(top: 6.5, right: 8.0, left: 8.0, bottom: 8.0),
            decoration: BoxDecoration(
              color: const Color(0xFF4E0189),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.store, color: Colors.white),
              iconSize: 35.0,
            ),
          ),
          _navBarButton(
            icon: Icons.person,
            onPressed: () {},
          ),
          _navBarButton(
            icon: Icons.view_headline_sharp,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _navBarButton({
    required IconData icon,
    required VoidCallback onPressed,
    double iconSize = 30.0,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.grey[700]),
      splashRadius: 20.0,
      iconSize: iconSize,
    );
  }
}

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10.0,top: 5,bottom: 5),
            child: Text(
              'Account',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Column(
            children: [
              ListTile(
                leading: Icon(Icons.edit), // Icon for Edit Profile
                trailing : Icon(Icons.arrow_right),
                title: Text('Edit Profile'),
                onTap: () {
                  // Navigate to Edit Profile screen or show options
                },
              ),
              ListTile(
                leading: Icon(Icons.lock), // Icon for Privacy & Security
                trailing : Icon(Icons.arrow_right),
                title: Text('Privacy & Security'),
                onTap: () {
                  // Show Privacy & Security options
                },
              ),
              ListTile(
                title: Text('Notifications'),
                leading: Icon(Icons.notifications),
                trailing: Transform.scale(
                  scale: 0.8, // Adjust the scale factor to make the switch bigger or smaller
                  child: Switch(
                    value: _notificationsEnabled,
                    onChanged: (bool value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                    activeColor: Color(0xFF4E0189), // Custom active color
                    inactiveThumbColor: Colors.grey, // Inactive thumb color
                    inactiveTrackColor: Colors.grey.shade300, // Inactive track color
                  ),
                ),
              ),

              ListTile(
                leading: Icon(Icons.language), // Icon for Language
                trailing : Icon(Icons.arrow_right),
                title: Text('Language'),
                onTap: () {
                  // Show Language selection options
                },
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(left: 10.0,top: 5,bottom: 5),
            child: Text(
              'Support & About',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Column(
            children: [
              ListTile(
                leading: Icon(Icons.help_outline),
                trailing : Icon(Icons.arrow_right),
                title: Text('Help & Support'),
                onTap: () {
                  // Show Help & Support options
                },
              ),
              ListTile(
                leading: Icon(Icons.error_outline),
                trailing : Icon(Icons.arrow_right),
                title: Text('Terms and Policies'),
                onTap: () {
                  // Show Terms and Policies
                },
              ),

              ListTile(
                leading: Icon(Icons.logout_outlined),
                trailing : Icon(Icons.arrow_right),
                title: Text('Log Out'),
                onTap: () {
                  // Handle Log Out action
                },
              ),
            ],
          ),

        ],
      ),
    );
  }
}
