import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double _soundVolume = 1.0;
  double _musicVolume = 1.0;
  bool _vibrationEnabled = true;
  bool _screenShakeEnabled = true;
  String _difficulty = 'Normal';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _soundVolume = prefs.getDouble('sound_volume') ?? 1.0;
      _musicVolume = prefs.getDouble('music_volume') ?? 1.0;
      _vibrationEnabled = prefs.getBool('vibration_enabled') ?? true;
      _screenShakeEnabled = prefs.getBool('screen_shake_enabled') ?? true;
      _difficulty = prefs.getString('difficulty') ?? 'Normal';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('sound_volume', _soundVolume);
    await prefs.setDouble('music_volume', _musicVolume);
    await prefs.setBool('vibration_enabled', _vibrationEnabled);
    await prefs.setBool('screen_shake_enabled', _screenShakeEnabled);
    await prefs.setString('difficulty', _difficulty);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Settings saved!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
        child: ListView(
          padding: EdgeInsets.all(16.w),
          children: [
            // Audio Settings
            _buildSectionHeader('Audio Settings', Icons.volume_up),
            _buildCard(
              child: Column(
                children: [
                  _buildSliderSetting(
                    'Sound Effects',
                    _soundVolume,
                    (value) => setState(() => _soundVolume = value),
                    Icons.speaker,
                  ),
                  SizedBox(height: 16.h),
                  _buildSliderSetting(
                    'Music',
                    _musicVolume,
                    (value) => setState(() => _musicVolume = value),
                    Icons.music_note,
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Gameplay Settings
            _buildSectionHeader('Gameplay Settings', Icons.gamepad),
            _buildCard(
              child: Column(
                children: [
                  _buildSwitchSetting(
                    'Vibration',
                    _vibrationEnabled,
                    (value) => setState(() => _vibrationEnabled = value),
                    Icons.vibration,
                  ),
                  SizedBox(height: 16.h),
                  _buildSwitchSetting(
                    'Screen Shake',
                    _screenShakeEnabled,
                    (value) => setState(() => _screenShakeEnabled = value),
                    Icons.swipe_vertical,
                  ),
                  SizedBox(height: 16.h),
                  _buildDropdownSetting(
                    'Difficulty',
                    _difficulty,
                    ['Easy', 'Normal', 'Hard', 'Expert'],
                    (value) => setState(() => _difficulty = value!),
                    Icons.trending_up,
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // About Section
            _buildSectionHeader('About', Icons.info),
            _buildCard(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.star, color: Colors.yellow),
                    title: const Text('Version'),
                    subtitle: const Text('1.0.0'),
                  ),
                  ListTile(
                    leading: Icon(Icons.code, color: Colors.blue),
                    title: const Text('Made with Flutter'),
                    subtitle: const Text('Powered by Dart'),
                  ),
                ],
              ),
            ),

            SizedBox(height: 32.h),

            // Save Button
            ElevatedButton.icon(
              onPressed: _saveSettings,
              icon: Icon(Icons.save, size: 24.sp),
              label: const Text('Save Settings'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 24.sp),
          SizedBox(width: 8.w),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.w,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: child,
      ),
    );
  }

  Widget _buildSliderSetting(
    String label,
    double value,
    ValueChanged<double> onChanged,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Text(
              '${(value * 100).toInt()}%',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.blue,
          inactiveColor: Colors.grey,
        ),
      ],
    );
  }

  Widget _buildSwitchSetting(
    String label,
    bool value,
    ValueChanged<bool> onChanged,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 20.sp),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildDropdownSetting(
    String label,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 20.sp),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        DropdownButton<String>(
          value: value,
          items: options.map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(option, style: const TextStyle(color: Colors.black)),
            );
          }).toList(),
          onChanged: onChanged,
          dropdownColor: Colors.white,
          style: TextStyle(color: Colors.white, fontSize: 16.sp),
        ),
      ],
    );
  }
}

