import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const PetMoodApp());
}

class PetMoodApp extends StatelessWidget {
  const PetMoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        useMaterial3: true,
      ),
      home: const PetHomePage(),
    );
  }
}

class PetHomePage extends StatefulWidget {
  const PetHomePage({super.key});

  @override
  State<PetHomePage> createState() => _PetHomePageState();
}

class _PetHomePageState extends State<PetHomePage> {
  final Random random = Random();

  final List<Map<String,String>> pets = [
    {
      'name':'Aereis',
      'image':'https://raw.githubusercontent.com/Yana-Nova/COS/main/Aereis.jpg'
    },
    {
      'name':'Angelic',
      'image':'https://raw.githubusercontent.com/Yana-Nova/COS/main/Angelic.jpg'
    },
    {
      'name':'Verdant',
      'image':'https://raw.githubusercontent.com/Yana-Nova/COS/main/Verdant.jpg'
    },
   
    
  ];

  String petName = 'Angelic';
  String petImage = 
      'https://raw.githubusercontent.com/Yana-Nova/COS/main/Angelic.jpg';
  String status = 'Я только проснулась. Что будем делать?';

  int mood = 6;
  int hunger = 4;
  int energy = 7;
  int coins = 0;
  int level = 1;
bool umetbYly4weHue=false;
  bool haveAcollar=false;
  Color get backgroundColor {
    if (mood >= 8) return const Color(0xFFFFE4F1);
    if (mood >= 4) return const Color(0xFFE7F4FF);
    return const Color(0xFFFFE8E1);
  }
String get showPetName{
   if (umetbYly4weHue==true){
     return 'Принцесса $petName';
   }
  return petName;
}
  String get moodText {
    if (mood >= 9) return 'счастье';
    if (mood >= 6) return 'норм';
    if (mood >= 3) return 'грусть';
    return 'обида';
  }

  void changePet() {
   final pet=pets[random.nextInt(pets.length)];
    setState(() {
      petImage =pet['image']!;
      petName=pet['name']!;
      status = 'Теперь у меня новый питомец!';
    });
  }

  void feedPet() {
    setState(() {
      hunger = max(0, hunger - 2);
      mood = min(10, mood + 1);
      coins += 1;
      status = '$petName вкусно поела и получила +1 монетку.';
      checkLevel();
    });
  }

  void playWithPet() {
    setState(() {
      if (energy <= 1) {
        mood = max(0, mood - 1);
        status = '$petName устала. Сначала дай ей поспать.';
      } else {
        energy = max(0, energy - 2);
        hunger = min(10, hunger + 1);
        mood = min(10, mood + 2);
        if (haveAcollar==true){
          coins+=52;
          status='ошейник удачи сработал, +52 монеты';
        } else{
          coins += 2;
        status = 'Вы поиграли. Весело! +2 монетки.';
        }
        
      }
      checkLevel();
    });
  }

  void sleepPet() {
    setState(() {
      energy = min(10, energy + 3);
      hunger = min(10, hunger + 1);
      mood = min(10, mood + 1);
      status = '$petName поспала и стала бодрее.';
    });
  }

  void surprise() {
    final List<String> events = [
      'Нашла блестящую пуговицу. +3 монетки!',
      'Уронила вазу. Настроение -2.',
      'Увидела смешной мем. Настроение +2!',
      'Съела тайный кекс. Голод -3.',
      'Танцевала 10 минут. Энергия -2, монетки +2.',
    ];

    final String event = events[random.nextInt(events.length)];

    setState(() {
      if (event.contains('+3')) coins += 3;
      if (event.contains('Настроение -2')) mood = max(0, mood - 2);
      if (event.contains('Настроение +2')) mood = min(10, mood + 2);
      if (event.contains('Голод -3')) hunger = max(0, hunger - 3);
      if (event.contains('Танцевала')) {
        energy = max(0, energy - 2);
        coins += 2;
      }
      status = event;
      checkLevel();
    });
  }
void buyCollar() {
  setState((){
   if (haveAcollar==true){
     status='ошейник уже куплен';
   } else if (coins >= 15) {
      coins -= 15;
      haveAcollar = true;
      status = 'Купили ошейник удачи. Теперь игра дает больше монет!';
    } else {
      status = 'Нужно 15 монеток на ошейник.';
    }
  });
}
  void buyBow() {
    setState(() {
      if (umetbYly4weHue==true){
        status='Bbl yжe kynuлu yлyчшeнue';
      }
      else if (coins >= 67) {
        coins -= 67;
        umetbYly4weHue=true;
        mood = min(10, mood + 2);
        petName = 'Принцесса $petName';
        status = 'Купили бантик. Теперь стиль +100.';
      } else {
        status = 'Нужно 67 монеток. Пока не хватает.';
      }
    });
  }

  void hugPet() {
    setState(() {
      if (energy <= 0) {
        status = '$petName слишком устала для обнимашек.';
      } else {
        energy = max(0, energy - 1);
        mood = min(10, mood + 3);
        status = '$petName обняли. Настроение +3!';
      }
    });
  }

  void checkLevel() {
    if (coins >= level * 8) {
      level += 1;
      mood = min(10, mood + 1);
      status = 'Ура! Новый уровень: $level.';
    }
  }

  Widget petPicture() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Image.network(
        petImage,
        height: 220,
        width: 220,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const SizedBox(
            height: 220,
            width: 220,
            child: Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 220,
            width: 220,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF5B8),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text(
              'Картинка\nне загрузилась',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          );
        },
      ),
    );
  }

  Widget statBar(String title, int value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            Text('$value/10'),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            minHeight: 12,
            value: value / 10,
            color: color,
            backgroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget actionButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Питомец настроения'),
        centerTitle: true,
        backgroundColor: Colors.white70,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    petPicture(),
                    const SizedBox(height: 12),
                    Text(
                      showPetName,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Настроение: $moodText',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF5B8),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        status,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Монетки: $coins',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'Уровень: $level',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    statBar('Настроение', mood, Colors.pinkAccent),
                    const SizedBox(height: 14),
                    statBar('Голод', hunger, Colors.orangeAccent),
                    const SizedBox(height: 14),
                    statBar('Энергия', energy, Colors.lightBlueAccent),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  actionButton(
                    'Покормить',
                    Icons.restaurant,
                    Colors.orange,
                    feedPet,
                  ),
                  actionButton(
                    'Играть',
                    Icons.sports_esports,
                    Colors.pinkAccent,
                    playWithPet,
                  ),
                  actionButton(
                    'Спать',
                    Icons.bedtime,
                    Colors.indigo,
                    sleepPet,
                  ),
                  actionButton(
                    'Сюрприз',
                    Icons.casino,
                    Colors.teal,
                    surprise,
                  ),
                  actionButton(
                    'Сменить',
                    Icons.auto_awesome,
                    Colors.purple,
                    changePet,
                  ),
                
                  actionButton(
                    'Обнять',
                    Icons.favorite,
                    Colors.redAccent,
                    hugPet,
                  ),
                ],
             ),
              const SizedBox(height: 18),

Container(
  width: double.infinity,
  padding: const EdgeInsets.all(18),
  decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.9),
    borderRadius: BorderRadius.circular(24),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Магазин улучшений',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w900,
        ),
      ),
      const SizedBox(height: 12),

      Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
  actionButton(
                    'Улучшение-65 монеток',
                    Icons.shopping_bag,
                    Colors.deepPurple,
                    buyBow,
                  ),
            actionButton(
                    'Улучшение-15 монеток',
                    Icons.shopping_bag,
                    Colors.deepPurple,
                    buyCollar,
                  ),
        ],
      ),
    ],
  ),
),
            ],
          ),
        ),
      ),
    );
  }
}
