import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_controller.dart';

const cvSections = [
  'Profile',
  'Experience',
  'Education',
  'Skills',
  'Projects',
  'Community',
  'Languages',
];

class ThemeButton extends StatelessWidget {
  const ThemeButton({super.key});
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return IconButton(
      tooltip: dark ? 'Switch to light theme' : 'Switch to dark theme',
      icon: Icon(dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
      onPressed: context.read<ThemeController>().toggle,
    );
  }
}

class Sidebar extends StatelessWidget {
  const Sidebar({super.key, required this.selected, required this.onSelect});
  final String selected;
  final ValueChanged<String> onSelect;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 216,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 30, 12, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CURRICULUM VITAE',
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 1.4,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 22),
          for (final section in cvSections)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: ListTile(
                dense: true,
                selected: selected == section,
                selectedTileColor: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: .1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                title: Text(section),
                onTap: () => onSelect(section),
              ),
            ),
          const Spacer(),
          const Text(
            'Embedded systems\nRobotics · Software',
            style: TextStyle(fontSize: 13),
          ),
        ],
      ),
    ),
  );
}
