import 'package:flutter/material.dart';
import '../Model/flashcard_model.dart';

class FlashcardApp extends StatelessWidget {
  const FlashcardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flashcard Quiz App',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const FlashcardScreen(),
    );
  }
}

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  // Sample initial flashcards
  List<Flashcard> flashcards = [
    Flashcard(
      id: '1',
      question: 'What is Flutter?',
      answer: 'An open-source UI software development kit created by Google.',
    ),
    Flashcard(
      id: '2',
      question: 'What language does Flutter use?',
      answer: 'Dart',
    ),
  ];

  int currentIndex = 0;
  bool showAnswer = false;

  void toggleAnswer() {
    setState(() {
      showAnswer = !showAnswer;
    });
  }

  void nextCard() {
    if (currentIndex < flashcards.length - 1) {
      setState(() {
        currentIndex++;
        showAnswer = false;
      });
    }
  }

  void previousCard() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        showAnswer = false;
      });
    }
  }

  void deleteCurrentCard() {
    if (flashcards.isEmpty) return;
    setState(() {
      flashcards.removeAt(currentIndex);
      if (currentIndex >= flashcards.length && currentIndex > 0) {
        currentIndex--;
      }
      showAnswer = false;
    });
  }

  void showFlashcardDialog({Flashcard? card}) {
    final questionController = TextEditingController(
      text: card?.question ?? '',
    );
    final answerController = TextEditingController(text: card?.answer ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(card == null ? 'Add Flashcard' : 'Edit Flashcard'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: questionController,
              decoration: const InputDecoration(labelText: 'Question'),
            ),
            TextField(
              controller: answerController,
              decoration: const InputDecoration(labelText: 'Answer'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (questionController.text.isEmpty ||
                  answerController.text.isEmpty)
                return;

              setState(() {
                if (card == null) {
                  flashcards.add(
                    Flashcard(
                      id: DateTime.now().toString(),
                      question: questionController.text,
                      answer: answerController.text,
                    ),
                  );
                  currentIndex = flashcards.length - 1;
                } else {
                  card.question = questionController.text;
                  card.answer = answerController.text;
                }
                showAnswer = false;
              });
              Navigator.of(ctx).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasCards = flashcards.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: const Text(
          'Flashcard Quiz App',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        titleSpacing: 1,
        actions: [
          if (hasCards) ...[
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () =>
                  showFlashcardDialog(card: flashcards[currentIndex]),
            ),
          ],
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: hasCards
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 5,
                      ),
                        onPressed: () {
                          showFlashcardDialog();
                        },
                        child: Text("Add New Task"),
                      ),
                      SizedBox(height: 15),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 5,
                        ),
                        onPressed: () {
                          deleteCurrentCard;
                        },
                        child: Text("Delete current Task"),
                      ),

                    ],
                  ),
                  SizedBox(height: 60),
                  Text(
                    'Card ${currentIndex + 1} of ${flashcards.length}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Flashcard Display
                  SizedBox(
                    width: double.infinity,
                    height: 220,
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              showAnswer
                                  ? flashcards[currentIndex].answer
                                  : flashcards[currentIndex].question,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: showAnswer
                                    ? Colors.green[800]
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: toggleAnswer,
                    icon: Icon(
                      showAnswer
                          ? Icons.question_answer_sharp
                          : Icons.visibility,
                    ),
                    label: Text(showAnswer ? 'Show Question' : 'Show Answer'),
                  ),
                  const SizedBox(height: 30),
                  // Navigation Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: currentIndex > 0 ? previousCard : null,
                        child: Row(
                          children: [
                            Icon(Icons.arrow_back),
                            SizedBox(width: 5),
                            const Text('Previous'),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: currentIndex < flashcards.length - 1
                            ? nextCard
                            : null,
                        child: Row(
                          children: [
                            const Text('Next'),
                            SizedBox(width: 5),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : const Center(
                child: Text('No flashcards available. Tap + to add one!'),
              ),
      ),
    );
  }
}
