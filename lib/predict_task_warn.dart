import 'dart:math';

class PredictTaskWarn {
  final predict = [
    "You have a secret admirer, find them.",
    "Flattery wil go far tonight, try it.",
    "You will have a good day.",
    "The world will end.",
    "You will get a pet soon.",
    "You will make a new friend.",
    "It is going to rain tonight.",
    "You will enjoy a cookie later.",
    "The night will be long for you.",
    "You are going to ace your next test.",
    "You will receive a great new message in your mail soon.",
    "Your sleep tonight will be most exemplary."
  ];

  // Prediction Strength Array
  final strength = [
    "Incredibly Strong",
    "Strong",
    "Neutral",
    "Weak",
    "Incredibly Weak"
  ];
  // Task Array
  final task = [
    "Clean something.",
    "Practice self-care.",
    "Run 1 mile.",
    "Do 2 hours of homework.",
    "Throw a football.",
    "Ride your bike.",
    "Drink some coffee.",
    "Go buy groceries.",
    "Go to Target.",
    "Buy a bidet.",
    "Eat some vegetables for once.",
    "Beat the Ender Dragon."
  ];
  // Warning Array
  // Some warnings were vague enough to seem like predictions,
  // I understand why Connor thought this wasn't right.
  final warn = [
    "Beware of incoming weather.",
    "Don't behave with poor manners, or else.",
    "Change is inevitable, except from vending machines.",
    "Beware, everyone seems normal until you get to know them.",
    "Glory will be yours, but avoid the pitfalls on the way.",
    "Stop eating now. Food poisoning no fun.",
    "You think it’s a secret, but they know.",
    "AN ALIEN IS COMING FOR YOU. THIS IS NOT A PREDICTION.",
    "RUN. JUST RUN. FAR AWAY. DO NOT LOOK BEHIND YOU.",
    "YOUR MOM KNOWS WHAT WAS UNDER YOUR BED!"
  ];

  //ptw now works by giving it the index, and then picking a random index from the list of the first index
  List ptw(int s, Random rand) {
    if (s == 0) {
      return [
        predict[rand.nextInt(predict.length)],
        strength[rand.nextInt(strength.length)]
      ];
    } else if (s == 1) {
      return [
        task[rand.nextInt(task.length)],
        strength[rand.nextInt(strength.length)]
      ];
    } else {
      return [
        warn[rand.nextInt(warn.length)],
        strength[rand.nextInt(strength.length)]
      ];
    }
  }
}
