import 'package:flutter/material.dart';
import '../models/skill_data.dart';
import '../theme/app_theme.dart';
import '../widgets/ambient_background.dart';
import '../widgets/app_logo.dart';
import 'explore/explore_screen.dart';
import 'roadmap/roadmap_detail_screen.dart';
import 'tabs/search_screen.dart';
import 'tabs/settings_screen.dart';

class MainNavContainer extends StatefulWidget {
  final int initialIndex;

  const MainNavContainer({
    super.key,
    this.initialIndex = 0, // Default to Home tab after login
  });

  @override
  State<MainNavContainer> createState() => _MainNavContainerState();
}

class _MainNavContainerState extends State<MainNavContainer> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  final List<Widget> _pages = const [
    _HomeTab(),
    ExploreScreen(),
    _RoadmapTab(),
    SearchScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.eclipse,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          backgroundColor: AppTheme.eclipse,
          selectedItemColor: AppTheme.almond,
          unselectedItemColor: Colors.white.withValues(alpha: 0.5),
          selectedFontSize: 11,
          unselectedFontSize: 11,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore_rounded),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.alt_route_outlined),
              activeIcon: Icon(Icons.alt_route_rounded),
              label: 'Roadmap',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search_rounded),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final popularSkills = SkillRepository.categories.expand((c) => c.skills).take(4).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AmbientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Compact App Logo
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppLogo(size: 28, showText: true),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.borderLight),
                    ),
                    child: const Icon(
                      Icons.notifications_none_rounded,
                      color: AppTheme.textPrimary,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Welcome Text (Out of box, normal text)
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to Cutebuddie 👋',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Ready to master your next skill? Pick up where you left off or explore new roadmaps.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Quick Stats Row
              const Row(
                children: [
                  _StatCard(
                    icon: Icons.whatshot_rounded,
                    iconColor: Colors.orangeAccent,
                    value: '3 Days',
                    label: 'Streak',
                  ),
                  SizedBox(width: 12),
                  _StatCard(
                    icon: Icons.map_rounded,
                    iconColor: AppTheme.matchaBrew,
                    value: '2 Active',
                    label: 'Roadmaps',
                  ),
                  SizedBox(width: 12),
                  _StatCard(
                    icon: Icons.verified_rounded,
                    iconColor: Colors.lightBlueAccent,
                    value: '12',
                    label: 'Completed',
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Featured Roadmaps Section
              const Text(
                'Recommended for You',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 14),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: popularSkills.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final skill = popularSkills[index];
                  return Material(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(16),
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.borderLight),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.matchaBrew.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.alt_route_rounded,
                            color: AppTheme.matchaBrew,
                          ),
                        ),
                        title: Text(
                          skill.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          skill.category,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right_rounded,
                          color: AppTheme.textMuted,
                        ),
                        onTap: () {
                          ActiveRoadmapManager.setActiveSkill(skill);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => RoadmapDetailScreen(skill: skill),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoadmapTab extends StatefulWidget {
  const _RoadmapTab();

  @override
  State<_RoadmapTab> createState() => _RoadmapTabState();
}

class _RoadmapTabState extends State<_RoadmapTab> {
  final Set<int> _completedNodes = {0};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Roadmap'),
        centerTitle: true,
      ),
      body: AmbientBackground(
        child: SafeArea(
          child: ValueListenableBuilder<SkillItem?>(
            valueListenable: ActiveRoadmapManager.activeSkillNotifier,
            builder: (context, activeSkill, _) {
              if (activeSkill == null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.alt_route_rounded, size: 64, color: AppTheme.textMuted),
                        const SizedBox(height: 16),
                        const Text(
                          'No Active Roadmap Selected',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Select any skill or language from Explore to generate your progress roadmap.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final nodes = [
                'Phase 1: Core Foundations & Setup',
                'Phase 2: Data Structures & OOP Patterns',
                'Phase 3: Frameworks & API Architecture',
                'Phase 4: Database Integration & ORM',
                'Phase 5: Capstone Project & Deployment',
              ];

              final progressPercentage = (_completedNodes.length / nodes.length * 100).round();

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Active Skill Header Card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.borderLight),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.matchaBrew.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppTheme.matchaBrew.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.alt_route_rounded, color: AppTheme.matchaBrew),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      activeSkill.title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      activeSkill.category,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Progress Bar
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Overall Progress',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              Text(
                                '$progressPercentage%',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.matchaBrew,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: _completedNodes.length / nodes.length,
                              minHeight: 8,
                              backgroundColor: AppTheme.inputFill,
                              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.matchaBrew),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Roadmap Nodes List
                    const Text(
                      'Learning Path',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: nodes.length,
                      itemBuilder: (context, index) {
                        final nodeTitle = nodes[index];
                        final isDone = _completedNodes.contains(index);
                        final isCurrent = index == 0 || _completedNodes.contains(index - 1);
                        final isLast = index == nodes.length - 1;

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (isDone) {
                                        _completedNodes.remove(index);
                                      } else {
                                        _completedNodes.add(index);
                                      }
                                    });
                                  },
                                  child: CircleAvatar(
                                    radius: 18,
                                    backgroundColor: isDone
                                        ? AppTheme.matchaBrew
                                        : isCurrent
                                            ? AppTheme.almond
                                            : AppTheme.inputFill,
                                    child: isDone
                                        ? const Icon(Icons.check, color: AppTheme.white, size: 20)
                                        : Text(
                                            '${index + 1}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: isCurrent ? AppTheme.eclipse : AppTheme.textMuted,
                                            ),
                                          ),
                                  ),
                                ),
                                if (!isLast)
                                  Container(
                                    width: 2,
                                    height: 44,
                                    color: isDone ? AppTheme.matchaBrew : AppTheme.borderLight,
                                  ),
                              ],
                            ),
                            const SizedBox(width: 16),

                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (isDone) {
                                        _completedNodes.remove(index);
                                      } else {
                                        _completedNodes.add(index);
                                      }
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(14),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    decoration: BoxDecoration(
                                      color: AppTheme.white,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: isDone
                                            ? AppTheme.matchaBrew
                                            : isCurrent
                                                ? AppTheme.almond
                                                : AppTheme.borderLight,
                                        width: isCurrent ? 1.8 : 1,
                                      ),
                                    ),
                                    child: Text(
                                      nodeTitle,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}


