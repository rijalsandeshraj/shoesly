import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../constants/colors.dart';
import '../constants/text_styles.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    required this.latLng,
  });

  final LatLng latLng;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String mapUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  final MapController mapController = MapController();
  late LatLng markerLocation = widget.latLng;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(markerLocation);
        return true;
      },
      child: Scaffold(
        floatingActionButton: Container(
          height: 40,
          margin: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).pop(markerLocation);
            },
            backgroundColor: AppColor.primary.withOpacity(0.7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            icon: const Icon(Icons.check_circle_outline_rounded),
            label: const Text('CONFIRM', style: reviewerTextStyle),
          ),
        ),
        body: FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: markerLocation,
            maxZoom: 30,
            minZoom: 2,
            initialZoom: 15,
            onTap: (tapPosition, point) {
              setState(() {
                markerLocation = point;
              });
            },
          ),
          children: [
            TileLayer(urlTemplate: mapUrl),
            MarkerLayer(markers: [
              Marker(
                width: 50,
                height: 50,
                point: markerLocation,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: Image.asset('assets/images/marker.png'),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
