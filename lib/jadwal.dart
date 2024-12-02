// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:table_calendar/table_calendar.dart';

class JadwalMaulidPage extends StatefulWidget {
  const JadwalMaulidPage({super.key});

  @override
  _JadwalMaulidPage createState() => _JadwalMaulidPage();
}

class _JadwalMaulidPage extends State<JadwalMaulidPage> {
  List<dynamic> _events = [];
  bool _isLoading = true;
  Map<DateTime, List<dynamic>> _groupedEvents = {};
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    const calendarId = 'primary';
    const apiKey = 'AIzaSyDFn2bev9XxkvKIoY5cKC0SL8Bu76LHspg';
    final url = Uri.parse(
        'https://www.googleapis.com/calendar/v3/calendars/$calendarId/events?key=$apiKey');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _events = data['items'];
          _groupEvents(_events);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        if (kDebugMode) {
          print("Failed to load events: ${response.statusCode}");
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (kDebugMode) {
        print("Error fetching events: $e");
      }
    }
  }

  void _groupEvents(List<dynamic> events) {
    _groupedEvents = {};
    for (var event in events) {
      DateTime date =
          DateTime.parse(event['start']['dateTime'] ?? event['start']['date']);
      DateTime day = DateTime(date.year, date.month, date.day);
      if (_groupedEvents[day] == null) _groupedEvents[day] = [];
      _groupedEvents[day]!.add(event);
    }
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    DateTime date = DateTime(day.year, day.month, day.day);
    return _groupedEvents[date] ?? [];
  }

  // Fungsi untuk mengubah bulan yang ditampilkan
  void _onMonthChanged(int? month) {
    if (month == null) return;
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, month);
    });
  }

  // Fungsi untuk mengubah tahun yang ditampilkan
  void _onYearChanged(int? year) {
    if (year == null) return;
    setState(() {
      _focusedDay = DateTime(year, _focusedDay.month);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4DB6AC),
        title: const Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                'https://storage.googleapis.com/a1aa/image/JoQVWJHetbzdA6tHLeoRvHvgbRfDn3NUU3zzdaqgMbU96ndnA.jpg',
              ),
              radius: 17,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                "Zulkipli Siregar",
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: const [
          Icon(Icons.account_circle, size: 38),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Dropdown untuk memilih bulan
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton<int>(
                      value: _focusedDay.month,
                      items: List.generate(12, (index) {
                        return DropdownMenuItem(
                          value: index + 1,
                          child: Text(
                            _getMonthName(index + 1),
                          ),
                        );
                      }),
                      onChanged: (int? month) => _onMonthChanged(month),
                    ),
                    const SizedBox(width: 20),
                    // Dropdown untuk memilih tahun
                    DropdownButton<int>(
                      value: _focusedDay.year,
                      items: List.generate(10, (index) {
                        int year = DateTime.now().year - 5 + index;
                        return DropdownMenuItem(
                          value: year,
                          child: Text(
                            year.toString(),
                          ),
                        );
                      }),
                      onChanged: (int? year) => _onYearChanged(year),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                TableCalendar(
                  firstDay: DateTime.utc(2020, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: _focusedDay,
                  eventLoader: _getEventsForDay,
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, events) {
                      if (events.isNotEmpty) {
                        return _buildEventPinMarker();
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: _events.length,
                    itemBuilder: (context, index) {
                      final event = _events[index];
                      final title = event['summary'] ?? 'No Title';
                      final startDate = event['start']?['dateTime'] ??
                          event['start']?['date'] ??
                          'Unknown date';
                      return ListTile(
                        leading: const Icon(Icons.event),
                        title: Text(title),
                        subtitle: Text(startDate),
                      );
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: Container(
        height: 70,
        color: const Color(0xFFF4A300),
        child: Center(
          child: Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: Color(0xFF3A8B7D),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.home, color: Colors.white, size: 35),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventPinMarker() {
    return const Icon(
      Icons.push_pin,
      color: Colors.red,
      size: 24.0,
    );
  }

  String _getMonthName(int month) {
    const monthNames = [
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember"
    ];
    return monthNames[month - 1];
  }
}
