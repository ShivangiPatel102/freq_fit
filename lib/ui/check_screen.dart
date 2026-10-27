import 'dart:async';
import 'package:flutter/material.dart';
import '../core/session.dart';
import '../core/tone.dart';
import 'components.dart';

class CheckScreen extends StatefulWidget {
  final SessionStore store;
  final bool practice;
  final TonePlayer? tonePlayer;
  const CheckScreen(
      {super.key, required this.store, this.practice = false, this.tonePlayer});
  @override
  State<CheckScreen> createState() => _CheckScreenState();
}

class _CheckScreenState extends State<CheckScreen> with WidgetsBindingObserver {
  final name = TextEditingController();
  final notes = TextEditingController();
  late final player = widget.tonePlayer ?? TonePlayer();
  final formKey = GlobalKey<FormState>();
  final levels = <String, double>{};
  int step = 0;
  int frequencyIndex = 0;
  bool left = true;
  bool quiet = false;
  bool headphones = false;
  bool understood = false;
  bool playing = false;
  bool saving = false;
  bool hasPlayed = false;
  double dbfs = -60;
  String? error;
  Timer? timer;
  int playGeneration = 0;
  int get frequency => frequencies[frequencyIndex];
  String get pointKey => '${left ? 'L' : 'R'}$frequency';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) stop();
  }

  void stop() {
    timer?.cancel();
    playGeneration++;
    unawaited(player.stop());
    if (mounted) {
      setState(() {
        playing = false;
        hasPlayed = false;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    timer?.cancel();
    unawaited(player.dispose());
    name.dispose();
    notes.dispose();
    super.dispose();
  }

  Future<void> play() async {
    if (playing) {
      stop();
      return;
    }
    final generation = ++playGeneration;
    setState(() {
      playing = true;
      hasPlayed = false;
      error = null;
    });
    try {
      await player.play(frequency, dbfs, left);
      if (!mounted || generation != playGeneration) return;
      timer = Timer(const Duration(milliseconds: 1150), () {
        if (mounted && generation == playGeneration) {
          setState(() {
            playing = false;
            hasPlayed = true;
          });
        }
      });
    } catch (_) {
      if (mounted && generation == playGeneration) {
        setState(() {
          playing = false;
          error =
              'Audio could not play. Check your output device and browser audio permissions, then try again.';
        });
      }
    }
  }

  void record() {
    if (!hasPlayed || playing) return;
    stop();
    setState(() {
      levels[pointKey] = dbfs;
      dbfs = -60;
      if (frequencyIndex < 5) {
        frequencyIndex++;
      } else if (left) {
        left = false;
        frequencyIndex = 0;
      } else {
        step = 2;
      }
    });
  }

  Future<void> save() async {
    setState(() {
      saving = true;
      error = null;
    });
    final now = DateTime.now();
    final session = HearingSession(
        id: now.microsecondsSinceEpoch.toString(),
        name: name.text.trim(),
        date: now,
        levels: Map.of(levels),
        notes: notes.text.trim());
    try {
      await widget.store.save(session);
      if (mounted) Navigator.pop(context, session);
    } catch (_) {
      if (mounted) {
        setState(() {
          saving = false;
          error =
              'We could not save this session. Your responses are still here; please retry.';
        });
      }
    }
  }

  Future<void> exit() async {
    stop();
    if (step > 0 && !widget.practice) {
      final leave = await showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
                  title: const Text('Leave this check?'),
                  content:
                      const Text('Your unsaved responses will be discarded.'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(c, false),
                        child: const Text('Keep checking')),
                    TextButton(
                        onPressed: () => Navigator.pop(c, true),
                        child: const Text('Leave check'))
                  ]));
      if (leave != true) return;
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => PopScope(
      canPop: step == 0 || widget.practice,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) exit();
      },
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            leading:
                IconButton(onPressed: exit, icon: const Icon(Icons.arrow_back)),
            title: label(
                widget.practice ? 'Practice studio' : 'Your hearing check',
                size: 18,
                weight: FontWeight.w600),
            actions: [
              Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: pill(widget.practice ? 'NOT SAVED' : 'ON THIS DEVICE'))
            ]),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 850),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          if (!widget.practice) ...[
                            Row(children: [
                              for (var i = 0; i < 3; i++) ...[
                                if (i > 0)
                                  const Expanded(child: Divider(color: line)),
                                pill(
                                    [
                                      '01  Prepare',
                                      '02  Listen',
                                      '03  Review'
                                    ][i],
                                    color: step == i ? purple : muted)
                              ]
                            ]),
                            const SizedBox(height: 32)
                          ],
                          if (step == 0)
                            preparation()
                          else if (step == 1)
                            controls()
                          else
                            review(),
                          if (error != null)
                            Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(error!,
                                    style: const TextStyle(
                                        color: Color(0xFFB26060)))),
                        ])))),
      ));
  Widget preparation() => Panel(
      child: Form(
          key: formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.headphones_outlined, color: purple, size: 38),
            const SizedBox(height: 18),
            label(
                widget.practice
                    ? 'Meet your listening controls.'
                    : 'A moment to get comfortable.',
                size: 30,
                weight: FontWeight.w600),
            const SizedBox(height: 12),
            label('A quiet space and a little preparation go a long way.',
                size: 16, color: muted),
            const SizedBox(height: 28),
            if (!widget.practice) ...[
              label('Session name', weight: FontWeight.w600),
              const SizedBox(height: 9),
              TextFormField(
                  controller: name,
                  maxLength: 60,
                  decoration:
                      const InputDecoration(hintText: 'e.g. My first check-in'),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Give this session a name to find it later.'
                      : null),
              const SizedBox(height: 12)
            ],
            CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: label('I’m in a quiet, comfortable space.'),
                value: quiet,
                onChanged: (v) => setState(() => quiet = v!)),
            CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: label('My stereo headphones are on the correct ears.'),
                subtitle: label(
                    'Disable mono audio and keep device volume low.',
                    size: 12,
                    color: muted),
                value: headphones,
                onChanged: (v) => setState(() => headphones = v!)),
            CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title:
                    label('I understand this is an uncalibrated exploration.'),
                subtitle: label(
                    'These digital levels cannot diagnose or classify hearing loss.',
                    size: 12,
                    color: muted),
                value: understood,
                onChanged: (v) => setState(() => understood = v!)),
            const SizedBox(height: 24),
            FilledButton.icon(
                onPressed: quiet && headphones && understood
                    ? () {
                        if (!widget.practice &&
                            !formKey.currentState!.validate()) {
                          return;
                        }
                        setState(() => step = 1);
                      }
                    : null,
                iconAlignment: IconAlignment.end,
                icon: const Icon(Icons.arrow_forward, size: 18),
                label:
                    Text(widget.practice ? 'Try a tone' : 'Begin listening')),
          ])));
  Widget controls() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
              child: label(
                  widget.practice
                      ? 'A little room to explore.'
                      : 'One tone at a time.',
                  size: 30,
                  weight: FontWeight.w600)),
          pill('${levels.length} / 12 recorded')
        ]),
        const SizedBox(height: 12),
        label('Start low. Listen, adjust, then record a consistent response.',
            size: 16, color: muted),
        const SizedBox(height: 24),
        if (!widget.practice) ...[
          LinearProgressIndicator(
              value: levels.length / 12,
              minHeight: 5,
              borderRadius: BorderRadius.circular(5),
              backgroundColor: line),
          const SizedBox(height: 24)
        ],
        Panel(
            child: Column(children: [
          SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                    value: true,
                    label: Text('Left ear'),
                    icon: Icon(Icons.hearing)),
                ButtonSegment(
                    value: false,
                    label: Text('Right ear'),
                    icon: Icon(Icons.hearing))
              ],
              selected: {
                left
              },
              onSelectionChanged: (values) {
                stop();
                setState(() {
                  left = values.first;
                  dbfs = -60;
                });
              }),
          const SizedBox(height: 32),
          label('FREQUENCY', size: 11, color: muted, weight: FontWeight.w600),
          const SizedBox(height: 12),
          Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: List.generate(
                  frequencies.length,
                  (i) => ChoiceChip(
                      label: Text(
                          '${frequencies[i]} Hz${levels.containsKey('${left ? 'L' : 'R'}${frequencies[i]}') ? ' ✓' : ''}'),
                      selected: frequencyIndex == i,
                      onSelected: (_) {
                        stop();
                        setState(() {
                          frequencyIndex = i;
                          dbfs = -60;
                        });
                      }))),
          const SizedBox(height: 25),
          label('${dbfs.toInt()}', size: 60, weight: FontWeight.w600),
          label('dBFS · digital playback level', color: muted),
          Slider(
              value: dbfs,
              min: -60,
              max: -12,
              divisions: 16,
              label: '${dbfs.toInt()} dBFS',
              onChanged: playing
                  ? null
                  : (v) => setState(() {
                        dbfs = v;
                        hasPlayed = false;
                      })),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            label('−60 · Quieter', size: 12, color: muted),
            label('−12 · Louder', size: 12, color: muted)
          ]),
          const SizedBox(height: 26),
          FilledButton.icon(
              onPressed: play,
              icon:
                  Icon(playing ? Icons.stop_rounded : Icons.play_arrow_rounded),
              label: Text(playing ? 'Stop tone' : 'Play a 1-second tone')),
          const SizedBox(height: 15),
          label(
              playing
                  ? 'Listening…'
                  : hasPlayed
                      ? 'Tone played. Record a response or adjust the level.'
                      : 'The tone plays only in the selected ear.',
              size: 13,
              color: muted),
          const SizedBox(height: 20),
          if (!widget.practice)
            OutlinedButton.icon(
                onPressed: hasPlayed && !playing ? record : null,
                icon: const Icon(Icons.check, size: 18),
                label: const Text('Record response & continue')),
        ])),
        const SizedBox(height: 18),
        label(
            'Keep device volume unchanged. Stop immediately if a sound feels uncomfortable.',
            size: 13,
            color: muted),
        if (!widget.practice) ...[
          const SizedBox(height: 18),
          Wrap(spacing: 15, children: [
            TextButton(
                onPressed: levels.isEmpty
                    ? null
                    : () {
                        stop();
                        setState(() => step = 2);
                      },
                child: const Text('Review recorded responses')),
            TextButton(onPressed: exit, child: const Text('End without saving'))
          ])
        ],
      ]);
  Widget review() => Panel(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        pill('A MOMENT OF CLARITY'),
        const SizedBox(height: 18),
        label('Here’s what you recorded.', size: 30, weight: FontWeight.w600),
        const SizedBox(height: 10),
        label('${name.text}  ·  ${levels.length} of 12 responses',
            color: muted),
        const SizedBox(height: 30),
        SessionChart(levels: levels),
        const SizedBox(height: 25),
        if (levels.length < 12) ...[
          pill('Partial session · some responses are missing',
              color: const Color(0xFFC28D55)),
          const SizedBox(height: 18)
        ],
        label('Your notes', weight: FontWeight.w600),
        const SizedBox(height: 10),
        TextField(
            controller: notes,
            maxLines: 3,
            maxLength: 1000,
            decoration: const InputDecoration(
                hintText: 'How was the room? What headphones did you use?')),
        const SizedBox(height: 15),
        label(
            'These are uncalibrated digital response levels, not clinical hearing thresholds. An audiologist can assess concerns with calibrated equipment.',
            size: 13,
            color: muted),
        const SizedBox(height: 25),
        Wrap(spacing: 14, runSpacing: 14, children: [
          FilledButton.icon(
              onPressed: saving ? null : save,
              icon: const Icon(Icons.bookmark_border, size: 18),
              label: Text(saving ? 'Saving…' : 'Save session')),
          OutlinedButton(
              onPressed: saving ? null : () => setState(() => step = 1),
              child: const Text('Back to listening'))
        ]),
      ]));
}
