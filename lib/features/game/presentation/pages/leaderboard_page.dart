import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  List<int> _highScores = [];

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  Future<void> _loadScores() async {
    final prefs = await SharedPreferences.getInstance();
    final scoresJson = prefs.getStringList('high_scores') ?? [];
    setState(() {
      _highScores = scoresJson.map((s) => int.tryParse(s) ?? 0).toList();
      _highScores.sort((a, b) => b.compareTo(a));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: Colors.indigo.shade900,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.indigo.shade900,
              Colors.purple.shade900,
              Colors.black,
            ],
          ),
        ),
        child: _highScores.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.emoji_events,
                      size: 80.sp,
                      color: Colors.yellow.withOpacity(0.5),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'No Scores Yet',
                      style: TextStyle(
                        fontSize: 24.sp,
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Play the game to earn high scores!',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: _highScores.length,
                itemBuilder: (context, index) {
                  return _ScoreCard(
                    rank: index + 1,
                    score: _highScores[index],
                  );
                },
              ),
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final int rank;
  final int score;

  const _ScoreCard({required this.rank, required this.score});

  @override
  Widget build(BuildContext context) {
    Color rankColor;
    IconData rankIcon;
    
    if (rank == 1) {
      rankColor = Colors.yellow;
      rankIcon = Icons.emoji_events;
    } else if (rank == 2) {
      rankColor = Colors.grey.shade300;
      rankIcon = Icons.emoji_events;
    } else if (rank == 3) {
      rankColor = Colors.brown.shade300;
      rankIcon = Icons.emoji_events;
    } else {
      rankColor = Colors.white;
      rankIcon = Icons.star;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: rankColor.withOpacity(0.5),
          width: 2.w,
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 50.w,
          height: 50.h,
          decoration: BoxDecoration(
            color: rankColor.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '#$rank',
              style: TextStyle(
                color: rankColor,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),
          ),
        ),
        title: Row(
          children: [
            Icon(rankIcon, color: rankColor, size: 24.sp),
            SizedBox(width: 8.w),
            Text(
              'Score: $score',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.trending_up,
          color: Colors.green,
          size: 24.sp,
        ),
      ),
    );
  }
}

