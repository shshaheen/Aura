import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fake_call_provider.dart';
import 'dart:async';

class CallingScreen extends StatefulWidget {
  @override
  _CallingScreenState createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen> {
  int _secondsElapsed = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCallTimer();
  }

  void _startCallTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
      });
    });
  }

  String _formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fakeCallProvider = Provider.of<FakeCallProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            fakeCallProvider.callerName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            fakeCallProvider.phoneNumber,
            style: const TextStyle(color: Colors.white70, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Text(
            _formatDuration(_secondsElapsed),
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.record_voice_over, color: Colors.white, size: 30),
                    onPressed: () {},
                  ),
                  const Text("Speaker", style: TextStyle(color: Colors.white))
                ],
              ),
              const SizedBox(width: 40),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.video_call, color: Colors.white, size: 30),
                    onPressed: () {},
                  ),
                  const Text("Dialpad", style: TextStyle(color: Colors.white))
                ],
              ),
              const SizedBox(width: 40),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_call, color: Colors.white, size: 30),
                    onPressed: () {},
                  ),
                  const Text("Mute", style: TextStyle(color: Colors.white))
                ],
              ),
            ],
          ),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.volume_up, color: Colors.white, size: 30),
                    onPressed: () {},
                  ),
                  const Text("Speaker", style: TextStyle(color: Colors.white))
                ],
              ),
              const SizedBox(width: 40),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.dialpad, color: Colors.white, size: 30),
                    onPressed: () {},
                  ),
                  const Text("Dialpad", style: TextStyle(color: Colors.white))
                ],
              ),
              const SizedBox(width: 40),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.mic_off, color: Colors.white, size: 30),
                    onPressed: () {},
                  ),
                  const Text("Mute", style: TextStyle(color: Colors.white))
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),
          GestureDetector(
            onTap: () {
              _timer?.cancel();
              Navigator.popUntil(context, ModalRoute.withName('/fake_call_screen'));
            },
            child: const CircleAvatar(
              radius: 35,
              backgroundColor: Colors.red,
              child: Icon(Icons.call_end, size: 30, color: Colors.white),
            ),
          ),
          const SizedBox(height: 10),
          const Text("End Call", style: TextStyle(color: Colors.white)),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}