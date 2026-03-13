// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'River Notes';

  @override
  String get searchHint => 'Suchen...';

  @override
  String get noNotes => 'Keine Notizen';

  @override
  String get deleteNote => 'Notiz löschen';

  @override
  String get deleteConfirmation => 'Möchten Sie diese Notiz wirklich löschen?';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get editNote => 'Notiz bearbeiten';

  @override
  String get titleHint => 'Titel';

  @override
  String get contentPlaceholder => 'Hier schreiben...';

  @override
  String get pdfCreation => 'PDF wird erstellt...';

  @override
  String get shareNote => 'Teilen Sie Ihre Notiz!';

  @override
  String get tagName => 'Tag-Name';

  @override
  String get addTag => 'Tag hinzufügen';

  @override
  String get addToFavourites => 'Zu Favoriten hinzufügen';

  @override
  String get removeFromFavourites => 'Aus Favoriten entfernen';

  @override
  String get addCover => 'Cover hinzufügen';

  @override
  String get removeCover => 'Cover entfernen';

  @override
  String get pinNote => 'Oben anheften';

  @override
  String get unpinNote => 'Loslösen';

  @override
  String get noCredits => 'Credits aufgebraucht';

  @override
  String get minutiEsauriti =>
      'Sie haben Ihre 180 Minuten KI-generierter Notizen aufgebraucht';

  @override
  String get ok => 'OK';

  @override
  String get untitled => 'Ohne Titel';
}
