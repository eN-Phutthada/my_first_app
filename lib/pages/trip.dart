import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config/config.dart';
import '../model/response/trip_idx_get_res.dart';

class TripPage extends StatefulWidget {
  final int idx;
  const TripPage({super.key, required this.idx});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  late Future<TripIdxGetResponse> futureTrip;

  @override
  void initState() {
    super.initState();
    futureTrip = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Trip Detail")),
      body: FutureBuilder<TripIdxGetResponse>(
        future: futureTrip,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final trip = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ชื่อทริป
                Text(
                  trip.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // ประเทศ
                Text(
                  trip.country,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),

                const SizedBox(height: 12),

                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    trip.coverimage,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox(
                          height: 200,
                          child: Center(
                            child: Text(
                              'Cannot load image',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 24,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'ราคา ${(trip.price)} บาท',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      'โซน ${(trip.destinationZone)}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // รายละเอียด
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      trip.detail,
                      style: const TextStyle(fontSize: 15, height: 1.4),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<TripIdxGetResponse> loadDataAsync() async {
    var config = await Configuration.getConfig();
    final url = config['apiEndpoint'];
    final res = await http.get(Uri.parse('$url/trips/${widget.idx}'));
    log(res.body);
    return tripIdxGetResponseFromJson(res.body);
  }
}
