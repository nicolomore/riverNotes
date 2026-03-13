// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'River Notes';

  @override
  String get searchHint => 'Поиск...';

  @override
  String get noNotes => 'Нет заметок';

  @override
  String get deleteNote => 'Удалить заметку';

  @override
  String get deleteConfirmation =>
      'Вы уверены, что хотите удалить эту заметку?';

  @override
  String get cancel => 'Отмена';

  @override
  String get delete => 'Удалить';

  @override
  String get editNote => 'Редактировать заметку';

  @override
  String get titleHint => 'Название';

  @override
  String get contentPlaceholder => 'Пишите здесь...';

  @override
  String get pdfCreation => 'Создание PDF...';

  @override
  String get shareNote => 'Поделитесь своей заметкой!';

  @override
  String get tagName => 'Имя тега';

  @override
  String get addTag => 'Добавить тег';

  @override
  String get addToFavourites => 'Добавить в избранное';

  @override
  String get removeFromFavourites => 'Удалить из избранного';

  @override
  String get addCover => 'Добавить обложку';

  @override
  String get removeCover => 'Удалить обложку';

  @override
  String get pinNote => 'Закрепить вверху';

  @override
  String get unpinNote => 'Открепить';

  @override
  String get noCredits => 'Кредиты исчерпаны';

  @override
  String get minutiEsauriti =>
      'Вы исчерпали 180 минут заметок, сгенерированных ИИ';

  @override
  String get ok => 'ОК';

  @override
  String get untitled => 'Без названия';
}
