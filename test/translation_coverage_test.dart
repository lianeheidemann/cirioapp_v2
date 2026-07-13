import 'package:cirio_app/core/localization/app_language.dart';
import 'package:cirio_app/core/localization/content_translations.dart';
import 'package:cirio_app/data/models/event_model.dart';
import 'package:cirio_app/data/models/news_model.dart';
import 'package:cirio_app/data/models/place_model.dart';
import 'package:cirio_app/data/services/event_service.dart';
import 'package:cirio_app/data/services/news_service.dart';
import 'package:cirio_app/data/services/place_service.dart';
import 'package:cirio_app/features/ai_assistant/ai_assistant_provider.dart';
import 'package:cirio_app/features/ai_assistant/ai_assistant_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('traduz todos os campos textuais dos conteúdos', (tester) async {
    final language = await LanguageProvider.load();
    final contentFuture = Future.wait([
      EventService().fetchEvents(),
      PlaceService().fetchPlaces(),
      LocalNewsService().fetchNews(),
    ]);
    await tester.pump(const Duration(milliseconds: 600));
    final results = await contentFuture;
    final event = (results[0] as List<EventModel>).first;
    final place = (results[1] as List<PlaceModel>).first;
    final news = (results[2] as List<NewsModel>).first;
    var values = <String>[];

    await tester.pumpWidget(ChangeNotifierProvider.value(
      value: language,
      child: Consumer<LanguageProvider>(builder: (context, current, _) {
        return MaterialApp(
          locale: current.locale,
          supportedLocales: const [Locale('pt'), Locale('en')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: Builder(builder: (context) {
            values = [
              for (final field in const [
                'title',
                'date',
                'location',
                'category',
                'description'
              ])
                ContentTranslations.event(context, event, field),
              for (final field in const [
                'name',
                'category',
                'address',
                'description'
              ])
                ContentTranslations.place(context, place, field),
              for (final field in const ['title', 'date', 'summary', 'content'])
                ContentTranslations.news(context, news, field),
            ];
            return const SizedBox();
          }),
        );
      }),
    ));
    final portuguese = List<String>.of(values);

    await language.toggleLanguage();
    await tester.pump();
    final english = List<String>.of(values);

    expect(english, hasLength(portuguese.length));
    for (var index = 0; index < english.length; index++) {
      expect(english[index], isNotEmpty);
      expect(english[index], isNot(portuguese[index]));
    }
  });

  testWidgets('traduz título e campo de entrada do assistente', (tester) async {
    final language = await LanguageProvider.load();

    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: language),
        ChangeNotifierProvider(create: (_) => AiAssistantProvider()),
      ],
      child: Consumer<LanguageProvider>(builder: (context, current, _) {
        return MaterialApp(
          locale: current.locale,
          supportedLocales: const [Locale('pt'), Locale('en')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: AiAssistantScreen(key: ValueKey(current.locale.languageCode)),
        );
      }),
    ));

    expect(find.text('Assistente IA'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Pergunte sobre o Círio...'),
        findsOneWidget);

    await language.toggleLanguage();
    await tester.pump();

    expect(find.text('AI Assistant'), findsOneWidget);
    expect(
        find.widgetWithText(TextField, 'Ask about Círio...'), findsOneWidget);
  });
}
