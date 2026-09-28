import 'package:flutter/material.dart';
import '../../models/skill_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/ambient_background.dart';
import '../roadmap/roadmap_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  bool _isSearchActive = false;

  final List<String> _searchHistory = [
    'Flutter',
    'Full Stack',
    'DevOps',
    'AI Engineer',
    'Python',
  ];

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_searchFocusNode.hasFocus && !_isSearchActive) {
      setState(() {
        _isSearchActive = true;
      });
    }
  }

  @override
  void dispose() {
    _searchFocusNode.removeListener(_onFocusChange);
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _exitSearchMode() {
    setState(() {
      _isSearchActive = false;
      _searchQuery = '';
      _searchController.clear();
      _searchFocusNode.unfocus();
    });
  }

  void _onSearchSubmitted(String query) {
    final trimmed = query.trim();
    if (trimmed.isNotEmpty && !_searchHistory.contains(trimmed)) {
      setState(() {
        _searchHistory.insert(0, trimmed);
        if (_searchHistory.length > 8) {
          _searchHistory.removeLast();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final allSkills = SkillRepository.categories.expand((c) => c.skills).toList();
    final query = _searchQuery.trim().toLowerCase();

    final filteredSkills = allSkills.where((skill) {
      if (query.isEmpty) return false;
      return skill.title.toLowerCase().contains(query) ||
          skill.category.toLowerCase().contains(query) ||
          skill.description.toLowerCase().contains(query) ||
          skill.keyCompetencies.any((c) => c.toLowerCase().contains(query));
    }).toList();

    final trendingSkills = allSkills.where((s) => [
      'Flutter Developer',
      'Python Developer',
      'Full Stack Developer',
      'AI Engineer',
      'DevOps Engineer',
      'Data Scientist',
    ].contains(s.title)).toList();

    return PopScope(
      canPop: !_isSearchActive,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_isSearchActive) {
          _exitSearchMode();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AmbientBackground(
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Section (hidden during active search)
                  if (!_isSearchActive) ...[
                    const Text(
                      'Explore Roadmaps',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Search or select any career role or technology to start your guided learning journey.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ] else ...[
                    const SizedBox(height: 4),
                  ],

                  // Search Input Field (No filter button)
                  TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    onTap: () {
                      if (!_isSearchActive) {
                        setState(() {
                          _isSearchActive = true;
                        });
                      }
                    },
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                        if (!_isSearchActive) _isSearchActive = true;
                      });
                    },
                    onSubmitted: _onSearchSubmitted,
                    decoration: InputDecoration(
                      hintText: 'Search skills, roadmaps, topics...',
                      prefixIcon: _isSearchActive
                          ? IconButton(
                              icon: const Icon(
                                Icons.arrow_back_rounded,
                                color: AppTheme.textPrimary,
                              ),
                              onPressed: _exitSearchMode,
                            )
                          : const Icon(Icons.search_rounded),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 20),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // CONDITIONAL CONTENT:
                  // 1) Search Mode with Query: Live Results
                  // 2) Search Mode without Query: Recent Searches & Trending Roadmaps
                  // 3) Normal Explore Mode: Categorized Roadmaps Overview
                  if (_isSearchActive) ...[
                    if (query.isNotEmpty) ...[
                      // Search Results Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Roadmaps (${filteredSkills.length})',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                              });
                            },
                            child: const Text(
                              'Clear',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.matchaBrew,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      if (filteredSkills.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppTheme.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppTheme.borderLight),
                                  ),
                                  child: const Icon(
                                    Icons.search_off_rounded,
                                    size: 40,
                                    color: AppTheme.textMuted,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No roadmaps found for "$_searchQuery"',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Try checking your spelling or search for another keyword.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.textSecondary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredSkills.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final skill = filteredSkills[index];
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
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 6,
                                  ),
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
                                    color: AppTheme.matchaBrew,
                                  ),
                                  onTap: () {
                                    _onSearchSubmitted(skill.title);
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
                    ] else ...[
                      // RECENT SEARCHES
                      if (_searchHistory.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Recent Searches',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _searchHistory.clear();
                                });
                              },
                              child: const Text(
                                'Clear All',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.matchaBrew,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _searchHistory.map((item) {
                            return ActionChip(
                              avatar: const Icon(
                                Icons.history_rounded,
                                size: 14,
                                color: AppTheme.textSecondary,
                              ),
                              label: Text(item),
                              backgroundColor: AppTheme.white,
                              elevation: 0,
                              side: const BorderSide(color: AppTheme.borderLight),
                              labelStyle: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.textPrimary,
                              ),
                              onPressed: () {
                                _searchController.text = item;
                                setState(() {
                                  _searchQuery = item;
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // TRENDING ROADMAPS
                      Row(
                        children: [
                          const Icon(
                            Icons.local_fire_department_rounded,
                            color: Colors.deepOrangeAccent,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Trending Roadmaps',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: trendingSkills.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final skill = trendingSkills[index];
                          return Material(
                            color: AppTheme.white,
                            borderRadius: BorderRadius.circular(14),
                            clipBehavior: Clip.antiAlias,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppTheme.borderLight),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 4,
                                ),
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.matchaBrew.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.trending_up_rounded,
                                    color: AppTheme.matchaBrew,
                                    size: 18,
                                  ),
                                ),
                                title: Text(
                                  skill.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                subtitle: Text(
                                  skill.category,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.north_west_rounded,
                                    size: 18,
                                    color: AppTheme.textMuted,
                                  ),
                                  onPressed: () {
                                    _searchController.text = skill.title;
                                    setState(() {
                                      _searchQuery = skill.title;
                                    });
                                  },
                                ),
                                onTap: () {
                                  _onSearchSubmitted(skill.title);
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
                  ] else ...[
                    // NORMAL EXPLORE VIEW
                    const Text(
                      'All Roadmaps by Category',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: SkillRepository.categories.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 24),
                      itemBuilder: (context, index) {
                        final cat = SkillRepository.categories[index];
                        return _CategorySection(category: cat);
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  final SkillCategoryData category;

  const _CategorySection({required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: category.skills.map((skill) {
            return _SkillChip(skill: skill);
          }).toList(),
        ),
      ],
    );
  }
}

class _SkillChip extends StatelessWidget {
  final SkillItem skill;

  const _SkillChip({required this.skill});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          ActiveRoadmapManager.setActiveSkill(skill);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => RoadmapDetailScreen(skill: skill),
            ),
          );
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppTheme.borderLight,
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.matchaBrew.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            skill.title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
