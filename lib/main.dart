import 'dart:async'; // For Timer
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For HapticFeedback

void main() {
  runApp(const MyApp());
}

// Main app widget
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}



// App state
class _MyAppState extends State<MyApp> {
  int count = 0; // Counter value

  Timer? _incrementTimer; // Timer for long press increment
  Timer? _decrementTimer; // Timer for long press decrement

  ThemeMode _themeMode = ThemeMode.system; // Current theme mode

  bool _isIncrementPressed = false; // Button press animation state
  bool _isDecrementPressed = false;

  // Toggle between light and dark themes
  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  // Show a short snackbar with the given message
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(milliseconds: 500)),
    );
  }

  // Start long press increment logic
  void _startLongIncrement(BuildContext context) {
    int elapsed = 0; // Track duration
    _incrementTimer =
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (elapsed >= 5000) {
        _stopLongIncrement(context); // Stop after 5 seconds
        return;
      }
      setState(() {
        count++;
      });
      HapticFeedback.lightImpact(); // Haptic feedback every step
      elapsed += 100;
    });
  }

  // Stop long press increment
  void _stopLongIncrement(BuildContext context) {
    _incrementTimer?.cancel();
    _showSnackBar(context, "Incremented (Long Press)!");
  }

  // Start long press decrement logic
  void _startLongDecrement(BuildContext context) {
    int elapsed = 0; // Track duration
    _decrementTimer =
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (elapsed >= 5000) {
        _stopLongDecrement(context); // Stop after 5 seconds
        return;
      }
      setState(() {
        count--;
      });
      HapticFeedback.lightImpact(); // Haptic feedback every step
      elapsed += 100;
    });
  }

  // Stop long press decrement
  void _stopLongDecrement(BuildContext context) {
    _decrementTimer?.cancel();
    _showSnackBar(context, "Decremented (Long Press)!");
  }

  // Clean up timers when the widget is removed
  @override
  void dispose() {
    _incrementTimer?.cancel();
    _decrementTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: _themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark().copyWith(
        // Override text themes to force black text in dark mode
        textTheme: ThemeData.dark().textTheme.apply(
              bodyColor: Colors.black,
              displayColor: Colors.black,
            ),
      ),
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context) {
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;

          return Scaffold(
            appBar: AppBar(
              title: const Text("Counter App", style: TextStyle(color: Colors.black)),
              backgroundColor: Colors.amber,
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(
                    _themeMode == ThemeMode.dark
                        ? Icons.wb_sunny
                        : Icons.nightlight_round,
                    color: Colors.black,
                  ),
                  onPressed: _toggleTheme,
                )
              ],
            ),
            body: Center(
              child: isPortrait
                  ? _buildVerticalLayout(context)
                  : _buildHorizontalLayout(context),
            ),
          );
        },
      ),
    );
  }

  // Portrait layout
  Widget _buildVerticalLayout(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _commonWidgets(context),
    );
  }

  // Landscape layout
  Widget _buildHorizontalLayout(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _commonWidgets(context),
    );
  }

  // Shared widgets used in both layouts
  List<Widget> _commonWidgets(BuildContext context) {
    return [
      // Counter Text: White in dark mode, black in light mode
      Text(
        '$count',
        style: TextStyle(
          fontSize: 50,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
        ),
      ),
      const SizedBox(height: 20),

      /// INCREMENT BUTTON
      GestureDetector(
        onLongPressStart: (_) {
          HapticFeedback.lightImpact();
          _startLongIncrement(context);
        },
        onLongPressEnd: (_) {
          _stopLongIncrement(context);
        },
        onTapDown: (_) => setState(() => _isIncrementPressed = true),
        onTapUp: (_) => setState(() => _isIncrementPressed = false),
        onTapCancel: () => setState(() => _isIncrementPressed = false),
        child: AnimatedScale(
          scale: _isIncrementPressed ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: ElevatedButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              setState(() {
                count++;
              });
              _showSnackBar(context, "Incremented!");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding:
                  const EdgeInsets.symmetric(horizontal: 80, vertical: 40), // Increased size
              textStyle: const TextStyle(fontSize: 24), // Increased font size
            ),
            child:
                const Text("Increment", style: TextStyle(color: Colors.black)),
          ),
        ),
      ),

      const SizedBox(height: 20),

      /// DECREMENT BUTTON
      GestureDetector(
        onLongPressStart: (_) {
          HapticFeedback.lightImpact();
          _startLongDecrement(context);
        },
        onLongPressEnd: (_) {
          _stopLongDecrement(context);
        },
        onTapDown: (_) => setState(() => _isDecrementPressed = true),
        onTapUp: (_) => setState(() => _isDecrementPressed = false),
        onTapCancel: () => setState(() => _isDecrementPressed = false),
        child: AnimatedScale(
          scale: _isDecrementPressed ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: ElevatedButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              setState(() {
                count--;
              });
              _showSnackBar(context, "Decremented!");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding:
                  const EdgeInsets.symmetric(horizontal: 80, vertical: 40), // Increased size
              textStyle: const TextStyle(fontSize: 24), // Increased font size
            ),
            child:
                const Text("Decrement", style: TextStyle(color: Colors.black)),
          ),
        ),
      ),

      const SizedBox(height: 40),

      /// RESET BUTTON
      ElevatedButton(
        onPressed: () {
          HapticFeedback.selectionClick();
          setState(() {
            count = 0;
          });
          _showSnackBar(context, "Whola!! Reset to 0");
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 30), // Increased size
          textStyle: const TextStyle(fontSize: 24), // Increased font size
        ),
        child: const Text("Reset", style: TextStyle(color: Colors.white)),
      ),
    ];
  }
}
