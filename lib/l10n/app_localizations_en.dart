// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'River Notes';

  @override
  String get searchHint => 'Search...';

  @override
  String get noNotes => 'No notes';

  @override
  String get deleteNote => 'Delete note';

  @override
  String get deleteConfirmation => 'Are you sure you want to delete this note?';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get editNote => 'Edit note';

  @override
  String get titleHint => 'Title';

  @override
  String get contentPlaceholder => 'Write here...';

  @override
  String get pdfCreation => 'Creating PDF...';

  @override
  String get shareNote => 'Share your note!';

  @override
  String get tagName => 'Tag name';

  @override
  String get addTag => 'Add tag';

  @override
  String get addToFavourites => 'Add to favorites';

  @override
  String get removeFromFavourites => 'Remove from favorites';

  @override
  String get addCover => 'Add cover';

  @override
  String get removeCover => 'Remove cover';

  @override
  String get pinNote => 'Pin to top';

  @override
  String get unpinNote => 'Unpin';

  @override
  String get noCredits => 'Credits exhausted';

  @override
  String get minutiEsauriti =>
      'You have used up your 180 minutes of AI-generated notes';

  @override
  String get ok => 'OK';

  @override
  String get untitled => 'Untitled';
}
