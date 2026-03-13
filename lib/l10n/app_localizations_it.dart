// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'River Notes';

  @override
  String get searchHint => 'Cerca...';

  @override
  String get noNotes => 'Nessuna nota';

  @override
  String get deleteNote => 'Elimina nota';

  @override
  String get deleteConfirmation => 'Sei sicuro di voler eliminare la nota?';

  @override
  String get cancel => 'Annulla';

  @override
  String get delete => 'Elimina';

  @override
  String get editNote => 'Modifica nota';

  @override
  String get titleHint => 'Titolo';

  @override
  String get contentPlaceholder => 'Scrivi qui...';

  @override
  String get pdfCreation => 'Creazione PDF in corso...';

  @override
  String get shareNote => 'Condividi la tua nota!';

  @override
  String get tagName => 'Nome del tag';

  @override
  String get addTag => 'Aggiungi tag';

  @override
  String get addToFavourites => 'Aggiungi ai preferiti';

  @override
  String get removeFromFavourites => 'Rimuovi dai preferiti';

  @override
  String get addCover => 'Aggiungi copertina';

  @override
  String get removeCover => 'Rimuovi copertina';

  @override
  String get pinNote => 'Fissa in alto';

  @override
  String get unpinNote => 'Non fissare';

  @override
  String get noCredits => 'Crediti esauriti';

  @override
  String get minutiEsauriti =>
      'Hai esaurito i 180 minuti di note generate dall\'AI';

  @override
  String get ok => 'OK';

  @override
  String get untitled => 'Senza titolo';
}
