import 'package:flutter/material.dart';
import 'game.dart';

void main() {
  runApp(const MainApp());
}

class GuessInput extends StatelessWidget {
  GuessInput({super.key, required this.onSubmitGuess});

  final void Function(String) onSubmitGuess;

  final TextEditingController _textEditingController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  void _onSubmit() {
    final guess = _textEditingController.text.trim();

    if (guess.isEmpty) {
      return;
    }

    onSubmitGuess(guess);
    _textEditingController.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  maxLength: 5,
                  focusNode: _focusNode,
                  autofocus: true,
                  style: TextStyle(
                    color: Colors.pink.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    counterText: '',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(35)),
                      borderSide: BorderSide(color: Colors.pink.shade200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(35)),
                      borderSide: BorderSide(
                        color: Colors.pink.shade400,
                        width: 2,
                      ),
                    ),
                  ),
                  controller: _textEditingController,
                  onSubmitted: (value) {
                    _onSubmit();
                  },
                ),
              ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.favorite, color: Colors.pink.shade400, size: 30),
              onPressed: _onSubmit,
            ),
          ],
        ),
      ),
    );
  }
}

class Tile extends StatelessWidget {
  const Tile(this.letter, this.hitType, {super.key});

  final String letter;
  final HitType hitType;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.bounceIn,
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.pink.shade100, width: 2),
        color: switch (hitType) {
          HitType.hit => Colors.pink.shade400,
          HitType.partial => Colors.purple.shade200,
          HitType.miss => Colors.grey.shade400,
          _ => Colors.white.withOpacity(0.9),
        },
        boxShadow: [
          if (hitType != HitType.none)
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
        ],
      ),
      child: Center(
        child: Text(
          letter.toUpperCase(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: hitType == HitType.none
                ? Colors.pink.shade900
                : Colors.white,
          ),
        ),
      ),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final Game _game = Game();

  void _submitGuess(String guess) {
    final normalizedGuess = guess.trim().toLowerCase();

    if (!_game.isLegalGuess(normalizedGuess)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.pink.shade400,
          content: const Text(
            'A palavra deve ter 5 letras e ser válida.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      return;
    }

    setState(() {
      _game.guess(normalizedGuess);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite, color: Colors.pink, size: 40),
                SizedBox(width: 10),
                Text(
                  'JOGO DO AMOR',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink.shade400,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(width: 10),
                Icon(Icons.favorite, color: Colors.pink, size: 40),
              ],
            ),
          ),
          for (var guess in _game.guesses)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var letter in guess)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2.5,
                      vertical: 2.5,
                    ),
                    child: Tile(letter.char, letter.type),
                  ),
              ],
            ),
          const SizedBox(height: 20),
          GuessInput(onSubmitGuess: _submitGuess),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              'Dica: Tente palavras de 5 letras com as qualidades que eu mais amo em você! ❤️',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.pink.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.pink),
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.pink.shade50, Colors.white],
            ),
          ),
          child: SafeArea(child: Center(child: GamePage())),
        ),
      ),
    );
  }
}
