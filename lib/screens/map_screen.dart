// import 'package:flutter/material.dart';

// class MapScreen extends StatelessWidget {
//   const MapScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var mapUrl = "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png";
//     var marker = Marker(
//       width: 50.0,
//       height: 50.0,
//       point: location,
//       child: CircleAvatar(
//           backgroundColor: Colors.white.withOpacity(0.1),
//           child: Image.asset('assets/marker.png')),
//     );
//     return Scaffold(
//       body: FlutterMap(
//         options: MapOptions(
//             initialCenter: location, maxZoom: 30, minZoom: 2, initialZoom: 15),
//         children: [
//           TileLayer(urlTemplate: mapUrl),
//           MarkerLayer(markers: [marker]),
//         ],
//       ),
//     );
//   }
// }
