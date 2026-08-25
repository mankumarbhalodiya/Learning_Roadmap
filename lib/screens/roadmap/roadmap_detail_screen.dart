import 'package:flutter/material.dart';
import '../../models/skill_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/ambient_background.dart';

class RoadmapDetailScreen extends StatefulWidget {
  final SkillItem skill;
  final String experienceLevel;
  final int assessmentScore;
  final int totalQuestions;

  const RoadmapDetailScreen({
    super.key,
    required this.skill,
    this.experienceLevel = 'All Levels',
    this.assessmentScore = 0,
    this.totalQuestions = 0,
  });

  @override
  State<RoadmapDetailScreen> createState() => _RoadmapDetailScreenState();
}

class _RoadmapDetailScreenState extends State<RoadmapDetailScreen> {
  final Set<int> _completedNodes = {0}; // First node unlocked/completed

  @override
  void initState() {
    super.initState();
    ActiveRoadmapManager.setActiveSkill(widget.skill);
  }

  @override
  Widget build(BuildContext context) {
    final nodes = _generateRoadmapNodes(widget.skill.title);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Roadmap'),
        centerTitle: true,
      ),
      body: AmbientBackground(
        child: SafeArea(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            itemCount: nodes.length,
            itemBuilder: (context, index) {
              final node = nodes[index];
              final isDone = _completedNodes.contains(index);
              final isCurrent = index == 0 || _completedNodes.contains(index - 1);

              return _RoadmapNodeTile(
                index: index + 1,
                title: node['title']!,
                isDone: isDone,
                isCurrent: isCurrent,
                isLast: index == nodes.length - 1,
                onToggle: () {
                  setState(() {
                    if (isDone) {
                      _completedNodes.remove(index);
                    } else {
                      _completedNodes.add(index);
                    }
                  });
                },
              );
            },
          ),
        ),
      ),
    );
  }

  List<Map<String, String>> _generateRoadmapNodes(String title) {
    return [
      {'title': 'Phase 1: Core Foundations & Setup'},
      {'title': 'Phase 2: Data Structures & OOP Patterns'},
      {'title': 'Phase 3: Frameworks & API Architecture'},
      {'title': 'Phase 4: Database Integration & ORM'},
      {'title': 'Phase 5: Capstone Project & Deployment'},
    ];
  }
}

class _RoadmapNodeTile extends StatelessWidget {
  final int index;
  final String title;
  final bool isDone;
  final bool isCurrent;
  final bool isLast;
  final VoidCallback onToggle;

  const _RoadmapNodeTile({
    required this.index,
    required this.title,
    required this.isDone,
    required this.isCurrent,
    required this.isLast,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Timeline node indicator
        Column(
          children: [
            GestureDetector(
              onTap: onToggle,
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
                        '$index',
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
                height: 48,
                color: isDone ? AppTheme.matchaBrew : AppTheme.borderLight,
              ),
          ],
        ),
        const SizedBox(width: 16),

        // Clean Content Card
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: onToggle,
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
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.matchaBrew.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
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
  }
}
