import 'package:flutter/material.dart';
import 'heritage_motion.dart';

const _gold = Color(0xFFE9C779);
const _ink = Color(0xFF061E27);

class RegionalStorySection extends StatelessWidget {
  const RegionalStorySection({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 28),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: ColoredBox(
        color: _ink,
        child: DefaultTextStyle(
          style: const TextStyle(
            fontFamily: 'NotoSansDevanagari',
            color: Colors.white,
            height: 1.5,
            fontSize: 14,
          ),
          child: Column(
            children: [
              _Scene(
                asset: 'assets/images/regional_journey.png',
                title: 'अकलूज → मुंबई → दिल्ली',
                subtitle: 'विकास आणि नेतृत्वाचा प्रवास',
                description:
                    'सहकार आणि स्थानिक नेतृत्वापासून राज्याच्या विधिमंडळापर्यंत, लोकसभा आणि राज्यसभेपर्यंतचा सार्वजनिक प्रवास.',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _JourneyStops(),
                    const SizedBox(height: 18),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _gold,
                        side: const BorderSide(color: _gold),
                      ),
                      onPressed: () => Navigator.of(
                        context,
                      ).pushNamed('/sector/regional-journey'),
                      child: const Text('सविस्तर वाचा →'),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0x668EAB9A)),
              _Scene(
                asset: 'assets/images/regional_water.png',
                title: 'कृष्णा–भीमा स्थिरीकरण',
                subtitle: 'पाण्याचा प्रत्येक थेंब भविष्याशी जोडलेला',
                description:
                    'कृष्णा खोऱ्यातील अतिरिक्त पाणी दुष्काळी भागाकडे वळवण्याची जलसंकल्पना. पाणी, शेती आणि ग्रामीण भविष्याचा महत्त्वाचा विषय.',
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _gold,
                      side: const BorderSide(color: _gold),
                    ),
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/sector/water'),
                    child: const Text('पाणी व सिंचनाचा प्रवास वाचा →'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'माढा लोकसभा — सहा विधानसभा क्षेत्रे',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 14),
                    LayoutBuilder(
                      builder: (context, c) {
                        final columns = c.maxWidth >= 800 ? 6 : 2;
                        return Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            for (final name in [
                              'करमाळा',
                              'माढा',
                              'सांगोला',
                              'माळशिरस',
                              'फलटण',
                              'माण',
                            ])
                              Container(
                                width:
                                    (c.maxWidth - (columns - 1) * 10) / columns,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF164739), _ink],
                                  ),
                                  border: Border.all(
                                    color: const Color(0x668EAC8F),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: _gold,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _Scene extends StatelessWidget {
  const _Scene({
    required this.asset,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.child,
  });
  final String asset, title, subtitle, description;
  final Widget child;

  Widget _copy(bool compact) => Padding(
    padding: EdgeInsets.all(compact ? 20 : 32),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: compact ? 27 : 34,
            height: 1.25,
            fontWeight: FontWeight.w900,
            color: _gold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: compact ? 18 : 21,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFF2DCA6),
          ),
        ),
        const SizedBox(height: 12),
        Text(description, style: const TextStyle(color: Color(0xFFE4ECE8))),
        const SizedBox(height: 20),
        child,
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => HeritageMotion(
    enableTilt: false,
    child: LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 800;
        if (compact) {
          return Column(
            children: [
              _copy(true),
              Image.asset(
                asset,
                width: double.infinity,
                fit: BoxFit.contain,
                excludeFromSemantics: true,
              ),
            ],
          );
        }
        return Stack(
          alignment: Alignment.centerLeft,
          children: [
            Positioned.fill(
              child: Image.asset(
                asset,
                fit: BoxFit.cover,
                excludeFromSemantics: true,
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xF5061E27),
                      const Color(0xB3061E27),
                      Colors.transparent,
                    ],
                    stops: const [0, .34, .72],
                  ),
                ),
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 440),
              child: SizedBox(
                width: constraints.maxWidth * .48,
                child: _copy(false),
              ),
            ),
          ],
        );
      },
    ),
  );
}

class _JourneyStops extends StatelessWidget {
  const _JourneyStops();
  @override
  Widget build(BuildContext context) => const Wrap(
    spacing: 14,
    runSpacing: 10,
    children: [
      _Stop('अकलूज', 'सहकार व लोकसेवा'),
      _Stop('मुंबई', 'विधिमंडळ व मंत्रिपदे'),
      _Stop('दिल्ली', 'लोकसभा व राज्यसभा'),
    ],
  );
}

class _Stop extends StatelessWidget {
  const _Stop(this.name, this.office);
  final String name, office;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        name,
        style: const TextStyle(color: _gold, fontWeight: FontWeight.w900),
      ),
      Text(office, style: const TextStyle(fontSize: 10, color: Colors.white70)),
    ],
  );
}
