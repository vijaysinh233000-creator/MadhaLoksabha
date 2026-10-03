import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_theme.dart';

/// Full-bleed, documentary-style masthead: a single cinematic photograph with
/// a slow Ken Burns drift, an editorial headline, and a transparent nav
/// overlay — no separate white toolbar, no decorative 3D props.
class HeroHeader extends StatefulWidget {
  const HeroHeader({super.key});

  @override
  State<HeroHeader> createState() => _HeroHeaderState();
}

class _HeroHeaderState extends State<HeroHeader>
    with TickerProviderStateMixin {
  late final AnimationController _kenBurns = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 18),
  );
  late final AnimationController _cue = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  static final Uri _whatsAppShare = Uri.https('wa.me', '/', {
    'text':
        'धैर्यशील मोहिते-पाटील | माढा लोकसभा\n'
        'माझे नाव मतदार यादीत शोधा:\n'
        'https://independent-voter.madhaloksabha.workers.dev/',
  });

  @override
  void initState() {
    super.initState();
    if (!MediaQuery.disableAnimationsOf(context)) {
      _kenBurns.repeat(reverse: true);
      _cue.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _kenBurns.dispose();
    _cue.dispose();
    super.dispose();
  }

  Future<void> _shareOnWhatsApp(BuildContext context) async {
    final opened = await launchUrl(
      _whatsAppShare,
      mode: LaunchMode.externalApplication,
    );
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('WhatsApp उघडता आले नाही.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final mobile = size.width < 700;
    final heroHeight = mobile ? 520.0 : (size.width < 1100 ? 600.0 : 660.0);

    return ColoredBox(
      color: AppColors.inkDeep,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1600),
          child: SizedBox(
            height: heroHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Ken Burns photograph.
                AnimatedBuilder(
                  animation: _kenBurns,
                  builder: (context, child) {
                    final t = Curves.easeInOutSine.transform(_kenBurns.value);
                    return Transform.scale(
                      scale: 1.0 + t * 0.07,
                      alignment: Alignment.lerp(
                        const Alignment(-0.15, -0.05),
                        const Alignment(0.15, 0.05),
                        t,
                      )!,
                      child: child,
                    );
                  },
                  child: Semantics(
                    label: 'धैर्यशील मोहिते-पाटील आणि माढा मतदारसंघाचे चित्र',
                    image: true,
                    child: Image.asset(
                      'assets/images/madha_loksabha_banner.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Duotone grade for a cohesive editorial tone.
                const ExcludeSemantics(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x660A1512),
                          Color(0x330A1512),
                          Color(0xE6060D0B),
                        ],
                        stops: [0, 0.45, 1],
                      ),
                    ),
                  ),
                ),
                const ExcludeSemantics(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0x44051A14), Color(0x00000000)],
                        stops: [0, 0.5],
                      ),
                    ),
                  ),
                ),
                // Vignette for focus.
                const ExcludeSemantics(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 1.1,
                        colors: [Color(0x00000000), Color(0x4D000000)],
                        stops: [0.6, 1],
                      ),
                    ),
                  ),
                ),

                // Transparent masthead overlay.
                Positioned(
                  left: mobile ? 16 : 40,
                  right: mobile ? 16 : 40,
                  top: mobile ? 16 : 26,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'धैर्यशील मोहिते-पाटील',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'NotoSansDevanagari',
                                fontSize: mobile ? 17 : 20,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                shadows: const [
                                  Shadow(color: Color(0xCC000000), blurRadius: 10),
                                ],
                              ),
                            ),
                            Text(
                              'माढा लोकसभा मतदारसंघ',
                              style: TextStyle(
                                fontFamily: 'NotoSansDevanagari',
                                fontSize: mobile ? 10 : 11.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.4,
                                color: AppColors.goldSoft,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _GlassIconButton(
                        tooltip: 'WhatsApp वर शेअर करा',
                        icon: Icons.share_rounded,
                        onTap: () => _shareOnWhatsApp(context),
                      ),
                    ],
                  ),
                ),

                // Editorial headline block.
                Positioned(
                  left: mobile ? 18 : 48,
                  right: mobile ? 18 : 48,
                  bottom: mobile ? 56 : 68,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(width: 28, height: 2, color: AppColors.gold),
                          const SizedBox(width: 9),
                          Text(
                            'कृष्णा • भीमा • माढा',
                            style: TextStyle(
                              color: AppColors.goldSoft,
                              fontSize: mobile ? 10.5 : 12.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2.4,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'पाणी, शेती आणि शिक्षणाचा\nपुढचा अध्याय',
                        style: TextStyle(
                          fontFamily: 'NotoSansDevanagari',
                          color: Colors.white,
                          fontSize: mobile ? 28 : 46,
                          fontWeight: FontWeight.w900,
                          height: 1.12,
                          shadows: const [
                            Shadow(color: Color(0xB3000000), blurRadius: 18, offset: Offset(0, 4)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      if (!mobile)
                        const SizedBox(
                          width: 460,
                          child: Text(
                            'तीन पिढ्यांच्या लोकसेवेतून उभा राहिलेला माढा — धरणांपासून शाळांपर्यंत, साखर कारखान्यांपासून कुस्तीच्या मातीपर्यंत.',
                            style: TextStyle(
                              color: Color(0xD9FFFFFF),
                              fontSize: 14.5,
                              height: 1.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                        decoration: BoxDecoration(
                          color: const Color(0x1AFFFFFF),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: const Color(0x66D4AF37)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.verified_rounded, color: AppColors.gold, size: 15),
                            const SizedBox(width: 7),
                            Text(
                              'अधिकृत माढा लोकसभा मतदार सेवा',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: mobile ? 10.5 : 11.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Scroll cue.
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 16,
                  child: AnimatedBuilder(
                    animation: _cue,
                    builder: (context, child) => Transform.translate(
                      offset: Offset(0, 5 * Curves.easeInOut.transform(_cue.value)),
                      child: child,
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xAAFFFFFF), size: 22),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: tooltip,
    child: Material(
      color: const Color(0x26FFFFFF),
      shape: const CircleBorder(side: BorderSide(color: Color(0x40FFFFFF))),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: Colors.white, size: 19),
        ),
      ),
    ),
  );
}
