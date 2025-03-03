import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import '../providers/fake_call_provider.dart';
import 'calling_screen.dart';

class IncomingCallScreen extends StatefulWidget {
  @override
  _IncomingCallScreenState createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _playRingtone();
  }

  void _playRingtone() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource("sounds/ringtone.mp3"));
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fakeCallProvider = Provider.of<FakeCallProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                const Text(
                  "Incoming Call",
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  fakeCallProvider.callerName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  fakeCallProvider.phoneNumber,
                  style: const TextStyle(color: Colors.white70, fontSize: 20),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.red,
                            child: const Icon(Icons.call_end, size: 30, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text("Decline", style: TextStyle(color: Colors.white))
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _audioPlayer.stop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CallingScreen(),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.green,
                            child: const Icon(Icons.call, size: 30, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text("Accept", style: TextStyle(color: Colors.white))
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}