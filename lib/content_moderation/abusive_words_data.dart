/// Configurable local word list for content moderation.
/// Supports English, Hindi, Hinglish – ultra-expanded & verified from multiple sources (Karl Rock, Wikipedia, Kaggle, Reddit, etc.)
class AbusiveWordsData {
  AbusiveWordsData._();

  static final Set<String> _normalizedWords = _buildNormalizedSet();

  static Set<String> _buildNormalizedSet() {
    final set = <String>{};

    for (final word in _english) set.add(word.toLowerCase().trim());
    for (final word in _hinglish) set.add(word.toLowerCase().trim());
    for (final word in _hindi) set.add(word.trim());

    return set;
  }

  /// English – comprehensive with common profanity/insults/hate/threats
  static const List<String> _english = [
    'fuck', 'fucking', 'fucked', 'fucker', 'motherfucker', 'mf', 'mofo', 'shit', 'shitty', 'bullshit', 'ass', 'asshole', 'bitch', 'bastard', 'cunt', 'dick', 'cock', 'pussy', 'whore', 'slut', 'nigga', 'nigger', 'faggot', 'retard', 'cocksucker', 'douchebag', 'wanker', 'tosser', 'idiot', 'stupid', 'moron', 'loser', 'kill', 'die', 'rape', 'rapist', 'suicide', 'hate', 'racist', 'sexist', 'terrorist', 'damn', 'hell', 'piss', 'bloody', 'cum', 'jizz', 'tits', 'boobs', 'blowjob', 'dildo', 'orgasm', 'porn', 'chink', 'coon', 'gook', 'kike', 'paki', 'spick', 'fucktard', 'dipshit', 'twat', 'prick', 'knob', 'skank', 'hoe', 'fag', 'retarded', 'downie', 'bollocks', 'bellend', 'arse', 'arsehole', 'wank', 'shag', 'shagging', 'bugger', 'sodomy', 'queer', 'dyke', 'lesbo', 'homo', 'honky', 'redneck', 'sandnigger', 'raghead', 'porchmonkey', 'wetback', 'dago', 'yid', 'spaz', 'tard', 'numpty', 'prat', 'tosspot', 'wanker', 'twatwaffle', 'clusterfuck', 'cornhole', 'lynch', 'nuke',
    // More variants & hate terms
    'motherf', 'mthrfkr', 'shite', 'crap', 'turd', 'jackass', 'dumbass', 'sonofabitch', 'sob', 'bitchez', 'bitchslap', 'cocksucking', 'cumshot', 'cunnilingus', 'felch', 'fisting', 'gangbang', 'handjob', 'incest', 'jerkoff', 'masturbate', 'pearlnecklace', 'rimjob', 'semen', 'squirting', 'smegma', 'smut', 'sodoff', 'twats', 'upskirt', 'vagina', 'vulva', 'wanksta', 'sperm', 'spearm'
  ];

  /// Hinglish – ultra-expanded with all common variants, combos, censored, regional
  static const List<String> _hinglish = [
    // Core family/sexual from Karl Rock + others
    'madarchod', 'madar chod', 'madarchut', 'maderchod', 'maadarchod', 'madarch*d', 'madrchod', 'madarchood', 'madarchut', 'm.c.', 'mc', 'maa ki chut', 'maa ki', 'teri maa ki', 'maa ke laude', 'm@derchod', 'm@darchod', 'madar**d', 'maadar chod', 'maichod', 'maa chuda', 'maa chod', 'madarchodd',
    'bhenchod', 'behenchod', 'bahenchod', 'bhen chod', 'bhench*d', 'b.c.', 'bc', 'behnchod', 'bhenchut', 'bhaanchod', 'pinchud', 'bhen ka lauda', 'behen ke', 'bhen ke laude', 'bh*enchod', 'b@henchod', 'bhenchodd', 'behenchodd', 'behanchod', 'bahench*d', 'bhen ka lowda',
    'betichod', 'beti chod', 'betic**d', 'bhadva', 'bhaduaa', 'bhadwa', 'bhadwe', 'bhadwaa', 'bhadhava', 'bhadvaa',
    'chutiya', 'chutiye', 'chutiyapa', 'chutiyagiri', 'chut', 'choot', 'chutmar', 'chutmarani', 'chut ke', 'chutia', 'chuttad', 'chutad', 'chute', 'choot marani ka', 'choot ka baal', 'chut ke dhakkan', 'chut ke gulam', 'chut ke pasine', 'chut ka pujari', 'chut ka bhoot',
    'chod', 'chodu', 'choda', 'choding', 'chud', 'chudai', 'chudne', 'chudwa', 'chudwane', 'ch**d', 'chhod', 'chodd', 'chudney', 'chudwaa', 'chudwaane', 'chodna', 'chordo', 'chod dunga', 'chudai khana',
    'bhosdike', 'bhosdi ke', 'bhosadi', 'bhosda', 'bhosdika', 'bhosmarike', 'bosdike', 'bhosrike', 'bhonsdike', 'bhosdiki', 'bhosdiwala', 'bhosdiwale', 'b.s.d.k', 'bsdk', 'bsdk..', 'bhosadchodal', 'bhosadchod', 'bhosada', 'bhosdaa', 'bhonsda', 'bhosdike', 'bhosarchod', 'bhosarch*d',
    // Body/sexual
    'lund', 'lauda', 'lavda', 'loda', 'lodua', 'lodu', 'lod', 'lasan', 'lawda', 'lwd', 'l*da', 'laude', 'laudey', 'laura', 'lora', 'launda', 'laundi', 'laundiya', 'loundiya', 'lulli', 'nunni', 'nunnu', 'lode', 'lund chus', 'lund ke pasine', 'laude ka bal', 'ling', 'lounde', 'laundey', 'jhatt', 'jhaat ke baal', 'jhatu'
    'gaand', 'gand', 'gandu', 'gando', 'gandi', 'gaandmar', 'gandmara', 'gandfaad', 'gandfat', 'gandfut', 'gandiya', 'g*ndu', 'gaand main danda', 'gaand main keera', 'gaand mein bambu', 'gaand ka makhan', 'gaand main lassan', 'gand mari pistol', 'gand ke andhe',
    'chuchi', 'chooche', 'choochi', 'mamme', 'mammey', 'bobe', 'bur', 'burr', 'buur', 'babbe', 'babbey', 'bube', 'bubey', 'mumme', 'chuche', 'boobs', 'chuchi',
    // Animal/low/general
    'kutta', 'kutte', 'kutti', 'kuttiya', 'suar', 'suwar', 'suar ki nasal', 'gadha', 'ullu', 'ullu ka pattha', 'bakland', 'gadhe', 'kuttey', 'kutia', 'kameenay', 'kutte ka awlat', 'kutte ki jat', 'kutte ke tatte', 'kutte ke poot', 'saala kutta', 'saali kutti',
    'randi', 'rand', 'raand', 'randibaaz', 'chhinal', 'chudail', 'chudel', 'item', 'maal', 'landi', 'landy', 'randy', 'chinaal', 'chunni', 'rundi khana', 'randi ke beej',
    'harami', 'haramkhor', 'haramzada', 'haramzade', 'kamina', 'kameena', 'saala', 'saale', 'saali', 'bevda', 'bewda', 'bevakoof', 'bewakoof', 'bakchod', 'bakchodi', 'bakchodd', 'bakchode', 'haramjada', 'haraamjaada', 'haramzyada', 'haraamzyaada', 'haraamjaade', 'haraamzaade', 'haraamkhor',
    'tatti', 'tatti khaye', 'hag', 'hagne', 'pisaab', 'peshab', 'mut', 'moot', 'charsi', 'fattu', 'dalaal', 'dalle', 'dalal', 'dalley', 'tatte', 'tatty', 'paad', 'mootna', 'muttha marna', 'haggu', 'hagney',
    // Threats/combos/regional
    'mar ja', 'mar jaa', 'jal ja', 'kat ja', 'pkmkb', 'klpd', 'chilla chod', 'jhantu', 'ckp', 'bhad mein ja', 'bhaad mein', 'maro', 'marunga', 'maar', 'teri gaand main kute ka lund', 'tere gaand mein keede paday', 'bhen ke takke', 'teri behen ki choot', 'teri bund ch mera kela', 'teri maa chod dunga', 'ullu de pathe',
    // Censored + extras
    'm*drchod', 'bh*enchod', 'ch*tiya', 'b*sdike', 'l*da', 'g*ndu', 'r*ndi', 'm@darch*d', 'bhench*d', 'chut**', 'bh sdike', 'ghanta', 'gel saffa', 'gundmare', 'lannd', 'ma ki aankh', 'meramumele', 'na chundi', 'nee umbu', 'paagal', 'sandha', 'pela', 'bund', 'pandle', 'hijra', 'chullu', 'chhed', 'bhains ki aulad', 'buddha khoosat', 'jhaant ke pissu', 'khotey ki aulda', 'meri gand ka khatmal', 'najayaz paidaish', 'sadi hui gaand', 'aad', 'aand', 'goo', 'gu', 'gote', 'gotey', 'gotte', 'jhat', 'jhaat', 'jhaatu', 'jhatu', 'mooth', 'muth', 'pesab', 'pisab', 'balatkar', 'bun marra', 'teri maa chod', 'teri maa ki aankh', 'teri behen ki choot', 'teri bund ch mera kela', 'teri maa chod dunga', 'ullu de pathe', 'teri maa ki chut', 'teri behen ki chut', 'teri bund ch mera kela', 'teri maa chod dunga', 'ullu de pathe', 'gandmare', 'maa ki','teri maa chod dunga', 'ullu de pathe', 'teri maa ki chut', 'teri behen ki chut', 'teri bund ch mera kela', 'teri maa chod dunga', 'ullu de pathe', 'gandmare', 'maa ki','nali ke keede', 
  ];

  /// Hindi Devanagari – full from Karl Rock + Wikipedia + common lists
  static const List<String> _hindi = [
    'मादरचोद', 'मादरचूत', 'माँचोद', 'माँ की चूत', 'मादरचुत', 'मादरचोद',
    'बहनचोद', 'बहेंचोद', 'भेनचोद', 'बहनचूत', 'बहन की लौड़ा', 'बेहेनचोद', 'बहनचोद',
    'चूतिया', 'चूतिये', 'चूत', 'चूतमार', 'चूतिया पन', 'चुटिया',
    'भोसड़ीके', 'भोसड़ी के', 'भोसड़ा', 'भोसदी', 'भोसड़ीवाला', 'भोसड़ीकी', 'भोसड़ाचोदल', 'भोसड़ाचोद', 'भोसरचोदल', 'भोसदचोद',
    'लौड़ा', 'लुण्ड', 'लोडा', 'लौडा', 'लौंडिया', 'लोड़ा', 'लोडे', 'लंड',
    'गांड', 'गांडू', 'गांड़', 'गांडमार', 'गंडफट', 'गंडिया', 'गंडिये',
    'कुत्ता', 'कुत्ते', 'कुतिया', 'सुअर', 'सूअर की नस्ल', 'गधा', 'गधे', 'गधालंड',
    'हरामी', 'हरामखोर', 'कमीना', 'कामिनी', 'हरामजादा', 'हरामज़ादा', 'हरामजादे', 'हरामज़ादे',
    'रंडी', 'छिनाल', 'चुदैल', 'भड़वा', 'भाड़ में जा', 'भड़ुआ', 'भड़वा',
    'मर जा', 'जल जा', 'कट जा', 'साला', 'साले', 'साली', 'मार', 'मारो', 'मारूंगा',
    'उल्लू', 'उल्लू का पट्ठा', 'गधा', 'बकलोल', 'बेवकूफ', 'बकचोद', 'बकचोदी',
    'पिसाब', 'मूत', 'हग', 'टट्टी', 'टट्टे', 'हग्गू', 'हगने',
    'आंड', 'आंड़', 'आँड', 'लुल्ली', 'नुन्नी', 'पेशाब', 'पेसाब', 'पिल्ला', 'पिल्ले', 'पिसाब',
    'झाट', 'झाटू', 'गू', 'गोटे', 'चरसी', 'चूचे', 'चूची', 'चुची', 'चोद', 'चुदने', 'चुदवा', 'चुदवाने', 'दलाल', 'दलले', 'फट्टू', 'कुत्ती', 'लेंडी', 'लोड़े', 'लौड़े', 'लौंडा', 'लौंडे', 'लौंडी', 'मम्मे', 'मूत', 'मुत', 'मूतने', 'मुतने', 'मूठ', 'मुठ', 'नुननी', 'नुननु', 'पाजी', 'पोरकिस्तान', 'रांड', 'सुअर', 'बेवड़ा', 'बेवड़े', 'बकचोदी', 'बूबे', 'बुर', 'बब्बे', 'आड़', 'आण्ड', 'बालात्कार', 'बेटी चोद',
  ];

  static bool contains(String normalizedWord) {
    final clean = normalizedWord.toLowerCase().trim();
    return _normalizedWords.contains(clean);
  }

  static void addWords(Iterable<String> words) {
    for (final w in words) {
      final clean = w.toLowerCase().trim();
      if (clean.isNotEmpty) _normalizedWords.add(clean);
    }
  }

  static Set<String> get allNormalized => Set<String>.from(_normalizedWords);
}