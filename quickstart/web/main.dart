import 'dart:js_interop';
import 'package:web/web.dart';

final startScreen = document.getElementById('start-screen');
final quizScreen = document.getElementById('quiz-screen');
final resultScreen = document.getElementById('result-screen');
final startButton = document.getElementById('start-btn');
final questionText = document.getElementById('question-text');
final answersContainer = document.getElementById('answers-container');
final currentQuestionSpan = document.getElementById('current-question');
final totalQuestionsSpan = document.getElementById('total-questions');
final scoreSpan = document.getElementById('score');
final finalScoreSpan = document.getElementById('final-score');
final maxScoreSpan = document.getElementById('max-score');
final resultMessage = document.getElementById('result-message');
final restartButton = document.getElementById('restart-btn');
final progressBar = document.getElementById('progress');
final quizQuestions = [
  {
    "question": "What is the capital of France?",
    "answers": [
      {"text": "London", "correct": false},
      {"text": "Berlin", "correct": false},
      {"text": "Paris", "correct": true},
      {"text": "Madrid", "correct": false},
    ],
  },
  {
    "question": "Which planet is known as the Red Planet?",
    "answers": [
      {"text": "Venus", "correct": false},
      {"text": "Mars", "correct": true},
      {"text": "Jupiter", "correct": false},
      {"text": "Saturn", "correct": false},
    ],
  },
  {
    "question": "What is the largest ocean on Earth?",
    "answers": [
      {"text": "Atlantic Ocean", "correct": false},
      {"text": "Indian Ocean", "correct": false},
      {"text": "Arctic Ocean", "correct": false},
      {"text": "Pacific Ocean", "correct": true},
    ],
  },
  {
    'question': "Which of these is NOT a programming language?",
    'answers': [
      {'text': "Java", 'correct': false},
      {'text': "Python", 'correct': false},
      {'text': "Banana", 'correct': true},
      {'text': "JavaScript", 'correct': false},
    ],
  },
  {
    "question": "What is the chemical symbol for gold?",
    "answers": [
      {"text": "Go", "correct": false},
      {"text": "Gd", "correct": false},
      {"text": "Au", "correct": true},
      {"text": "Ag", "correct": false},
    ],
  },
];

int currentQuestionIndex = 0;
int score = 0;
bool answersDisabled = false;

void main() {
  totalQuestionsSpan?.textContent = "${quizQuestions.length}";
  currentQuestionSpan?.textContent = "$currentQuestionIndex";
  maxScoreSpan?.textContent = "${quizQuestions.length}";
  scoreSpan?.textContent = "$score";

  startButton?.addEventListener('click', startQuiz.toJS);
  restartButton?.addEventListener('click', restartQuiz.toJS);
}

void startQuiz() {
  print("Started Quiz!");

  currentQuestionIndex = 0;
  score = 0;
  scoreSpan?.textContent = "$score";

  startScreen?.classList.remove('active');
  quizScreen?.classList.add('active');
  showQuestion();
}

void restartQuiz() {
  print("Restarted Quiz!");
  currentQuestionIndex = 0;
  score = 0;

  resultScreen?.classList.remove('active');
  startScreen?.classList.add('active');
}

void showQuestion() {
  answersDisabled = false;
  final currentQuestion = quizQuestions[currentQuestionIndex];

  currentQuestionSpan?.textContent = "${currentQuestionIndex + 1}";

  final progressPercent = (currentQuestionIndex / quizQuestions.length) * 100;

  (progressBar as HTMLElement?)?.style.width = "$progressPercent%";

  questionText?.textContent = "${currentQuestion['question']}";

  answersContainer?.innerHTML = ''.toJS;

  final answers = currentQuestion['answers'] as List<Map<String, dynamic>>;

  for (var answer in answers) {
    final button = document.createElement('button');

    button.textContent = answer['text'];
    button.classList.add('answer-btn');

    (button as HTMLButtonElement).dataset['correct'] = answer['correct']
        .toString();

    button.addEventListener('click', selectAnswer.toJS);

    answersContainer?.appendChild(button);
  }
}

void selectAnswer(Event event) {
  if (answersDisabled) return;
  print("Answer Selected");

  answersDisabled = true;

  final selectedButton = event.target;
  final isCorrect =
      (selectedButton as HTMLButtonElement).dataset['correct'] == 'true';

  final children = answersContainer?.children;

  if (children != null) {
    for (int i = 0; i < children.length; i++) {
      final button = children.item(i) as HTMLButtonElement;

      if (button.dataset['correct'] == 'true') {
        button.classList.add('correct');
      } else if (button == selectedButton) {
        button.classList.add('incorrect');
      }
    }
  }

  if (isCorrect) {
    score++;
    scoreSpan?.textContent = "$score";
  }

  Future.delayed(Duration(milliseconds: 1000), () {
    currentQuestionIndex++;

    if (currentQuestionIndex < quizQuestions.length) {
      showQuestion();
    } else {
      showResults();
    }
  });
}

void showResults() {
  finalScoreSpan?.textContent = "$score";
  quizScreen?.classList.remove('active');
  resultScreen?.classList.add('active');

  final percentage = (score / quizQuestions.length) * 100;

  if (percentage == 100) {
    resultMessage?.textContent = "Perfect! You're a genius!";
  } else if (percentage >= 80) {
    resultMessage?.textContent = "Great job! You know your stuff!";
  } else if (percentage >= 60) {
    resultMessage?.textContent = "Good effort! Keep learning!";
  } else if (percentage >= 40) {
    resultMessage?.textContent = "Not bad! Try again to improve!";
  } else {
    resultMessage?.textContent = "Keep studying! You'll get better!";
  }
}
