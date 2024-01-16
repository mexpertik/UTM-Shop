import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Clasa pentru un meniu pop-up personalizat
class PopUpMenu extends StatelessWidget {
  const PopUpMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Container(
        height: double.infinity, // Înălțimea containerului va ocupa întreaga înălțime disponibilă
        width: MediaQuery.of(context).size.width * 0.7, // Lățimea este 70% din lățimea ecranului
    color: Colors.white, // Culoarea de fundal a meniului
    child: Stack(
    children: [
    Column(
    children: [
    const SizedBox(height: 50), // Spațiu la începutul meniului
    ListTile(
    // Primul element din meniu
    leading: const Icon(Icons.person_2_outlined), // Iconița pentru element
    title: const Text('Profil'), // Textul elementului
    onTap: () {
    // Acțiunea la apăsarea elementului
    Navigator.pop(context); // Închide meniul
    },
    ),
    ListTile(
    // Al doilea element din meniu
    leading: const Icon(Icons.shopping_cart), // Iconița pentru element
    title: const Text('Cos'), // Textul elementului
    onTap: () {
    Navigator.pop(context); // Închide meniul
    },
    ),
    ],
    ),
    Positioned(
    bottom: 0,
    left: 0,
    right: 0,
    // Butonul pentru închiderea aplicației
    child: RawMaterialButton(
    onPressed: () {
    SystemNavigator.pop(); // Închide aplicația
    },
    padding: const EdgeInsets.all(10.0),
    elevation: 2.0,
    fillColor: Colors.red, // Culoarea butonului
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // Forma butonului, fără colțuri rotunjite
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min, // Dimensiunea minimă a rândului
        mainAxisAlignment: MainAxisAlignment.center, // Aliniere la centru
        children: [
          Icon(
            Icons.close, // Iconița de închidere
            size: 20.0,
            color: Colors.white, // Culoarea iconiței
          ),
          SizedBox(width: 10), // Spațiu între iconiță și text
          Text(
            "Close Application", // Textul butonului
            style: TextStyle(
              color: Colors.white, // Culoarea textului
            ),
          ),
        ],
      ),
    ),
    ),
      Positioned(
        right: 0,
        top: 0,
// Butonul pentru închiderea meniului pop-up
        child: RawMaterialButton(
          onPressed: () {
            Navigator.pop(context); // Închide meniul pop-up
          },
          elevation: 2.0,
          child: const Icon(
            FontAwesomeIcons.arrowLeft, // Iconița săgeată spre stânga
            size: 20.0,
          ),
        ),
      ),
    ],
    ),
        ),
    );
  }
}
