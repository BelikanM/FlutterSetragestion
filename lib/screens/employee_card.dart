import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EmployeeCard extends StatelessWidget {
  final String name;
  final String position;

  const EmployeeCard({super.key, required this.name, required this.position});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(8),
      child: ListTile(
        leading: FaIcon(FontAwesomeIcons.user, size: 32, color: Colors.blue),
        title: Text(name),
        subtitle: Text(position),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
