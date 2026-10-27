import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/session.dart';
import 'components.dart';
import 'check_screen.dart';

class Workspace extends StatefulWidget {
  final SessionStore store;
  const Workspace({super.key, required this.store});
  @override
  State<Workspace> createState() => _WorkspaceState();
}

class _WorkspaceState extends State<Workspace> {
  int page = 0;
  String query = '';
  final titles = [
    'Overview',
    'Hearing checks',
    'Session history',
    'Your guide'
  ];
  final icons = [
    Icons.grid_view_rounded,
    Icons.graphic_eq_rounded,
    Icons.history_rounded,
    Icons.auto_stories_outlined
  ];
  void go(int value) => setState(() {
        page = value;
        query = '';
      });
  Future<void> start({bool practice = false}) async {
    final result = await Navigator.push<HearingSession>(
        context,
        MaterialPageRoute(
            builder: (_) =>
                CheckScreen(store: widget.store, practice: practice)));
    if (result != null && mounted) {
      go(2);
      showSession(result);
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
      listenable: widget.store,
      builder: (context, _) => LayoutBuilder(builder: (context, constraints) {
            final wide = constraints.maxWidth >= 1000;
            return Scaffold(
              bottomNavigationBar: wide
                  ? null
                  : NavigationBar(
                      selectedIndex: page,
                      onDestinationSelected: go,
                      destinations: List.generate(
                          4,
                          (i) => NavigationDestination(
                              icon: Icon(icons[i]),
                              label: [
                                'Home',
                                'Checks',
                                'History',
                                'Guide'
                              ][i]))),
              body: SafeArea(
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                    if (wide) sidebar(),
                    Expanded(
                        child: Column(children: [
                      topbar(wide),
                      Expanded(
                          child: SingleChildScrollView(
                              padding: EdgeInsets.all(wide ? 38 : 20),
                              child: Center(
                                  child: ConstrainedBox(
                                      constraints:
                                          const BoxConstraints(maxWidth: 1200),
                                      child: switch (page) {
                                        0 => overview(),
                                        1 => checks(),
                                        2 => history(),
                                        _ => guide()
                                      }))))
                    ])),
                  ])),
            );
          }));
  Widget sidebar() => Container(
      width: 234,
      decoration: const BoxDecoration(
          color: Colors.white, border: Border(right: BorderSide(color: line))),
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 12),
        Row(children: [
          Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                  color: purple, borderRadius: BorderRadius.circular(12)),
              child:
                  const Icon(Icons.graphic_eq, color: Colors.white, size: 23)),
          const SizedBox(width: 10),
          Expanded(child: label('freqfit', size: 28, weight: FontWeight.w700))
        ]),
        Padding(
            padding: const EdgeInsets.only(top: 12, left: 2),
            child: label('A LITTLE CLARITY. A LOT OF LIFE.',
                size: 9, color: muted, weight: FontWeight.w600)),
        const SizedBox(height: 55),
        label('WORKSPACE', size: 10, color: muted, weight: FontWeight.w600),
        const SizedBox(height: 16),
        ...List.generate(
            4,
            (i) => Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Material(
                    color: page == i
                        ? const Color(0xFFEEF0FC)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 13),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        leading: Icon(icons[i],
                            size: 20, color: page == i ? purple : muted),
                        title: label(titles[i],
                            size: 15,
                            color: page == i ? purple : muted,
                            weight:
                                page == i ? FontWeight.w600 : FontWeight.w400),
                        onTap: () => go(i))))),
        const Spacer(),
        Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
                color: const Color(0xFFF7F8FC),
                borderRadius: BorderRadius.circular(13)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.favorite_border, color: purple, size: 23),
              const SizedBox(height: 12),
              label('Small checks. Big difference.',
                  size: 14, weight: FontWeight.w600),
              const SizedBox(height: 8),
              label('Make space for your hearing wellbeing.',
                  size: 12, color: muted),
              const SizedBox(height: 12),
              InkWell(
                  onTap: () => go(3),
                  child: label('Get to know your hearing  ↗',
                      size: 12, color: purple))
            ])),
        const SizedBox(height: 24),
        const Divider(color: line),
        const SizedBox(height: 14),
        Row(children: [
          const CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFECEEF8),
              child: Icon(Icons.person_outline, color: purple, size: 20)),
          const SizedBox(width: 11),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                label('Personal workspace', size: 13, weight: FontWeight.w600),
                label('On this device', size: 11, color: muted)
              ]))
        ]),
        const SizedBox(height: 8),
      ]));
  Widget topbar(bool wide) => Container(
      height: 83,
      decoration: const BoxDecoration(
          color: Colors.white, border: Border(bottom: BorderSide(color: line))),
      padding: EdgeInsets.symmetric(horizontal: wide ? 38 : 20),
      child: Row(children: [
        if (!wide) ...[
          const Icon(Icons.graphic_eq, color: purple),
          const SizedBox(width: 12)
        ],
        label(titles[page], size: 17, weight: FontWeight.w600),
        const Spacer(),
        if (wide) ...[
          const Icon(Icons.lock_outline, color: muted, size: 15),
          const SizedBox(width: 7),
          label('Private by design', size: 12, color: muted),
          const SizedBox(width: 25),
          Container(width: 1, height: 22, color: line),
          const SizedBox(width: 25)
        ],
        pill('LOCAL WORKSPACE', color: const Color(0xFF448F7D))
      ]));
  Widget intro(String eyebrow, String title, String description,
          {Widget? action}) =>
      Padding(
          padding: const EdgeInsets.only(bottom: 28),
          child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 20,
              runSpacing: 16,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  label(eyebrow,
                      size: 11, color: muted, weight: FontWeight.w600),
                  const SizedBox(height: 9),
                  label(title, size: 34, weight: FontWeight.w600),
                  const SizedBox(height: 9),
                  label(description, size: 15, color: muted)
                ]),
                if (action != null) action
              ]));
  Widget overview() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        intro('YOUR HEARING, IN FOCUS', 'A little clarity goes a long way.',
            'A thoughtful space to check in, listen closely, and keep track.'),
        LayoutBuilder(
            builder: (context, c) => Container(
                decoration: BoxDecoration(
                    color: const Color(0xFFEEF0FC),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE3E6F7))),
                child: Row(children: [
                  Expanded(
                      flex: 6,
                      child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                pill('MEET YOUR NEXT HEARING CHECK'),
                                const SizedBox(height: 24),
                                label(
                                    'Good hearing starts\nwith a small check-in.',
                                    size: c.maxWidth > 700 ? 35 : 28,
                                    weight: FontWeight.w600),
                                const SizedBox(height: 14),
                                label(
                                    'Explore how you respond to different tones.\nOne frequency, one ear, one moment at a time.',
                                    size: 15,
                                    color: const Color(0xFF6E7597)),
                                const SizedBox(height: 26),
                                FilledButton.icon(
                                    onPressed: () => start(),
                                    icon: const Icon(Icons.arrow_forward,
                                        size: 18),
                                    iconAlignment: IconAlignment.end,
                                    label: const Text('Start a hearing check')),
                                const SizedBox(height: 17),
                                label(
                                    '6 frequencies  ·  Both ears  ·  At your own pace',
                                    size: 12,
                                    color: muted)
                              ]))),
                  if (c.maxWidth > 650)
                    const Expanded(
                        flex: 4,
                        child: SizedBox(height: 300, child: SoundArt()))
                ]))),
        const SizedBox(height: 25),
        LayoutBuilder(builder: (context, c) {
          final items = [
            stat(Icons.headphones_outlined, '${widget.store.sessions.length}',
                'Saved sessions', 'Your listening journey', purple),
            stat(Icons.tune, '6', 'Frequencies explored', '250 Hz to 8,000 Hz',
                const Color(0xFF4F9C8D)),
            stat(Icons.shield_outlined, '100%', 'Stored on this device',
                'No account needed', const Color(0xFFC28D55))
          ];
          return c.maxWidth > 700
              ? Row(children: [
                  for (var i = 0; i < 3; i++) ...[
                    if (i > 0) const SizedBox(width: 18),
                    Expanded(child: items[i])
                  ]
                ])
              : Column(children: [
                  for (final item in items)
                    Padding(
                        padding: const EdgeInsets.only(bottom: 12), child: item)
                ]);
        }),
        const SizedBox(height: 30),
        LayoutBuilder(builder: (context, c) {
          final recent = recentPanel();
          final ready = readyPanel();
          return c.maxWidth > 800
              ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(flex: 6, child: recent),
                  const SizedBox(width: 24),
                  Expanded(flex: 4, child: ready)
                ])
              : Column(children: [recent, const SizedBox(height: 20), ready]);
        }),
        const SizedBox(height: 25),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.info_outline, size: 16, color: muted),
          const SizedBox(width: 9),
          Expanded(
              child: label(
                  'A check-in, not a diagnosis. FreqFit is an uncalibrated exploration tool and does not replace a professional hearing assessment.',
                  size: 12,
                  color: muted))
        ]),
      ]);
  Widget stat(IconData icon, String value, String title, String subtitle,
          Color color) =>
      Panel(
          padding: const EdgeInsets.all(22),
          child: Row(children: [
            Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: color.withValues(alpha: .08),
                    borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: color, size: 23)),
            const SizedBox(width: 17),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Row(children: [
                    label(value, size: 25, weight: FontWeight.w600),
                    const SizedBox(width: 8),
                    Flexible(child: label(title, size: 12, color: muted))
                  ]),
                  const SizedBox(height: 4),
                  label(subtitle, size: 12, color: muted)
                ]))
          ]));
  Widget recentPanel() => Panel(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: heading('Your recent sessions')),
          TextButton(onPressed: () => go(2), child: const Text('View all  →'))
        ]),
        const SizedBox(height: 18),
        if (widget.store.sessions.isEmpty) ...[
          const SizedBox(height: 7),
          const Icon(Icons.insights_rounded,
              color: Color(0xFFB0B7D9), size: 35),
          const SizedBox(height: 12),
          label('Your story starts with a listen.',
              size: 17, weight: FontWeight.w600),
          const SizedBox(height: 8),
          label(
              'Your completed checks will appear here,\nready whenever you want to look back.',
              size: 14,
              color: muted),
          const SizedBox(height: 15),
          TextButton(
              onPressed: () => start(practice: true),
              child: const Text('Try a practice tone  →'))
        ] else
          ...widget.store.sessions.take(3).map(sessionRow)
      ]));
  Widget readyPanel() => Panel(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: heading('Set yourself up to listen')),
          const Icon(Icons.spa_outlined, color: Color(0xFF629C8D), size: 22)
        ]),
        const SizedBox(height: 20),
        tip('01', 'Find your quiet', 'A calm room makes all the difference.'),
        tip('02', 'Put on your headphones',
            'Use stereo headphones, with the correct sides.'),
        tip('03', 'Take your time',
            'Start low. Stop if anything feels uncomfortable.'),
        InkWell(
            onTap: () => go(3),
            child:
                label('Read the preparation guide  ↗', size: 13, color: purple))
      ]));
  Widget tip(String n, String title, String detail) => Padding(
      padding: const EdgeInsets.only(bottom: 19),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        label(n, size: 12, color: const Color(0xFFA2AAC6)),
        const SizedBox(width: 14),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          label(title, size: 14, weight: FontWeight.w600),
          const SizedBox(height: 4),
          label(detail, size: 12, color: muted)
        ]))
      ]));
  Widget checks() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        intro('MAKE TIME TO LISTEN', 'Find your starting point.',
            'Get familiar with a tone, or explore both ears.'),
        Panel(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.headphones, size: 40, color: purple),
          const SizedBox(height: 20),
          heading('Pure tone exploration'),
          const SizedBox(height: 12),
          label(
              'Record a response level at six frequencies for each ear.\nReview the plot and keep notes in your local session history.',
              size: 16,
              color: muted),
          const SizedBox(height: 25),
          FilledButton(
              onPressed: () => start(),
              child: const Text('Start a hearing check  →'))
        ])),
        const SizedBox(height: 20),
        Panel(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          heading('First time here?'),
          const SizedBox(height: 10),
          label('Try the controls with a practice tone. Nothing is saved.',
              size: 15, color: muted),
          const SizedBox(height: 20),
          OutlinedButton(
              onPressed: () => start(practice: true),
              child: const Text('Open practice mode'))
        ]))
      ]);
  Widget sessionRow(HearingSession session) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const CircleAvatar(
              backgroundColor: Color(0xFFF0F1FB),
              child: Icon(Icons.graphic_eq, color: purple, size: 20)),
          title: label(session.name, size: 16, weight: FontWeight.w600),
          subtitle: label(
              '${dateLabel(session.date)}  ·  ${session.levels.length}/12 responses',
              size: 12,
              color: muted),
          trailing: const Icon(Icons.arrow_forward_ios, size: 13, color: muted),
          onTap: () => showSession(session)));
  Widget history() {
    final sessions = widget.store.sessions
        .where((s) => s.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      intro('A RECORD OF YOUR CHECK-INS', 'Your listening journey.',
          'Revisit your sessions and the notes you made along the way.',
          action: FilledButton.icon(
              onPressed: () => start(),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('New check'))),
      if (widget.store.error != null)
        Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(widget.store.error!)),
      TextField(
          onChanged: (v) => setState(() => query = v),
          decoration: const InputDecoration(
              hintText: 'Search sessions by name',
              prefixIcon: Icon(Icons.search))),
      const SizedBox(height: 20),
      Panel(
          child: sessions.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(35),
                  child: Center(
                      child: Column(children: [
                    const Icon(Icons.history, size: 40, color: muted),
                    const SizedBox(height: 15),
                    heading(query.isEmpty
                        ? 'A fresh start.'
                        : 'No matching sessions'),
                    const SizedBox(height: 10),
                    label(
                        query.isEmpty
                            ? 'Save your first hearing check to begin your history.'
                            : 'Try another name.',
                        color: muted)
                  ])))
              : Column(children: sessions.map(sessionRow).toList())),
      const SizedBox(height: 18),
      label(
          'Sessions stay in this browser or app. Clearing app data removes local history.',
          size: 12,
          color: muted)
    ]);
  }

  Widget guide() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        intro('A LITTLE KNOW-HOW', 'Better prepared. Better listening.',
            'Everything you need for a thoughtful check-in.'),
        ...[
          (
            'Before you begin',
            'Choose a quiet room and use stereo headphones. Check the L and R markings. Turn off spatial audio, mono audio, and audio enhancements. Keep device volume low and comfortable, then leave it unchanged throughout the session.'
          ),
          (
            'How a check works',
            'Begin at the lowest digital level. Play a short tone, adjust the level in small steps, and record the lowest setting you consistently respond to. The app guides you through six frequencies for each ear. Take a break whenever you need one.'
          ),
          (
            'What your results mean',
            'The plot shows the digital playback levels you recorded, in dBFS. These are not dB HL or sound pressure levels. Headphones, device volume, and your surroundings affect every response, so these results cannot classify hearing loss or be compared as clinical thresholds.'
          ),
          (
            'When to get professional support',
            'If you have concerns about your hearing, arrange a calibrated assessment with an audiologist. Sudden hearing loss needs prompt medical attention. Do not increase sound to discomfort or use FreqFit to delay seeking care.'
          ),
          (
            'Your data stays close',
            'No sign-in, cloud upload, or analytics. Session names, notes, and response levels are saved locally on this device. Use a nickname or session label instead of identifying patient information. Copy a session report before clearing browser or app data.'
          ),
        ].map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Panel(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  heading(item.$1),
                  const SizedBox(height: 13),
                  Text(item.$2,
                      style: const TextStyle(
                          fontSize: 16, height: 1.65, color: muted))
                ]))))
      ]);
  Future<void> showSession(HearingSession session) => showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
          child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 670),
              child: SingleChildScrollView(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(children: [
                          Expanded(child: heading(session.name)),
                          IconButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              icon: const Icon(Icons.close))
                        ]),
                        label(dateLabel(session.date), color: muted),
                        const SizedBox(height: 25),
                        SessionChart(levels: session.levels),
                        const SizedBox(height: 22),
                        pill(session.complete
                            ? '12 of 12 responses recorded'
                            : '${session.levels.length} of 12 responses · Partial session'),
                        const SizedBox(height: 18),
                        label(
                            session.notes.isEmpty
                                ? 'No session notes.'
                                : session.notes,
                            color: muted),
                        const SizedBox(height: 15),
                        label(
                            'Uncalibrated digital levels. Not a diagnostic audiogram.',
                            size: 12,
                            color: muted),
                        const SizedBox(height: 24),
                        Wrap(spacing: 12, runSpacing: 12, children: [
                          FilledButton.icon(
                              onPressed: () async {
                                final report =
                                    'FreqFit — ${session.name}\n${dateLabel(session.date)}\nFrequency Hz,Left dBFS,Right dBFS\n${frequencies.map((f) => '$f,${session.levels['L$f'] ?? ''},${session.levels['R$f'] ?? ''}').join('\n')}\nNotes: ${session.notes}\nUncalibrated digital levels; not a diagnostic audiogram.';
                                try {
                                  await Clipboard.setData(
                                      ClipboardData(text: report));
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Session report copied')));
                                  }
                                } catch (_) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Clipboard access is unavailable. Please enable it and try again.')));
                                  }
                                }
                              },
                              icon: const Icon(Icons.copy, size: 16),
                              label: const Text('Copy report')),
                          TextButton(
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                    context: dialogContext,
                                    builder: (c) => AlertDialog(
                                            title: const Text(
                                                'Delete this session?'),
                                            content: const Text(
                                                'This removes the saved session from this device.'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(c, false),
                                                  child: const Text(
                                                      'Keep session')),
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(c, true),
                                                  child: const Text('Delete'))
                                            ]));
                                if (confirm != true) return;
                                try {
                                  await widget.store.delete(session.id);
                                  if (dialogContext.mounted) {
                                    Navigator.pop(dialogContext);
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('$e')));
                                  }
                                }
                              },
                              child: const Text('Delete session',
                                  style: TextStyle(color: Color(0xFFB26060))))
                        ])
                      ])))));
}
