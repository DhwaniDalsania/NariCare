import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _strings = {
    'en': {
      'appName': 'Naricare',
      'welcomeBack': 'Welcome Back',
      'joinCompanion': 'Join Your Companion',
      'signIn': 'Sign in to continue your cycle journey.',
      'startTracking': 'Start tracking your health with precision.',
      'fullName': 'FULL NAME',
      'emailAddress': 'EMAIL ADDRESS',
      'password': 'PASSWORD',
      'login': 'LOGIN',
      'createAccount': 'CREATE ACCOUNT',
      'noAccount': "Don't have an account? ",
      'haveAccount': 'Already have an account? ',
      'signUp': 'Sign Up',
      'loginText': 'Login',
      'goodDay': 'Good Day,',
      'logDailyInfo': 'LOG DAILY INFO',
      'nextPeriod': 'Next Period',
      'ovulation': 'Ovulation',
      'dailyInsight': 'Daily Insight',
      'dailyInsightText': 'Hydration is key today. Drink at least 8 glasses of water to help with bloating.',
      'profileSettings': 'Profile & Settings',
      'cycleSettings': 'CYCLE SETTINGS',
      'edit': 'EDIT',
      'averageCycle': 'Average Cycle',
      'periodDuration': 'Period Duration',
      'lastPeriodStarted': 'Last period started',
      'notSet': 'Not set',
      'days': 'days',
      'notifications': 'Notifications',
      'passcodeLock': 'Passcode Lock',
      'lutealPhase': 'Luteal Phase',
      'openInMaps': 'Open in Maps',
      'refreshingHistory': 'Refreshing history...',
      'syncingProfile': 'Syncing profile...',
      'language': 'Language',
      'logout': 'LOGOUT',
      'logoutConfirm': 'Are you sure you want to logout?',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'selectLanguage': 'Select Language',
      'nearbyHospitals': 'Nearby Hospitals',
      'clinicsNearYou': 'Clinics & Hospitals Near You',
      'loadingLocation': 'Getting your location...',
      'locationPermissionDenied': 'Location permission denied. Please enable it in settings.',
      'locationDisabled': 'Location services are disabled. Please enable GPS.',
      'locationPermanentDenied': 'Location permissions are permanently denied. Please enable them in app settings.',
      'openSettings': 'Open Settings',
      'retry': 'Retry',
      'noHospitalsFound': 'No hospitals found nearby.',
      'distance': 'km away',
      'hospital': 'Hospital',
      'clinic': 'Clinic',
      'pharmacy': 'Pharmacy',
      'mapView': 'Map',
      'listView': 'List',
      'shop': 'Shop',
      'emergencyKit': 'Emergency Kit',
      'allProducts': 'All',
      'pads': 'Pads',
      'tampons': 'Tampons',
      'cups': 'Cups',
      'painRelief': 'Pain Relief',
      'addToCart': 'Add to Cart',
      'cart': 'Cart',
      'yourCart': 'Your Cart',
      'emptyCart': 'Your cart is empty',
      'total': 'Total',
      'placeOrder': 'Place Order',
      'orderPlaced': 'Order Placed!',
      'orderSuccess': 'Your emergency kit is on its way. Stay comfortable!',
      'continueShopping': 'Continue Shopping',
      'quantity': 'Qty',
      'home': 'Home',
      'calendar': 'Calendar',
      'nearby': 'Nearby',
      'insights': 'Insights',
      'settings': 'Settings',
      'day': 'DAY',
      'tbd': 'TBD',
      'welcomeToCompanion': 'Welcome to Your Companion',
      'setupProfileText': 'We help you track your cycle with precision and care. Let\'s set up your profile.',
      'whenLastPeriod': 'When did your last period start?',
      'trackingPredictText': 'Tracking your start date helps us predict your next cycle accurately.',
      'howLongCycle': 'How long is your usual cycle?',
      'cycleHelpText': 'The number of days between the first day of one period and the first day of the next (usually 21-35 days).',
      'howLongPeriod': 'How long does your period last?',
      'periodHelpText': 'The average number of days of bleeding (usually 3-7 days).',
      'back': 'BACK',
      'next': 'NEXT',
      'finish': 'FINISH',
      'menstrualPhase': 'You are in your menstrual phase. Rest well!',
      'follicularPhase': 'You may feel energetic today!',
      'ovulationPhase': 'You are in your fertile window!',
      'loginToSee': 'Login to see your cycle phase!',
      'startLoggingToSee': 'Start logging to see your cycle phase!',
      'cycleHistory': 'Cycle History',
      'periodLabel': 'Period',
      'fertileLabel': 'Fertile',
      'predictedLabel': 'Predicted',
      'noHistoryFound': 'No history found.',
      'daysDuration': 'days duration',
      'ongoingPeriod': 'Ongoing period',
      'analytics': 'Analytics',
      'cycleTrends': 'CYCLE TRENDS',
      'frequentSymptoms': 'FREQUENT SYMPTOMS',
      'logMoreData': 'Log more data to see trends.',
      'checkout': 'Checkout',
      'checkoutSummary': 'Order Summary',
      'shippingAddress': 'Shipping Address',
      'paymentMethod': 'Payment Method',
      'cashOnDelivery': 'Cash on Delivery',
      'subtotal': 'Subtotal',
      'shipping': 'Shipping',
      'free': 'Free',
      'proceedToCheckout': 'Proceed to Checkout',
      'guest': 'Guest',
      'authFailed': 'Authentication failed. Please check your credentials.',
      'serverUnreachable': 'Server unreachable. Please check your connection.',
      'somethingWrong': 'Something went wrong. Please try again.',
      'nameRequired': 'What is your name?',
      'emailInvalid': 'Enter a valid email',
      'passwordTooShort': 'Minimum 6 characters',
      'dailyLog': 'Daily Log',
      'periodStatus': 'PERIOD STATUS',
      'isTodayPeriodDay': 'Is today a period day?',
      'flowIntensity': 'FLOW INTENSITY',
      'mood': 'MOOD',
      'symptoms': 'SYMPTOMS',
      'light': 'Light',
      'medium': 'Medium',
      'heavy': 'Heavy',
      'happy': 'Happy',
      'neutral': 'Neutral',
      'sad': 'Sad',
      'angry': 'Angry',
      'anxious': 'Anxious',
      'cramps': 'Cramps',
      'headache': 'Headache',
      'bloating': 'Bloating',
      'acne': 'Acne',
      'fatigue': 'Fatigue',
      'backache': 'Backache',
      'notes': 'NOTES',
      'howFeelingToday': 'How are you feeling today?',
      'saveLog': 'SAVE LOG',
      'logSaved': 'Log saved!',
      'errorSavingLog': 'Error saving log',
      'editCycleDate': 'Edit Cycle Dates',
      'logUpdated': 'History updated successfully',
      'update': 'Update',
      'markAsStart': 'Mark as Period Start',
      'deletePeriod': 'Delete Period',
      'editSymptoms': 'Edit Symptoms',
      'periodActions': 'Period Actions',
    },
    'hi': {
      'appName': 'नरीकेयर',
      'welcomeBack': 'वापसी पर स्वागत है',
      'joinCompanion': 'अपने साथी से जुड़ें',
      'signIn': 'अपनी साइकिल यात्रा जारी रखने के लिए साइन इन करें।',
      'startTracking': 'सटीकता के साथ अपने स्वास्थ्य को ट्रैक करना शुरू करें।',
      'fullName': 'पूरा नाम',
      'emailAddress': 'ईमेल पता',
      'password': 'पासवर्ड',
      'login': 'लॉगिन',
      'createAccount': 'खाता बनाएं',
      'noAccount': 'खाता नहीं है? ',
      'haveAccount': 'पहले से खाता है? ',
      'signUp': 'साइन अप',
      'loginText': 'लॉगिन',
      'goodDay': 'नमस्ते,',
      'logDailyInfo': 'रोज़ाना जानकारी दर्ज करें',
      'nextPeriod': 'अगला मासिक',
      'ovulation': 'ओव्यूलेशन',
      'dailyInsight': 'दैनिक सुझाव',
      'dailyInsightText': 'आज पर्याप्त पानी पिएं। सूजन से राहत के लिए कम से कम 8 गिलास पानी पिएं।',
      'profileSettings': 'प्रोफ़ाइल और सेटिंग्स',
      'cycleSettings': 'साइकिल सेटिंग्स',
      'edit': 'संपादित करें',
      'averageCycle': 'औसत साइकिल',
      'periodDuration': 'मासिक अवधि',
      'lastPeriodStarted': 'अंतिम मासिक शुरू हुआ',
      'notSet': 'सेट नहीं',
      'days': 'दिन',
      'notifications': 'सूचनाएं',
      'passcodeLock': 'पासकोड लॉक',
      'language': 'भाषा',
      'logout': 'लॉगआउट',
      'logoutConfirm': 'क्या आप लॉगआउट करना चाहते हैं?',
      'cancel': 'रद्द करें',
      'confirm': 'पुष्टि करें',
      'selectLanguage': 'भाषा चुनें',
      'nearbyHospitals': 'नज़दीकी अस्पताल',
      'clinicsNearYou': 'आपके पास क्लीनिक और अस्पताल',
      'loadingLocation': 'आपका स्थान प्राप्त हो रहा है...',
      'locationPermissionDenied': 'स्थान अनुमति अस्वीकृत। कृपया सेटिंग्स में सक्षम करें।',
      'locationDisabled': 'स्थान सेवाएं अक्षम हैं। कृपया GPS सक्षम करें।',
      'locationPermanentDenied': 'स्थान अनुमति स्थायी रूप से अस्वीकृत है। कृपया ऐप सेटिंग्स में सक्षम करें।',
      'openSettings': 'सेटिंग्स खोलें',
      'retry': 'पुनः प्रयास करें',
      'openInMaps': 'मैप्स में खोलें',
      'refreshingHistory': 'इतिहास रिफ्रेश हो रहा है...',
      'syncingProfile': 'प्रोफ़ाइल सिंक हो रही है...',
      'noHospitalsFound': 'पास में कोई अस्पताल नहीं मिला।',
      'distance': 'किमी दूर',
      'hospital': 'अस्पताल',
      'clinic': 'क्लीनिक',
      'pharmacy': 'दवाखाना',
      'mapView': 'नक्शा',
      'listView': 'सूची',
      'shop': 'दुकान',
      'emergencyKit': 'आपातकालीन किट',
      'allProducts': 'सभी',
      'pads': 'पैड',
      'tampons': 'टैम्पोन',
      'cups': 'कप',
      'painRelief': 'दर्द निवारक',
      'addToCart': 'कार्ट में जोड़ें',
      'cart': 'कार्ट',
      'yourCart': 'आपकी कार्ट',
      'emptyCart': 'आपकी कार्ट खाली है',
      'total': 'कुल',
      'placeOrder': 'ऑर्डर करें',
      'orderPlaced': 'ऑर्डर हो गया!',
      'orderSuccess': 'आपकी आपातकालीन किट रास्ते में है। आराम से रहें!',
      'continueShopping': 'खरीदारी जारी रखें',
      'quantity': 'मात्रा',
      'home': 'होम',
      'calendar': 'कैलेंडर',
      'nearby': 'नज़दीकी',
      'insights': 'विश्लेषण',
      'settings': 'सेटिंग्स',
      'day': 'दिन',
      'tbd': 'अज्ञात',
      'welcomeToCompanion': 'नरीकेयर में स्वागत है',
      'setupProfileText': 'हम आपके चक्र को सटीकता और देखभाल के साथ ट्रैक करने में आपकी मदद करते हैं। आइए अपना प्रोफ़ाइल सेट करें।',
      'whenLastPeriod': 'आपका पिछला मासिक कब शुरू हुआ था?',
      'trackingPredictText': 'शुरुआत की तारीख ट्रैक करने से हमें आपके अगले चक्र की सटीक भविष्यवाणी करने में मदद मिलती है।',
      'howLongCycle': 'आपका सामान्य चक्र कितना लंबा है?',
      'cycleHelpText': 'एक मासिक के पहले दिन और अगले के पहले दिन के बीच के दिनों की संख्या (आमतौर पर 21-35 दिन)।',
      'howLongPeriod': 'आपका मासिक कितने दिनों तक चलता है?',
      'periodHelpText': 'रक्तस्रાવ के दिनों की औसत संख्या (आमतौर पर 3-7 दिन)।',
      'back': 'पीछे',
      'next': 'आगे',
      'finish': 'समाप्त',
      'menstrualPhase': 'आप अपने मासिक धर्म चरण में हैं। आराम करें!',
      'follicularPhase': 'आज आप ऊर्जावान महसूस कर सकते हैं!',
      'ovulationPhase': 'आप अपनी उपजाऊ अवधि में हैं!',
      'lutealPhase': 'आपका अगला मासिक धर्म जल्द ही आ रहा है।',
      'loginToSee': 'अपने चक्र के चरण को देखने के लिए लॉगिन करें!',
      'startLoggingToSee': 'अपने चक्र के चरण को देखने के लिए डेटा दर्ज करना शुरू करें!',
      'cycleHistory': 'साइकिल इतिहास',
      'periodLabel': 'मासिक',
      'fertileLabel': 'उपजाऊ',
      'predictedLabel': 'अनुमानित',
      'noHistoryFound': 'कोई इतिहास नहीं मिला।',
      'daysDuration': 'दिन की अवधि',
      'ongoingPeriod': 'चल रहा मासिक',
      'analytics': 'एनालिटिक्स',
      'cycleTrends': 'साइकिल रुझान',
      'frequentSymptoms': 'नियमित लक्षण',
      'logMoreData': 'रुझान देखने के लिए अधिक डेटा दर्ज करें।',
      'checkout': 'चेकआउट',
      'checkoutSummary': 'ऑर्डर सारांश',
      'shippingAddress': 'शिपिंग पता',
      'paymentMethod': 'भुगतान का तरीका',
      'cashOnDelivery': 'कैश ऑन डिलीवरी',
      'subtotal': 'उप-योग',
      'shipping': 'शिपिंग',
      'free': 'मुफ्त',
      'proceedToCheckout': 'चेकआउट के लिए आगे बढ़ें',
      'dailyLog': 'दैनिक लॉग',
      'periodStatus': 'मासिक धर्म की स्थिति',
      'isTodayPeriodDay': 'क्या आज मासिक धर्म का दिन है?',
      'flowIntensity': 'प्रवाह की तीव्रता',
      'mood': 'मनोदशा',
      'symptoms': 'लક્ષણ',
      'light': 'हल्का',
      'medium': 'मध्यम',
      'heavy': 'भारी',
      'happy': 'खुश',
      'neutral': 'सामान्य',
      'sad': 'उदास',
      'angry': 'गुस्सा',
      'anxious': 'चिंतित',
      'cramps': 'ऐंठन',
      'headache': 'सिरदर्द',
      'bloating': 'सूजन',
      'acne': 'मुँहासे',
      'fatigue': 'थकान',
      'backache': 'पीठ दर्द',
      'notes': 'नोट्स',
      'howFeelingToday': 'आज आप कैसा महसूस कर रहे हैं?',
      'saveLog': 'लॉग सहेजें',
      'logSaved': 'लॉग सहेजा गया!',
      'errorSavingLog': 'लॉग सहेजने में त्रुटि',
      'editCycleDate': 'चक्र की तारीख बदलें',
      'logUpdated': 'इतिहास सफलतापूर्वक अपडेट किया गया',
      'update': 'अपडेट करें',
      'markAsStart': 'पीरियड शुरू होने के रूप में चिह्नित करें',
      'deletePeriod': 'पीरियड हटाएं',
      'editSymptoms': 'लक्षण बदलें',
      'periodActions': 'पीरियड क्रियाएं',
    },
    'gu': {
      'appName': 'નારીકેર',
      'welcomeBack': 'પાછા આવ્યા, સ્વાગત છે',
      'joinCompanion': 'તમારા સાથી સાથે જોડાઓ',
      'signIn': 'તમારી સાઇકલ યાત્રા ચાલુ રાખવા સાઇન ઇન કરો.',
      'startTracking': 'ચોકસાઈ સાથે તમારા સ્વાસ્થ્યને ટ્રૅક કરવાનું શરૂ કરો.',
      'fullName': 'પૂરું નામ',
      'emailAddress': 'ઇમેઇલ સરનામું',
      'password': 'પાસવર્ડ',
      'login': 'લૉગઇન',
      'createAccount': 'ખાતું બનાવો',
      'noAccount': 'ખાતું નથી? ',
      'haveAccount': 'પહેલેથી ખાતું છે? ',
      'signUp': 'સાઇન અપ',
      'loginText': 'લૉગઇન',
      'goodDay': 'નમસ્તે,',
      'logDailyInfo': 'રોજ માહિતી નોંધો',
      'nextPeriod': 'આગામી માસિક',
      'ovulation': 'ઓવ્યૂલેશન',
      'dailyInsight': 'દૈનિક સૂઝ',
      'dailyInsightText': 'આજે વધુ પાણી પીઓ. ફૂલવામાં રાહત માટે ઓછામાં ઓછા 8 ગ્લાસ પાણી પીઓ.',
      'profileSettings': 'પ્રોફાઇલ અને સેટિંગ્સ',
      'cycleSettings': 'સાઇકલ સેટિંગ્સ',
      'edit': 'ફેરફાર',
      'averageCycle': 'સરેરાશ સાઇકલ',
      'periodDuration': 'માસિક અવધિ',
      'lastPeriodStarted': 'છેલ્લું માસિક શરૂ',
      'notSet': 'સેટ નથી',
      'days': 'દિવસ',
      'notifications': 'સૂચનાઓ',
      'passcodeLock': 'પાસકોડ લૉક',
      'language': 'ભાષા',
      'logout': 'લૉગઆઉટ',
      'logoutConfirm': 'શું તમે ખરેખર લૉગઆઉટ કરવા માગો છો?',
      'cancel': 'રદ કરો',
      'confirm': 'પુષ્ટિ કરો',
      'selectLanguage': 'ભાષા પસંદ કરો',
      'nearbyHospitals': 'નજીકની હૉસ્પિટલ',
      'clinicsNearYou': 'તમારી નજીક ક્લિનિક અને હૉસ્પિટલ',
      'loadingLocation': 'તમારું સ્થાન મળી રહ્યું છે...',
      'locationPermissionDenied': 'સ્થાન પરવાનગી નકારી. કૃપા કરી સેટિંગ્સમાં સક્ષમ કરો.',
      'locationDisabled': 'સ્થાન સેવાઓ અક્ષમ છે. કૃપા કરીને GPS સક્ષમ કરો.',
      'locationPermanentDenied': 'સ્થાન પરવાનગી કાયમી ધોરણે નકારવામાં આવી છે. કૃપા કરીને એપ્લિકેશન સેટિંગ્સમાં સક્ષમ કરો.',
      'openSettings': 'સેટિંગ્સ ખોલો',
      'retry': 'ફરી પ્રયાસ કરો',
      'openInMaps': 'નકશામાં ખોલો',
      'refreshingHistory': 'ઇતિહાસ રિફ્રેશ થઈ રહ્યો છે...',
      'syncingProfile': 'પ્રોફાઇલ સિંક થઈ રહી છે...',
      'noHospitalsFound': 'નજીકમાં કોઈ હૉસ્પિટલ મળી નથી.',
      'distance': 'કિ.મી. દૂર',
      'hospital': 'હૉસ્પિટલ',
      'clinic': 'ક્લિનિક',
      'pharmacy': 'દવાખાના',
      'mapView': 'નક્શો',
      'listView': 'સૂચિ',
      'shop': 'દુકાન',
      'emergencyKit': 'ઇમર્જન્સી કીટ',
      'allProducts': 'બધા',
      'pads': 'પૅડ',
      'tampons': 'ટૅમ્પોન',
      'cups': 'કપ',
      'painRelief': 'દર્દ નિવારક',
      'addToCart': 'કાર્ટમાં ઉમેરો',
      'cart': 'કાર્ટ',
      'yourCart': 'તમારી કાર્ટ',
      'emptyCart': 'તમારી કાર્ટ ખાલી છે',
      'total': 'કુલ',
      'placeOrder': 'ઑર્ડર કરો',
      'orderPlaced': 'ઑર્ડર થઈ ગયો!',
      'orderSuccess': 'તમારી ઇમર્જન્સી કીટ રસ્તામાં છે. આરામ કરો!',
      'continueShopping': 'ખરીદી ચાલુ રાખો',
      'quantity': 'જથ્થો',
      'home': 'હોમ',
      'calendar': 'કૅલેન્ડર',
      'nearby': 'નજીક',
      'insights': 'આંતરદૃષ્ટિ',
      'settings': 'સેટિંગ્સ',
      'day': 'દિવસ',
      'tbd': 'અજ્ઞાત',
      'welcomeToCompanion': 'નારીકેરમાં આપનું સ્વાગત છે',
      'setupProfileText': 'અમે તમને તમારી સાઇકલને સચોટતા અને સંભાળ સાથે ટ્રૅક કરવામાં મદદ કરીએ છીએ. ચાલો તમારી પ્રોફાઇલ સેટ કરીએ.',
      'whenLastPeriod': 'તમારું છેલ્લું માસિક ક્યારે શરૂ થયું હતું?',
      'trackingPredictText': 'શરૂઆતની તારીખ ટ્રૅક કરવાથી અમને તમારી આગામી સાઇકલની સચોટ આગાહી કરવામાં મદદ મળે છે.',
      'howLongCycle': 'તમારી સામાન્ય સાઇકલ કેટલી લાંબી છે?',
      'cycleHelpText': 'એક માસિકના પ્રથમ દિવસ અને આગામી માસિકના પ્રથમ દિવસ વચ્ચેના દિવસોની સંખ્યા (સામાન્ય રીતે 21-35 દિવસ).',
      'howLongPeriod': 'તમારું માસિક કેટલા દિવસ ચાલે છે?',
      'periodHelpText': 'રક્તસ્રાવના દિવસોની સરેરાશ સંખ્યા (સામાન્ય રીતે 3-7 દિવસ).',
      'back': 'પાછળ',
      'next': 'આગળ',
      'finish': 'પૂર્ણ',
      'menstrualPhase': 'તમે તમારા માસિક સ્રાવના તબક્કામાં છો. આરામ કરો!',
      'follicularPhase': 'આજે તમે ઉત્સાહિત અનુભવી શકો છો!',
      'ovulationPhase': 'તમે તમારા ફળદ્રુપ સમયગાળામાં છો!',
      'lutealPhase': 'તમારા આગામી માસિક ધર્મ નજીક આવી રહ્યો છે.',
      'loginToSee': 'તમારા ચક્રના તબક્કાને જોવા માટે લોગિન કરો!',
      'startLoggingToSee': 'તમારા ચક્રના તબક્કાને જોવા માટે ડેટા નોધવાનું શરૂ કરો!',
      'cycleHistory': 'સાઇકલ ઇતિહાસ',
      'periodLabel': 'માસિક',
      'fertileLabel': 'ફળદ્રુપ',
      'predictedLabel': 'અનુમાનિત',
      'noHistoryFound': 'કોઈ ઇતિહાસ મળ્યો નથી.',
      'daysDuration': 'દિવસનો સમયગાળો',
      'ongoingPeriod': 'ચાલુ માસિક',
      'analytics': 'એનાલિટિક્સ',
      'cycleTrends': 'સાઇકલ વલણો',
      'frequentSymptoms': 'વારંવાર થતા લક્ષણો',
      'logMoreData': 'વલણો જોવા માટે વધુ ડેટા નોધો.',
      'checkout': 'ચેકઆઉટ',
      'checkoutSummary': 'ઓર્ડરનો સારાંશ',
      'shippingAddress': 'શિપિંગ સરનામું',
      'paymentMethod': 'ચુકવણી પદ્ધતિ',
      'cashOnDelivery': 'રોકડ ઓન ડિલિવરી',
      'subtotal': 'પેટા સરવાળો',
      'shipping': 'શિપિંગ',
      'free': 'મફત',
      'proceedToCheckout': 'ચેકઆઉટ માટે આગળ વધો',
      'dailyLog': 'દૈનિક લોગ',
      'periodStatus': 'માસિક ધર્મની સ્થિતિ',
      'isTodayPeriodDay': 'શું આજે માસિક ધર્મનો દિવસ છે?',
      'flowIntensity': 'પ્રવાહની તીવ્રતા',
      'mood': 'મનોદશા',
      'symptoms': 'લક્ષણો',
      'light': 'હલકો',
      'medium': 'મધ્યમ',
      'heavy': 'ભારે',
      'happy': 'ખુશ',
      'neutral': 'તટસ્થ',
      'sad': 'ઉદાસ',
      'angry': 'ગુસ્સો',
      'anxious': 'ચિંતિત',
      'cramps': 'પીડા',
      'headache': 'માથાનો દુખાવો',
      'bloating': 'ભરડો',
      'acne': 'ખીલ',
      'fatigue': 'થાક',
      'backache': 'પીઠનો દુખાવો',
      'notes': 'નોંધો',
      'howFeelingToday': 'આજે તમે કેવું અનુભવો છો?',
      'saveLog': 'લોગ સાચવો',
      'logSaved': 'લોગ સાચવ્યો!',
      'errorSavingLog': 'લોગ સાચવવામાં ભૂલ',
      'editCycleDate': 'ચક્રની તારીખ બદલો',
      'logUpdated': 'ઇતિહાસ સફળતાપૂર્વક અપડેટ થયો',
      'update': 'અપડેટ કરો',
      'markAsStart': 'પીરિયડ શરૂઆતના દિવસ તરીકે માર્ક કરો',
      'deletePeriod': 'પીરિયડ ડિલીટ કરો',
      'editSymptoms': 'લક્ષણોમાં ફેરફાર કરો',
      'periodActions': 'પીરિયડ એક્શન',
    },
  };

  String get(String key) {
    final langCode = locale.languageCode;
    return _strings[langCode]?[key] ?? _strings['en']?[key] ?? key;
  }

  // Convenience getters
  String get appName => get('appName');
  String get welcomeBack => get('welcomeBack');
  String get joinCompanion => get('joinCompanion');
  String get signIn => get('signIn');
  String get startTracking => get('startTracking');
  String get fullName => get('fullName');
  String get emailAddress => get('emailAddress');
  String get password => get('password');
  String get login => get('login');
  String get createAccount => get('createAccount');
  String get noAccount => get('noAccount');
  String get haveAccount => get('haveAccount');
  String get signUp => get('signUp');
  String get loginText => get('loginText');
  String get goodDay => get('goodDay');
  String get logDailyInfo => get('logDailyInfo');
  String get nextPeriod => get('nextPeriod');
  String get ovulation => get('ovulation');
  String get dailyInsight => get('dailyInsight');
  String get dailyInsightText => get('dailyInsightText');
  String get profileSettings => get('profileSettings');
  String get cycleSettings => get('cycleSettings');
  String get edit => get('edit');
  String get averageCycle => get('averageCycle');
  String get periodDuration => get('periodDuration');
  String get lastPeriodStarted => get('lastPeriodStarted');
  String get notSet => get('notSet');
  String get days => get('days');
  String get notifications => get('notifications');
  String get passcodeLock => get('passcodeLock');
  String get language => get('language');
  String get logout => get('logout');
  String get logoutConfirm => get('logoutConfirm');
  String get cancel => get('cancel');
  String get confirm => get('confirm');
  String get selectLanguage => get('selectLanguage');
  String get nearbyHospitals => get('nearbyHospitals');
  String get clinicsNearYou => get('clinicsNearYou');
  String get loadingLocation => get('loadingLocation');
  String get locationPermissionDenied => get('locationPermissionDenied');
  String get locationDisabled => get('locationDisabled');
  String get locationPermanentDenied => get('locationPermanentDenied');
  String get openSettings => get('openSettings');
  String get retry => get('retry');
  String get noHospitalsFound => get('noHospitalsFound');
  String get distance => get('distance');
  String get hospital => get('hospital');
  String get clinic => get('clinic');
  String get pharmacy => get('pharmacy');
  String get mapView => get('mapView');
  String get listView => get('listView');
  String get shop => get('shop');
  String get emergencyKit => get('emergencyKit');
  String get allProducts => get('allProducts');
  String get pads => get('pads');
  String get tampons => get('tampons');
  String get cups => get('cups');
  String get painRelief => get('painRelief');
  String get addToCart => get('addToCart');
  String get cart => get('cart');
  String get yourCart => get('yourCart');
  String get emptyCart => get('emptyCart');
  String get total => get('total');
  String get placeOrder => get('placeOrder');
  String get orderPlaced => get('orderPlaced');
  String get orderSuccess => get('orderSuccess');
  String get continueShopping => get('continueShopping');
  String get quantity => get('quantity');
  String get home => get('home');
  String get calendar => get('calendar');
  String get nearby => get('nearby');
  String get insights => get('insights');
  String get settings => get('settings');
  String get day => get('day');
  String get tbd => get('tbd');
  String get welcomeToCompanion => get('welcomeToCompanion');
  String get setupProfileText => get('setupProfileText');
  String get whenLastPeriod => get('whenLastPeriod');
  String get trackingPredictText => get('trackingPredictText');
  String get howLongCycle => get('howLongCycle');
  String get cycleHelpText => get('cycleHelpText');
  String get howLongPeriod => get('howLongPeriod');
  String get periodHelpText => get('periodHelpText');
  String get back => get('back');
  String get next => get('next');
  String get finish => get('finish');
  String get cycleHistory => get('cycleHistory');
  String get periodLabel => get('periodLabel');
  String get fertileLabel => get('fertileLabel');
  String get predictedLabel => get('predictedLabel');
  String get noHistoryFound => get('noHistoryFound');
  String get daysDuration => get('daysDuration');
  String get ongoingPeriod => get('ongoingPeriod');
  String get analytics => get('analytics');
  String get cycleTrends => get('cycleTrends');
  String get frequentSymptoms => get('frequentSymptoms');
  String get logMoreData => get('logMoreData');
  String get checkout => get('checkout');
  String get checkoutSummary => get('checkoutSummary');
  String get shippingAddress => get('shippingAddress');
  String get paymentMethod => get('paymentMethod');
  String get cashOnDelivery => get('cashOnDelivery');
  String get subtotal => get('subtotal');
  String get shipping => get('shipping');
  String get free => get('free');
  String get proceedToCheckout => get('proceedToCheckout');
  String get guest => get('guest');
  String get authFailed => get('authFailed');
  String get serverUnreachable => get('serverUnreachable');
  String get somethingWrong => get('somethingWrong');
  String get nameRequired => get('nameRequired');
  String get emailInvalid => get('emailInvalid');
  String get passwordTooShort => get('passwordTooShort');
  String get dailyLog => get('dailyLog');
  String get periodStatus => get('periodStatus');
  String get isTodayPeriodDay => get('isTodayPeriodDay');
  String get flowIntensity => get('flowIntensity');
  String get mood => get('mood');
  String get symptoms => get('symptoms');
  String get light => get('light');
  String get medium => get('medium');
  String get heavy => get('heavy');
  String get happy => get('happy');
  String get neutral => get('neutral');
  String get sad => get('sad');
  String get angry => get('angry');
  String get anxious => get('anxious');
  String get cramps => get('cramps');
  String get headache => get('headache');
  String get bloating => get('bloating');
  String get acne => get('acne');
  String get fatigue => get('fatigue');
  String get backache => get('backache');
  String get notes => get('notes');
  String get howFeelingToday => get('howFeelingToday');
  String get saveLog => get('saveLog');
  String get logSaved => get('logSaved');
  String get errorSavingLog => get('errorSavingLog');
  String get editCycleDate => get('editCycleDate');
  String get logUpdated => get('logUpdated');
  String get openInMaps => get('openInMaps');
  String get refreshingHistory => get('refreshingHistory');
  String get syncingProfile => get('syncingProfile');
  String get update => get('update');
  String get markAsStart => get('markAsStart');
  String get deletePeriod => get('deletePeriod');
  String get editSymptoms => get('editSymptoms');
  String get periodActions => get('periodActions');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'hi', 'gu'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
