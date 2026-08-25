import 'package:flutter/material.dart';
import '../../models/skill_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/ambient_background.dart';
import '../roadmap/roadmap_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
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

  final List<String> _categories = [
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
    if (query.trim().isNotEmpty && !_searchHistory.contains(query.trim())) {
      setState(() {
        _searchHistory.insert(0, query.trim());
        if (_searchHistory.length > 8) _searchHistory.removeLast();
      });
    }
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter Category',
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
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
                  const SizedBox(height: 20),
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
    final filteredSkills = allSkills.where((skill) {
      final matchesQuery = _searchQuery.isEmpty ||
          skill.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          skill.category.toLowerCase().contains(_searchQuery.toLowerCase());

      if (_selectedCategory == 'All') return matchesQuery;
      final categoryKeyword = _selectedCategory.toLowerCase().split(' ').first;
      return matchesQuery && skill.category.toLowerCase().contains(categoryKeyword);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AmbientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                            color: _selectedCategory != 'All' ? AppTheme.matchaBrew : AppTheme.textSecondary,
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
                const SizedBox(height: 16),

                // Body Content
                Expanded(
                  child: (_searchQuery.isEmpty && _selectedCategory == 'All')
                      ? SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Search History Section
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
                                      avatar: const Icon(Icons.history_rounded, size: 14, color: AppTheme.textSecondary),
                                      label: Text(item),
                                      backgroundColor: AppTheme.white,
                                      elevation: 0,
                                      side: const BorderSide(color: AppTheme.borderLight),
                                      labelStyle: const TextStyle(fontSize: 12, color: AppTheme.textPrimary),
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

                              // Popular Suggestions
                              const Text(
                                'Popular Roadmaps',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: allSkills.take(5).length,
                                separatorBuilder: (context, index) => const SizedBox(height: 8),
                                itemBuilder: (context, index) {
                                  final skill = allSkills[index];
                                  return Material(
                                    color: AppTheme.white,
                                    borderRadius: BorderRadius.circular(14),
                                    clipBehavior: Clip.antiAlias,
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                      leading: const Icon(Icons.trending_up_rounded, color: AppTheme.matchaBrew),
                                      title: Text(
                                        skill.title,
                                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                      ),
                                      subtitle: Text(
                                        skill.category,
                                        style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                                      ),
                                      trailing: const Icon(Icons.north_west_rounded, size: 16, color: AppTheme.textMuted),
                                      onTap: () {
                                        _searchController.text = skill.title;
                                        setState(() {
                                          _searchQuery = skill.title;
                                        });
                                      },
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        )
                      : filteredSkills.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.search_off_rounded, size: 54, color: AppTheme.textMuted),
                                  const SizedBox(height: 12),
                                  Text(
                                    _searchQuery.isNotEmpty
                                        ? 'No results found for "$_searchQuery"'
                                        : 'No roadmaps in $_selectedCategory',
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Try checking your spelling or select another category.',
                                    style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                                  ),
                                ],
                              ),
                            )
                          : ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemCount: filteredSkills.length,
                              separatorBuilder: (context, index) => const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final skill = filteredSkills[index];
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
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                      leading: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppTheme.almond.withValues(alpha: 0.25),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Icon(Icons.route_rounded, color: AppTheme.eclipse, size: 20),
                                      ),
                                      title: Text(
                                        skill.title,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                      subtitle: Text(
                                        skill.category,
                                        style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                                      ),
                                      trailing: const Icon(Icons.chevron_right_rounded, color: AppTheme.matchaBrew),
                                      onTap: () {
                                        _onSearchSubmitted(skill.title);
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
