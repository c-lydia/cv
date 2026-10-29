import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/cv_data.dart';
import '../widgets/export_cv_button.dart';
import '../widgets/sidebar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.profile});
  final CvData? profile;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<CvData> _data = widget.profile == null
      ? CvData.load()
      : Future.value(widget.profile);
  final _sections = {for (final title in cvSections) title: GlobalKey()};
  String _selected = 'Profile';

  void _go(String title) {
    setState(() => _selected = title);
    final target = _sections[title]?.currentContext;
    if (target != null) {
      Scrollable.ensureVisible(
        target,
        duration: MediaQuery.disableAnimationsOf(context)
            ? Duration.zero
            : const Duration(milliseconds: 250),
        alignment: 0,
      );
    }
  }

  Future<void> _open(String url) async {
    try {
      if (await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      )) {
        return;
      }
    } catch (_) {
      /* Show a useful error if the platform has no handler. */
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open the link. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: colors.outline.withValues(alpha: .3),
                  ),
                ),
              ),
              child: LayoutBuilder(
                builder: (context, bounds) {
                  final name = Text(
                    'Chheng Lydiya',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: colors.onSurface,
                    ),
                  );
                  if (bounds.maxWidth < 600) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: name),
                            const ThemeButton(),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const ExportCvButton(),
                      ],
                    );
                  }
                  return Row(
                    children: [
                      Expanded(child: name),
                      const ExportCvButton(),
                      const SizedBox(width: 10),
                      const ThemeButton(),
                    ],
                  );
                },
              ),
            ),
            Expanded(
              child: FutureBuilder<CvData>(
                future: _data,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Could not load the CV.'),
                          TextButton(
                            onPressed: () =>
                                setState(() => _data = CvData.load()),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final data = snapshot.requireData;
                  return LayoutBuilder(
                    builder: (context, bounds) {
                      final wide = bounds.maxWidth >= 1000;
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (wide) Sidebar(selected: _selected, onSelect: _go),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 940,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                      wide ? 40 : 20,
                                      32,
                                      wide ? 40 : 20,
                                      56,
                                    ),
                                    child: SelectionArea(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (!wide)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 30,
                                              ),
                                              child: Wrap(
                                                spacing: 8,
                                                runSpacing: 8,
                                                children: [
                                                  for (final title
                                                      in cvSections)
                                                    ActionChip(
                                                      label: Text(title),
                                                      onPressed: () =>
                                                          _go(title),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          _section(
                                            'Profile',
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  data.text('name'),
                                                  style: TextStyle(
                                                    fontSize: wide ? 42 : 34,
                                                    fontWeight: FontWeight.w500,
                                                    height: 1.2,
                                                    letterSpacing: -1,
                                                  ),
                                                ),
                                                const SizedBox(height: 14),
                                                Text(
                                                  data.text('headline'),
                                                  style: TextStyle(
                                                    fontSize: 19,
                                                    color: colors.secondary,
                                                  ),
                                                ),
                                                const SizedBox(height: 12),
                                                Text(data.text('location')),
                                                const SizedBox(height: 20),
                                                Text(
                                                  data.text('summary'),
                                                  style: Theme.of(
                                                    context,
                                                  ).textTheme.bodyLarge,
                                                ),
                                                const SizedBox(height: 18),
                                                Wrap(
                                                  spacing: 12,
                                                  runSpacing: 8,
                                                  children: [
                                                    TextButton.icon(
                                                      onPressed: () => _open(
                                                        'mailto:${data.text('email')}',
                                                      ),
                                                      icon: const Icon(
                                                        Icons.mail_outline,
                                                        size: 18,
                                                      ),
                                                      label: Text(
                                                        data.text('email'),
                                                      ),
                                                    ),
                                                    TextButton.icon(
                                                      onPressed: () => _open(
                                                        data.text('github'),
                                                      ),
                                                      icon: const Icon(
                                                        Icons.code,
                                                        size: 18,
                                                      ),
                                                      label: const Text(
                                                        'GitHub',
                                                      ),
                                                    ),
                                                    TextButton.icon(
                                                      onPressed: () => _open(
                                                        data.text('portfolio'),
                                                      ),
                                                      icon: const Icon(
                                                        Icons.open_in_new,
                                                        size: 18,
                                                      ),
                                                      label: const Text(
                                                        'Portfolio',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                const Text(
                                                  'PDF export: two-page A4 layout, selectable text and clickable links.',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            heading: false,
                                          ),
                                          _section(
                                            'Experience',
                                            Column(
                                              children: [
                                                for (final item in data.entries(
                                                  'experience',
                                                ))
                                                  _entry(item),
                                              ],
                                            ),
                                          ),
                                          _section(
                                            'Education',
                                            _education(
                                              data.json['education']
                                                  as Map<String, dynamic>,
                                            ),
                                          ),
                                          _section(
                                            'Skills',
                                            LayoutBuilder(
                                              builder: (context, size) => Wrap(
                                                spacing: 16,
                                                runSpacing: 16,
                                                children: [
                                                  for (final item
                                                      in data.entries('skills'))
                                                    Container(
                                                      width:
                                                          size.maxWidth >= 620
                                                          ? (size.maxWidth -
                                                                    16) /
                                                                2
                                                          : size.maxWidth,
                                                      padding:
                                                          const EdgeInsets.all(
                                                            20,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: colors.surface,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              16,
                                                            ),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            item['title']
                                                                as String,
                                                            style: TextStyle(
                                                              color: colors
                                                                  .primary,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 9,
                                                          ),
                                                          Text(
                                                            item['items']
                                                                as String,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          _section(
                                            'Projects',
                                            Column(
                                              children: [
                                                for (final item in data.entries(
                                                  'projects',
                                                ))
                                                  _entry(item),
                                              ],
                                            ),
                                          ),
                                          _section(
                                            'Community',
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                for (final item
                                                    in data.json['community']
                                                        as List)
                                                  _bullet(item as String),
                                              ],
                                            ),
                                          ),
                                          _section(
                                            'Languages',
                                            Text(
                                              data.text('languages'),
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodyLarge,
                                            ),
                                          ),
                                          const Divider(),
                                          const SizedBox(height: 16),
                                          const ExportCvButton(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, Widget child, {bool heading = true}) => Padding(
    key: _sections[title],
    padding: const EdgeInsets.only(bottom: 40),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (heading) ...[
          Text(
            title,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 20),
        ],
        child,
      ],
    ),
  );

  Widget _education(Map<String, dynamic> item) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        item['organization'] as String,
        style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 8),
      Text(item['title'] as String),
      Text(item['period'] as String),
      Text(item['detail'] as String),
    ],
  );

  Widget _entry(Map<String, dynamic> item) => Container(
    width: double.infinity,
    padding: const EdgeInsets.only(top: 18, bottom: 22),
    decoration: BoxDecoration(
      border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item['title'] as String,
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        Text(
          (item['organization'] ?? item['subtitle']) as String,
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        if (item['period'] is String && (item['period'] as String).isNotEmpty)
          Text(item['period'] as String, style: const TextStyle(fontSize: 13)),
        const SizedBox(height: 10),
        for (final bullet in item['bullets'] as List) _bullet(bullet as String),
        if (item['url'] != null)
          TextButton.icon(
            onPressed: () => _open(item['url'] as String),
            icon: const Icon(Icons.open_in_new, size: 16),
            label: const Text('Source & details'),
          ),
      ],
    ),
  );

  Widget _bullet(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('•  '),
        Expanded(child: Text(text)),
      ],
    ),
  );
}
