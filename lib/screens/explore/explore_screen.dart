import 'package:flutter/material.dart';
import '../../models/skill_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/ambient_background.dart';
import '../../widgets/app_logo.dart';
import '../roadmap/roadmap_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _searchHistory = [
    'Flutter',
    'Full Stack',
    'DevOps',
    'AI Engineer',
    'Python',
  ];

  static const List<String> _categories = [
    'All',
    'Software & Web',
    'AI & Data',
    'Mobile',
    'Cloud',
    'Design',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  bool _matchesCategory(String skillCategory, String filter) {
    if (filter == 'All') return true;
    final catLower = skillCategory.toLowerCase();
    switch (filter) {
      case 'Software & Web':
        return catLower.contains('software') || catLower.contains('web');
      case 'AI & Data':
        return catLower.contains('ai') || catLower.contains('data');
      case 'Mobile':
        return catLower.contains('mobile');
      case 'Cloud':
        return catLower.contains('cloud') || catLower.contains('cybersecurity');
      case 'Design':
        return catLower.contains('design') || catLower.contains('product');
      default:
        return catLower.contains(filter.toLowerCase());
    }
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter Roadmaps',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _categories.map((cat) {
                      final isSelected = _selectedCategory == cat;
                      return ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        selectedColor: AppTheme.matchaBrew,
                        backgroundColor: AppTheme.inputFill,
                        labelStyle: TextStyle(
                          color: isSelected ? AppTheme.white : AppTheme.textPrimary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedCategory = cat);
                            setModalState(() {});
                            Navigator.pop(context);
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final allSkills = SkillRepository.categories.expand((c) => c.skills).toList();
    final query = _searchQuery.trim().toLowerCase();

    final filteredSkills = allSkills.where((skill) {
      final matchesQuery = query.isEmpty ||
          skill.title.toLowerCase().contains(query) ||
          skill.category.toLowerCase().contains(query) ||
          skill.description.toLowerCase().contains(query) ||
          skill.keyCompetencies.any((c) => c.toLowerCase().contains(query));

      return matchesQuery && _matchesCategory(skill.category, _selectedCategory);
    }).toList();

    final isSearchingOrFiltered = query.isNotEmpty || _selectedCategory != 'All';

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
                // Header Section with Cutebuddie Branding
                const Row(
                  children: [
                    AppLogo(size: 28, showText: true),
                  ],
                ),
                const SizedBox(height: 20),

                // Title Section
                const Text(
                  'Explore Skills & Roadmaps',
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

                // Search Input Field
                TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                  onSubmitted: _onSearchSubmitted,
                  decoration: InputDecoration(
                    hintText: 'Search skills, roadmaps, topics...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_searchQuery.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          ),
                        IconButton(
                          icon: Icon(
                            Icons.tune_rounded,
                            color: _selectedCategory != 'All'
                                ? AppTheme.matchaBrew
                                : AppTheme.textSecondary,
                          ),
                          onPressed: _showFilterModal,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Category Filter Chips Carousel
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: _categories.map((cat) {
                      final isSelected = _selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(cat),
                          selected: isSelected,
                          selectedColor: AppTheme.matchaBrew,
                          backgroundColor: AppTheme.white,
                          elevation: 0,
                          side: BorderSide(
                            color: isSelected ? AppTheme.matchaBrew : AppTheme.borderLight,
                          ),
                          labelStyle: TextStyle(
                            fontSize: 13,
                            color: isSelected ? AppTheme.white : AppTheme.textPrimary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          ),
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = selected ? cat : 'All';
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),

                // Content View: Filtered Search Results OR Default Categorized View
                if (isSearchingOrFiltered) ...[
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
                            _selectedCategory = 'All';
                          });
                        },
                        child: const Text(
                          'Reset',
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
                              query.isNotEmpty
                                  ? 'No roadmaps found for "$_searchQuery"'
                                  : 'No roadmaps in $_selectedCategory',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Try checking your spelling or selecting another category.',
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
                  // Recent Searches
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

                  // Full Categories List
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
