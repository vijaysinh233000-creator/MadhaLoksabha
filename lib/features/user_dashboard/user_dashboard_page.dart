import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/services/api_client.dart';
import '../../core/services/recent_searches.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_widgets.dart';
import 'search_controller.dart';
import 'widgets/hero_header.dart';
import 'widgets/heritage_sections.dart';
import 'widgets/info_sections.dart';
import 'widgets/install_app_banner.dart';
import 'widgets/regional_story_section.dart';
import 'widgets/results_section.dart';
import 'widgets/search_card.dart';

/// Public user dashboard ("/").
class UserDashboardPage extends StatelessWidget {
  const UserDashboardPage({
    super.key,
    this.initialQuery = '',
    this.initialVillage = '',
  });

  /// Populated from the URL (`/?q=...&village=...`) for shareable links.
  final String initialQuery;
  final String initialVillage;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) =>
          VoterSearchController(ctx.read<ApiClient>(), RecentSearches())
            ..init(initialQuery: initialQuery, initialVillage: initialVillage),
      child: const _UserDashboardView(),
    );
  }
}

class _UserDashboardView extends StatelessWidget {
  const _UserDashboardView();

  @override
  Widget build(BuildContext context) {
    final c = context.watch<VoterSearchController>();
    final hasResults = c.response != null || c.loading || c.error != null;
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.saffron,
          onRefresh: c.refreshStats,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                const HeroHeader(),
                PageContainer(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Transform.translate(
                        offset: const Offset(0, -18),
                        child: const SearchCard(),
                      ),
                      if (c.bootLoading)
                        const LoadingIndicator()
                      else
                        StatsRow(stats: c.stats),
                      const SizedBox(height: 12),
                      if (hasResults) ...[
                        const ResultsSection(),
                        const SizedBox(height: 12),
                      ],
                      const InstallAppBanner(),
                      const SizedBox(height: 12),
                      if (hasResults)
                        const _CollapsedHeritage()
                      else ...[
                        const HeritageStorySection(),
                        const RegionalStorySection(),
                        const InstitutionJourneySection(),
                      ],
                      const SizedBox(height: 28),
                      if (!c.bootLoading) ...[
                        VillagesCard(
                          villages: c.villages,
                          selected: c.selectedVillage,
                          onSelect: c.selectVillage,
                        ),
                        const SizedBox(height: 12),
                        const HowToCard(),
                      ],
                    ],
                  ),
                ),
                const NewBrandFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CollapsedHeritage extends StatefulWidget {
  const _CollapsedHeritage();

  @override
  State<_CollapsedHeritage> createState() => _CollapsedHeritageState();
}

class _CollapsedHeritageState extends State<_CollapsedHeritage> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    elevation: 2,
    shadowColor: const Color(0x0F000000),
    shape: RoundedRectangleBorder(
      side: const BorderSide(color: AppColors.border),
      borderRadius: BorderRadius.circular(14),
    ),
    clipBehavior: Clip.antiAlias,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Icon(
                  Icons.account_balance_rounded,
                  color: AppColors.heritageBrown,
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'मोहिते-पाटील कार्यप्रवास पहा',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: AppColors.navyText,
                        ),
                      ),
                      Text('परिवार आणि संस्थांच्या कार्याची सविस्तर माहिती'),
                    ],
                  ),
                ),
                Icon(
                  _expanded
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: _expanded
              ? const Padding(
                  padding: EdgeInsets.fromLTRB(14, 0, 14, 18),
                  child: Column(
                    children: [
                      HeritageStorySection(),
                      RegionalStorySection(),
                      InstitutionJourneySection(),
                    ],
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    ),
  );
}
