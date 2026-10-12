import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const StudySpaceApp());
}

class StudySpaceApp extends StatelessWidget {
  const StudySpaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StudySpace',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
        ),
      ),
      home: const StudyHomePage(),
    );
  }
}

class StudyHomePage extends StatefulWidget {
  const StudyHomePage({super.key});

  @override
  State<StudyHomePage> createState() => _StudyHomePageState();
}

class _StudyHomePageState extends State<StudyHomePage> {
  int selectedIndex = 0;
  bool isStudying = false;
  int seconds = 25 * 60;
  Timer? timer;

  final List<Map<String, dynamic>> subjects = [
    {
      'name': 'Java Programming',
      'icon': Icons.code,
      'progress': 0.82,
      'topics': '18 / 22 topics',
    },
    {
      'name': 'Database Systems',
      'icon': Icons.storage,
      'progress': 0.68,
      'topics': '13 / 19 topics',
    },
    {
      'name': 'Machine Learning',
      'icon': Icons.psychology,
      'progress': 0.55,
      'topics': '11 / 20 topics',
    },
  ];

  final List<Map<String, dynamic>> tasks = [
    {
      'title': 'Complete Java OOP revision',
      'time': '10:00 AM',
      'done': true,
    },
    {
      'title': 'Practice SQL queries',
      'time': '02:00 PM',
      'done': false,
    },
    {
      'title': 'Review ML concepts',
      'time': '05:30 PM',
      'done': false,
    },
  ];

  void startTimer() {
    if (isStudying) {
      timer?.cancel();
      setState(() {
        isStudying = false;
      });
    } else {
      setState(() {
        isStudying = true;
      });

      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (seconds > 0) {
          setState(() {
            seconds--;
          });
        } else {
          timer.cancel();
          setState(() {
            isStudying = false;
          });
        }
      });
    }
  }

  String formatTime() {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 700) {
            return buildMobileLayout();
          }

          return buildDesktopLayout();
        },
      ),
    );
  }

  // ------------------------------------------------------------
  // DESKTOP LAYOUT
  // ------------------------------------------------------------

  Widget buildDesktopLayout() {
    return Row(
      children: [
        buildSidebar(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: buildDashboard(),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // MOBILE LAYOUT
  // ------------------------------------------------------------

  Widget buildMobileLayout() {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'StudySpace',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: buildDashboard(),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book),
            label: 'Subjects',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // SIDEBAR
  // ------------------------------------------------------------

  Widget buildSidebar() {
    return Container(
      width: 240,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 35),

          const Icon(
            Icons.school,
            size: 45,
            color: Color(0xFF6750A4),
          ),

          const SizedBox(height: 12),

          const Text(
            'StudySpace',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 45),

          sidebarItem(Icons.home, 'Dashboard', 0),
          sidebarItem(Icons.book, 'My Subjects', 1),
          sidebarItem(Icons.task_alt, 'Tasks', 2),
          sidebarItem(Icons.bar_chart, 'Progress', 3),
          sidebarItem(Icons.settings, 'Settings', 4),

          const Spacer(),

          Container(
            margin: const EdgeInsets.all(18),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0ECFA),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.lightbulb,
                  color: Color(0xFF6750A4),
                  size: 30,
                ),
                SizedBox(height: 10),
                Text(
                  'Stay consistent!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Small progress every day leads to big results.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget sidebarItem(IconData icon, String title, int index) {
    bool selected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFF0ECFA)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: selected
                  ? const Color(0xFF6750A4)
                  : Colors.grey,
            ),
            const SizedBox(width: 14),
            Text(
              title,
              style: TextStyle(
                color: selected
                    ? const Color(0xFF6750A4)
                    : Colors.grey.shade700,
                fontWeight:
                    selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // MAIN DASHBOARD
  // ------------------------------------------------------------

  Widget buildDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeader(),

        const SizedBox(height: 30),

        buildWelcomeCard(),

        const SizedBox(height: 30),

        buildStatistics(),

        const SizedBox(height: 30),

        const Text(
          'Your Subjects',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 15),

        buildSubjects(),

        const SizedBox(height: 30),

        buildBottomSection(),
      ],
    );
  }

  // ------------------------------------------------------------
  // HEADER
  // ------------------------------------------------------------

  Widget buildHeader() {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning 👋',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Ready to learn today?',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        if (MediaQuery.of(context).size.width > 850)
          SizedBox(
            width: 260,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

        const SizedBox(width: 15),

        const CircleAvatar(
          radius: 24,
          backgroundColor: Color(0xFFE8E0F8),
          child: Icon(
            Icons.person,
            color: Color(0xFF6750A4),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // WELCOME CARD
  // ------------------------------------------------------------

  Widget buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF6750A4),
            Color(0xFF8A70C5),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runSpacing: 20,
        children: [
          const SizedBox(
            width: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Keep going! 🚀',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'You have completed 72% of your weekly study goal. Keep your learning streak alive!',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),

          ElevatedButton.icon(
            onPressed: startTimer,
            icon: Icon(
              isStudying
                  ? Icons.pause
                  : Icons.play_arrow,
            ),
            label: Text(
              isStudying
                  ? 'Pause'
                  : 'Start Studying',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF6750A4),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // STATISTICS
  // ------------------------------------------------------------

  Widget buildStatistics() {
    return Wrap(
      spacing: 18,
      runSpacing: 18,
      children: [
        statisticCard(
          Icons.local_fire_department,
          '7 Days',
          'Study Streak',
        ),
        statisticCard(
          Icons.access_time,
          formatTime(),
          'Focus Timer',
        ),
        statisticCard(
          Icons.check_circle,
          '24',
          'Tasks Completed',
        ),
        statisticCard(
          Icons.emoji_events,
          '1,280',
          'Learning Points',
        ),
      ],
    );
  }

  Widget statisticCard(
    IconData icon,
    String value,
    String title,
  ) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF0ECFA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF6750A4),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // SUBJECTS
  // ------------------------------------------------------------

  Widget buildSubjects() {
    return Wrap(
      spacing: 18,
      runSpacing: 18,
      children: subjects.map((subject) {
        return subjectCard(subject);
      }).toList(),
    );
  }

  Widget subjectCard(Map<String, dynamic> subject) {
    double progress = subject['progress'];

    return Container(
      width: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0ECFA),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  subject['icon'],
                  color: const Color(0xFF6750A4),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  subject['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progress',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFF6750A4),
            backgroundColor: const Color(0xFFEDEAF3),
          ),

          const SizedBox(height: 10),

          Text(
            subject['topics'],
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // TASKS + TIMER
  // ------------------------------------------------------------

  Widget buildBottomSection() {
    return Wrap(
      spacing: 25,
      runSpacing: 25,
      children: [
        buildTasks(),
        buildFocusCard(),
      ],
    );
  }

  Widget buildTasks() {
    return Container(
      width: 430,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Today's Tasks",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          ...tasks.map(
            (task) => Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
              ),
              child: Row(
                children: [
                  Icon(
                    task['done']
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: task['done']
                        ? Colors.green
                        : Colors.grey,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      task['title'],
                      style: TextStyle(
                        decoration: task['done']
                            ? TextDecoration.lineThrough
                            : null,
                        color: task['done']
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    task['time'],
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFocusCard() {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7E8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.timer,
            size: 45,
            color: Colors.orange,
          ),

          const SizedBox(height: 12),

          const Text(
            'Focus Session',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            formatTime(),
            style: const TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            isStudying
                ? 'Focus mode is active'
                : '25 minute study session',
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}