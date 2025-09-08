import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/config/config.dart';
import 'package:my_first_app/model/response/trip_get_res.dart';
import 'package:my_first_app/pages/profile.dart';
import 'package:my_first_app/pages/trip.dart';

class ShowTripPage extends StatefulWidget {
  int cid = 0;
  ShowTripPage({super.key, required this.cid});

  @override
  State<ShowTripPage> createState() => _ShowTripPageState();
}

class _ShowTripPageState extends State<ShowTripPage> {
  String url = '';
  List<TripGetResponse> tripGetResponses = [];
  late Future<void> loadData;

  @override
  void initState() {
    super.initState();
    loadData = getTrips();
  }

  @override
  Widget build(BuildContext context) {
    log('Customer id: ${widget.cid}');
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('รายการทิป'),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              log(value);
              if (value == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(idx: widget.cid),
                  ),
                );
              } else if (value == 'logout') {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('ข้อมูลส่วนตัว'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('ออกจากระบบ'),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text('ปลายทาง'),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        FilledButton(
                          onPressed: () async {
                            await filterTrips();
                          },
                          child: const Text('ทั้งหมด'),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: () async {
                            await filterTrips(zone: 'เอเชีย');
                          },
                          child: const Text('เอเชีย'),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: () async {
                            await filterTrips(zone: 'ยุโรป');
                          },
                          child: const Text('ยุโรป'),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: () async {
                            await filterTrips(
                              multiZone: [
                                'เอเชียตะวันออกเฉียงใต้',
                                'ประเทศไทย',
                              ],
                            );
                          },
                          child: const Text('อาเซียน'),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: () async {
                            await filterTrips(zone: 'ประเทศไทย');
                          },
                          child: const Text('ประเทศไทย'),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: tripGetResponses
                            .map(
                              (e) => Card(
                                color: Colors.white70,
                                elevation: 50,
                                shadowColor: Colors.black,
                                margin: const EdgeInsets.only(bottom: 16),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 180,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          e.name,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: Row(
                                          children: [
                                            Image.network(
                                              e.coverimage,
                                              width: 170,
                                              height: 120,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => const SizedBox(
                                                    width: 170,
                                                    height: 120,
                                                    child: Center(
                                                      child: Text(
                                                        'Cannot load image',
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 16,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(e.country),
                                                  Text(
                                                    'ระยะเวลา ${e.duration} วัน',
                                                  ),
                                                  Text('ราคา ${e.price} บาท'),
                                                  FilledButton(
                                                    onPressed: () =>
                                                        gotoTrip(e.idx),
                                                    child: const Text(
                                                      'รายละเอียดเพิ่มเติม',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
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

  void gotoTrip(int idx) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TripPage(idx: idx)),
    );
  }

  Future<void> getTrips() async {
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];
    var res = await http.get(Uri.parse('$url/trips'));
    tripGetResponses = tripGetResponseFromJson(res.body);
    log(tripGetResponses.length.toString());
  }

  Future<void> filterTrips({String? zone, List<String>? multiZone}) async {
    await getTrips();
    setState(() {
      if (zone != null) {
        tripGetResponses = tripGetResponses
            .where((trip) => trip.destinationZone == zone)
            .toList();
      } else if (multiZone != null) {
        tripGetResponses = tripGetResponses
            .where((trip) => multiZone.contains(trip.destinationZone))
            .toList();
      }
    });
  }
}
