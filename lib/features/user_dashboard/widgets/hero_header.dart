import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_theme.dart';

class HeroHeader extends StatelessWidget {
  const HeroHeader({super.key});

  static final Uri _whatsAppShare = Uri.https('wa.me', '/', {
    'text': 'धैर्यशील मोहिते-पाटील | माढा लोकसभा\n'
        'माझे नाव मतदार यादीत शोधा:\n'
        'https://independent-voter.madhaloksabha.workers.dev/',
  });

  Future<void> _shareOnWhatsApp(BuildContext context) async {
    final opened = await launchUrl(
      _whatsAppShare,
      mode: LaunchMode.externalApplication,
    );
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('WhatsApp उघडता आले नाही.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.sizeOf(context).width < 700;
    return ColoredBox(
      color: const Color(0xFFFFFCF5),
      child: Column(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: mobile ? 14 : 24,
                  vertical: mobile ? 10 : 13,
                ),
                child: Row(
                  children: [
                    Container(
                      width: mobile ? 44 : 52,
                      height: mobile ? 44 : 52,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.heritageGold,
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/ncp_sp_logo.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 11),
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
                              fontSize: mobile ? 19 : 25,
                              fontWeight: FontWeight.w900,
                              color: AppColors.navyText,
                            ),
                          ),
                          Text(
                            'माढा लोकसभा',
                            style: TextStyle(
                              fontFamily: 'NotoSansDevanagari',
                              fontSize: mobile ? 10.5 : 12.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.greenDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!mobile)
                      const Padding(
                        padding: EdgeInsets.only(right: 6),
                        child: Text(
                          'मतदार शोध  •  लोकसेवा  •  सार्वजनिक कार्य',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    Tooltip(
                      message: 'WhatsApp वर शेअर करा',
                      child: IconButton.filledTonal(
                        onPressed: () => _shareOnWhatsApp(context),
                        icon: const Icon(Icons.share_rounded),
                        color: AppColors.greenDark,
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFFE4F5E9),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            constraints: const BoxConstraints(maxWidth: 1440),
            decoration: const BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(color: Color(0x1A000000)),
              ),
            ),
            child: AspectRatio(
              aspectRatio: 2048 / 931,
              child: Image.asset(
                'assets/images/madha_loksabha_banner.jpg',
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Kept only for legacy admin/widget compatibility; it is not rendered by the
/// new public design.
class CongressHand extends StatelessWidget {
  const CongressHand({
    super.key,
    this.size = 44,
    this.showLabel = true,
    this.labelSize,
  });
  final double size;
  final bool showLabel;
  final double? labelSize;
  @override
  Widget build(BuildContext context) => SizedBox(width: size, height: size);
}
