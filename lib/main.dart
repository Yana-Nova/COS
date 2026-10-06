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

  // ── Питомцы со скинами и ценами ──
  final List<Map<String, dynamic>> pets = [
    {
      'name': 'Ghartokus',
      'skins': [
        {'name': 'Базовый',       'image': 'https://raw.githubusercontent.com/Yana-Nova/COS/main/ghartokus.jpeg',            'price': 0},
        {'name': 'Цветочный',      'image': 'https://raw.githubusercontent.com/Yana-Nova/COS/main/FlowerGhart.jpg',         'price': 50},
        {'name': 'Золотое солнце', 'image': 'https://raw.githubusercontent.com/Yana-Nova/COS/main/GoldenSunshineGhart.jpeg','price': 80},
        {'name': 'Осенний огонь',  'image': 'https://raw.githubusercontent.com/Yana-Nova/COS/main/OutumnOnFireGHART.jpg',   'price': 120},
      ],
    },
    {
      'name': 'Aereis',
      'skins': [
        {'name': 'Базовый',  'image': 'https://raw.githubusercontent.com/Yana-Nova/COS/main/Aereis.jpg',     'price': 0},
        {'name': 'Огненный', 'image': 'https://raw.githubusercontent.com/Yana-Nova/COS/main/FireAereis.jpg','price': 100},
      ],
    },
    {
      'name': 'Angelic',
      'skins': [
        {'name': 'Базовый',   'image': 'https://raw.githubusercontent.com/Yana-Nova/COS/main/Angelic.jpg',      'price': 0},
        {'name': 'Серебряный', 'image': 'https://raw.githubusercontent.com/Yana-Nova/COS/main/AngelicSkin.jpeg','price': 90},
      ],
    },
    {
      'name': 'Verdant',
      'skins': [
        {'name': 'Базовый', 'image': 'https://raw.githubusercontent.com/Yana-Nova/COS/main/Verdant.jpg',     'price': 0},
        {'name': 'SF Verdant', 'image': 'https://raw.githubusercontent.com/Yana-Nova/COS/main/SF%20Verdant.jpg','price': 110},
      ],
    },
  ];

  // ── Текущий индекс питомца ──
  int currentPetIndex = 1; // Angelic по умолчанию

  // ── Выбранный скин для каждого питомца (по имени) ──
  final Map<String, int> petSkinIndices = {};

  // ── Купленные скины (по имени питомца + индекс скина) ──
  final Set<String> purchasedSkins = {};

  // ── Геттеры для имени и картинки текущего питомца ──
  String get petName => pets[currentPetIndex]['name'] as String;
  String get petImage {
    final skins = pets[currentPetIndex]['skins'] as List<Map<String, dynamic>>;
    final idx = petSkinIndices[petName] ?? 0;
    return skins[idx]['image'] as String;
  }
  String get currentSkinName {
    final skins = pets[currentPetIndex]['skins'] as List<Map<String, dynamic>>;
    final idx = petSkinIndices[petName] ?? 0;
    return skins[idx]['name'] as String;
  }

  String status = 'Я только проснулась. Что будем делать?';

  int mood = 6;
  int hunger = 4;
  int energy = 7;
  int coins = 0;
  int level = 1;
  int rewardDay = 1;
  bool rewardTaken = false;
  final TextEditingController cccp = TextEditingController();
  final Set<String> usedPromocode = {};
  final List<Map<String, dynamic>> rewards = [
    {'title': '+10 монет', 'coins': 10, 'icon': Icons.monetization_on},
    {'title': '+15 монет', 'coins': 15, 'icon': Icons.monetization_on},
    {'title': '+2 настроение', 'mood': 2, 'icon': Icons.favorite},
    {'title': '+20 монет', 'coins': 20, 'icon': Icons.card_giftcard},
    {'title': '+3 энергия', 'energy': 3, 'icon': Icons.bolt},
    {'title': '+30 монет', 'coins': 30, 'icon': Icons.redeem},
    {'title': 'Супер приз', 'coins': 100, 'mood': 5, 'icon': Icons.star},
  ];

  void collectReward() {
    setState(() {
      final reward = rewards[rewardDay - 1];
      if (reward['mood'] != null) {
        mood = min(10, mood + (reward['mood'] as int));
      }
      if (reward['coins'] != null) {
        coins += reward['coins'] as int;
      }
      if (reward['energy'] != null) {
        energy = min(10, energy + (reward['energy'] as int));
      }
      rewardTaken = true;
      status = 'Получена награда: ${reward['title']}';
      checkLevel();
    });
  }

  void caxapok() {
    String tanok = cccp.text.trim().toUpperCase();
    setState(() {
      if (tanok.isEmpty) {
        status = 'Введите промокод';
        return;
      }
      if (usedPromocode.contains(tanok)) {
        status = 'Промокод уже использован';
        return;
      }
      bool promoActivated = false;
      String promoStatus = '';
      if (tanok == 'AEREISSTARTICKET') {
        if (petName != 'Aereis') {
          status = 'Промокод работает только для Aereis.';
          return;
        }
        coins += 220;
        energy = 10;
        promoStatus = 'Промокод AEREISSTARTICKET принят! +220 монет и энергия на максимум.';
        usedPromocode.add(tanok);
        promoActivated = true;
      } else if (tanok == 'ANGELICPROMOTICKET') {
        if (petName != 'Angelic') {
          status = 'Промокод работает только для Angelic.';
          return;
        }
        coins += 200;
        energy = 10;
        mood = 10;
        promoStatus = 'Промокод ANGELICPROMOTICKET принят! +200 монет и Энергия и настроение на максимум.';
        usedPromocode.add(tanok);
        promoActivated = true;
      } else if (tanok == 'COSPROMO') {
        mood = 10;
        coins += 100;
        promoStatus = 'Секретный промокод COSPROMO! Настроение максимум и +100 монет.';
        usedPromocode.add(tanok);
        promoActivated = true;
      } else {
        status = 'Такого промокода нет.';
      }
      if (promoActivated) {
        int oldLevel = level;
        checkLevel();
        if (level > oldLevel) {
          status = '$promoStatus Новый уровень: $level!';
        } else {
          status = promoStatus;
        }
      }
      cccp.clear();
    });
  }

  void nextRewardDay() {
    setState(() {
      if (rewardDay >= 7) {
        rewardDay = 1;
        status = 'Новая неделя наград началась!';
      } else {
        rewardDay += 1;
        status = 'Наступил день $rewardDay!';
      }
      rewardTaken = false;
    });
  }

  bool umetbYly4weHue = false;
  bool haveAcollar = false;
  Map<String, DateTime> petBirthdays = {};
  bool isBirthdayCelebrated = false;

  Color get backgroundColor {
    if (mood >= 8) return const Color(0xFFFFE4F1);
    if (mood >= 4) return const Color(0xFFE7F4FF);
    return const Color(0xFFFFE8E1);
  }

  String get showPetName {
    if (umetbYly4weHue) {
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

  int get chestPrice {
    return level * 5;
  }

  void openChest() {
    setState(() {
      if (level < 2) {
        status = 'Сундук откроется со 2 уровня!';
        return;
      }
      if (coins < chestPrice) {
        status = 'Нужно $chestPrice монеток на сундук.';
        return;
      }
      coins -= chestPrice;
      final prize = random.nextInt(4);
      if (prize == 0) {
        coins += level * 15;
        status = 'В сундуке монеты! +${level * 15}';
      } else if (prize == 1) {
        mood = min(10, mood + 3);
        status = 'В сундуке волшебная конфета! Настроение +3.';
      } else if (prize == 2) {
        energy = min(10, energy + 4);
        status = 'В сундуке энергетик! Энергия +4.';
      } else if (prize == 3) {
        hunger = max(0, hunger - 3);
        status = 'В сундуке вкусняшка! Голод -3.';
      }
      checkLevel();
    });
  }

  void changePet() {
    final pet = pets[random.nextInt(pets.length)];
    setState(() {
      currentPetIndex = pets.indexOf(pet);
      isBirthdayCelebrated = false;
      if (petBirthdays.containsKey(petName)) {
        status = 'Теперь у меня новый питомец! ДР: ${_formatDate(petBirthdays[petName]!)}';
      } else {
        status = 'Теперь у меня новый питомец! Не забудь задать день рождения.';
      }
    });
  }

  final _random = Random();

  void feedPet() {
    const baseCost = 2;
    final hasFoundCoin = _random.nextDouble() < 0.3;
    final isExtraHappy = _random.nextDouble() < 0.2;
    if (coins >= baseCost) {
      setState(() {
        hunger = max(0, hunger - 2);
        var moodBonus = 1;
        String extraMsg = '';
        if (isExtraHappy) {
          moodBonus += 2;
          extraMsg = 'И так обрадовалась, что аж хвостиком виляет! ';
        }
        mood = min(10, mood + moodBonus);
        coins -= baseCost;
        if (hasFoundCoin) {
          coins += 1;
          extraMsg += 'А ещё нашла 1 монетку в миске! 🎉';
        }
        status = '$petName вкусно поела. $extraMsg';
        checkLevel();
      });
    } else {
      final kindEvent = _random.nextInt(3);
      setState(() {
        String kindMsg;
        switch (kindEvent) {
          case 0:
            hunger = max(0, hunger - 1);
            mood = min(10, mood + 1);
            kindMsg = 'Ой, сосед принёс вкусняшку для $petName! Она немного поела, но монет не потратила. 😊';
            break;
          case 1:
            hunger = max(0, hunger - 1);
            mood = min(10, mood + 1);
            kindMsg = '$petName сама нашла кусочек корма за диваном. Сыта и горда собой! 💛';
            break;
          default:
            mood = max(0, mood - 1);
            kindMsg = '$petName немножко грустит — нет монет на еду… Но она верит, что скоро всё будет хорошо. 🥺';
        }
        status = kindMsg;
        checkLevel();
      });
    }
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
        if (haveAcollar == true) {
          coins += 52;
          status = 'ошейник удачи сработал, +52 монеты';
        } else {
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
    setState(() {
      if (haveAcollar == true) {
        status = 'ошейник уже куплен';
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
      if (umetbYly4weHue == true) {
        status = 'Bbl yжe kynuлu yлyчшeнue';
      } else if (coins >= 67) {
        coins -= 67;
        umetbYly4weHue = true;
        mood = min(10, mood + 2);
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

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
  }

  void setBirthdayDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        petBirthdays[petName] = picked;
        isBirthdayCelebrated = false;
        status = 'День рождения $petName — ${_formatDate(picked)}! 🎂';
      });
    }
  }

  void celebrateBirthday() {
    if (petBirthdays[petName] == null) {
      setState(() {
        status = 'Сначала задай дату дня рождения для $petName!';
      });
      setBirthdayDate();
      return;
    }
    if (isBirthdayCelebrated) {
      setState(() {
        status = 'День рождения $petName уже праздновали! 🎈';
      });
      return;
    }
    setState(() {
      isBirthdayCelebrated = true;
      mood = 10;
      energy = min(10, energy + 5);
      hunger = max(0, hunger - 3);
      coins += 50;
      status = '🎉 С Днём Рождения, $petName! 🎈 Шарики, подарок и +50 монет! Настроение на максимуме!';
      checkLevel();
    });
    showBirthdayDialog();
  }

  void showBirthdayDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          title: const Text('🎉 День Рождения! 🎈', textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🎈🎈🎈', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              Text(
                'С Днём Рождения, $petName!',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              const Text(
                'Подарок: +50 монет, настроение на максимум, энергия +5!',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text('Ура!'),
            ),
          ],
        );
      },
    );
  }

  Widget rewardCard(int index) {
    final reward = rewards[index];
    final day = index + 1;
    final bool isPast = day < rewardDay;
    final bool isToday = day == rewardDay;
    final bool isFuture = day > rewardDay;
    Color color = Colors.grey.shade200;
    if (isPast) color = Colors.green.shade100;
    if (isToday) color = Colors.amber.shade100;
    if (isFuture) color = Colors.grey.shade300;
    return Container(
      width: 90,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isToday ? Colors.orange : Colors.transparent,
          width: 3,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('День $day', style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Icon(reward['icon'] as IconData, size: 36, color: isFuture ? Colors.grey : Colors.orange),
          const SizedBox(height: 8),
          Text(
            isFuture ? 'Скоро' : reward['title'],
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  void showPromoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Секретный промокод'),
          content: TextField(
            controller: cccp,
            decoration: const InputDecoration(hintText: 'Например: COOKIE'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Закрыть'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                caxapok();
              },
              child: const Text('Активировать'),
            ),
          ],
        );
      },
    );
  }

  void showRewardCalendar() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Календарь наград', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 8),
                    Text('День $rewardDay из 7', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 18),
                    Wrap(spacing: 10, runSpacing: 10, alignment: WrapAlignment.center, children: List.generate(7, rewardCard)),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: rewardTaken
                          ? null
                          : () {
                              collectReward();
                              Navigator.pop(context);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      ),
                      child: Text(rewardTaken ? 'Уже забрано' : 'Забрать', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Закрыть'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Ключ покупки скина ──
  String _skinKey(String pet, int idx) => '$pet:$idx';

  // ── Покупка / смена скина ──
  void changeSkin(int skinIndex) {
    final skins = pets[currentPetIndex]['skins'] as List<Map<String, dynamic>>;
    final skin = skins[skinIndex];
    final price = skin['price'] as int;
    final key = _skinKey(petName, skinIndex);

    setState(() {
      if (price == 0) {
        // Базовый скин — бесплатно
        petSkinIndices[petName] = skinIndex;
        status = 'Скин изменён: ${skin['name']}';
      } else if (purchasedSkins.contains(key)) {
        // Уже куплен — просто надеваем
        petSkinIndices[petName] = skinIndex;
        status = 'Скин изменён: ${skin['name']}';
      } else if (coins >= price) {
        // Покупаем
        coins -= price;
        purchasedSkins.add(key);
        petSkinIndices[petName] = skinIndex;
        status = 'Куплен скин «${skin['name']}» за $price монет!';
        checkLevel();
      } else {
        status = 'Не хватает $price монет на скин «${skin['name']}».';
      }
    });
  }

  // ── Диалог выбора скинов ──
  void showSkinDialog() {
    final skins = pets[currentPetIndex]['skins'] as List<Map<String, dynamic>>;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Скины', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 4),
                        Text('для $petName', style: TextStyle(fontSize: 16, color: Colors.grey.shade600, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 18),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.72,
                          ),
                          itemCount: skins.length,
                          itemBuilder: (context, index) {
                            final skin = skins[index];
                            final price = skin['price'] as int;
                            final key = _skinKey(petName, index);
                            final isCurrent = (petSkinIndices[petName] ?? 0) == index;
                            final isPurchased = price == 0 || purchasedSkins.contains(key);
                            final canAfford = coins >= price;

                            return GestureDetector(
                              onTap: () {
                                if (price == 0 || purchasedSkins.contains(key)) {
                                  changeSkin(index);
                                  setDialogState(() {});
                                } else if (coins >= price) {
                                  changeSkin(index);
                                  setDialogState(() {});
                                } else {
                                  setDialogState(() {
                                    status = 'Не хватает $price монет на скин «${skin['name']}».';
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isCurrent ? Colors.pink.shade50 : Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: isCurrent ? Colors.pinkAccent : Colors.grey.shade300,
                                    width: isCurrent ? 3 : 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                                      child: Image.network(
                                        skin['image'] as String,
                                        height: 90,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, progress) {
                                          if (progress == null) return child;
                                          return const SizedBox(
                                            height: 90,
                                            child: Center(child: CircularProgressIndicator()),
                                          );
                                        },
                                        errorBuilder: (context, error, stack) => Container(
                                          height: 90,
                                          color: Colors.grey.shade200,
                                          child: const Icon(Icons.broken_image, size: 32),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 6),
                                      child: Text(
                                        skin['name'] as String,
                                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    // ── Цена / статус ──
                                    if (price == 0)
                                      const Text('Бесплатно', style: TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.w700))
                                    else if (isPurchased)
                                      const Text('Куплено ✓', style: TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.w700))
                                    else
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.monetization_on, size: 14, color: canAfford ? Colors.amber.shade700 : Colors.grey),
                                          const SizedBox(width: 3),
                                          Text(
                                            '$price',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w800,
                                              color: canAfford ? Colors.black87 : Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    if (isCurrent)
                                      const Padding(
                                        padding: EdgeInsets.only(top: 4),
                                        child: Icon(Icons.check_circle, color: Colors.pinkAccent, size: 20),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Монеты: $coins',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Закрыть'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
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
            child: const Text('Картинка\nне загрузилась', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w800)),
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

  Widget actionButton(String text, IconData icon, Color color, VoidCallback onTap) {
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showRewardCalendar();
    });
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
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Скин: $currentSkinName',
                      style: TextStyle(fontSize: 14, color: Colors.purple.shade400, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Настроение: $moodText',
                      style: TextStyle(fontSize: 18, color: Colors.grey.shade700, fontWeight: FontWeight.w700),
                    ),
                    if (petBirthdays[petName] != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '🎂 ДР: ${_formatDate(petBirthdays[petName]!)}',
                          style: TextStyle(fontSize: 14, color: Colors.pink.shade400, fontWeight: FontWeight.w600),
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
                      child: Text(status, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
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
                        Text('Монетки: $coins', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                        Text('Уровень: $level', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
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
                  actionButton('Награды', Icons.calendar_month, Colors.amber, showRewardCalendar),
                  actionButton('Новый день', Icons.next_plan, Colors.green, nextRewardDay),
                  actionButton('Промокод', Icons.lock_open, Colors.deepPurple, showPromoDialog),
                  actionButton('Скины', Icons.palette, Colors.purple, showSkinDialog),
                  actionButton('Покормить', Icons.restaurant, Colors.orange, feedPet),
                  actionButton('Играть', Icons.sports_esports, Colors.pinkAccent, playWithPet),
                  actionButton('Спать', Icons.bedtime, Colors.indigo, sleepPet),
                  actionButton('Сюрприз', Icons.casino, Colors.teal, surprise),
                  actionButton('Сменить', Icons.auto_awesome, Colors.purple, changePet),
                  actionButton('Обнять', Icons.favorite, Colors.redAccent, hugPet),
                  actionButton('Праздник', Icons.cake, Colors.pink, celebrateBirthday),
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
                    const Text('Магазин улучшений', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        actionButton('Улучшение-65 монеток', Icons.shopping_bag, Colors.deepPurple, buyBow),
                        actionButton('Улучшение-15 монеток', Icons.shopping_bag, Colors.deepPurple, buyCollar),
                        actionButton('Сундук $chestPrice', Icons.card_giftcard, Color(0xff7caa74), openChest),
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
