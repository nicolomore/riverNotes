// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'River Notes';

  @override
  String get searchHint => 'Rechercher...';

  @override
  String get noNotes => 'Aucune note';

  @override
  String get deleteNote => 'Supprimer la note';

  @override
  String get deleteConfirmation =>
      'Êtes-vous sûr de vouloir supprimer cette note ?';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get editNote => 'Modifier la note';

  @override
  String get titleHint => 'Titre';

  @override
  String get contentPlaceholder => 'Écrivez ici...';

  @override
  String get pdfCreation => 'Création du PDF en cours...';

  @override
  String get shareNote => 'Partagez votre note !';

  @override
  String get tagName => 'Nom de l\'étiquette';

  @override
  String get addTag => 'Ajouter une étiquette';

  @override
  String get addToFavourites => 'Ajouter aux favoris';

  @override
  String get removeFromFavourites => 'Retirer des favoris';

  @override
  String get addCover => 'Ajouter une couverture';

  @override
  String get removeCover => 'Retirer la couverture';

  @override
  String get pinNote => 'Épingler en haut';

  @override
  String get unpinNote => 'Désépingler';

  @override
  String get noCredits => 'Crédits épuisés';

  @override
  String get minutiEsauriti =>
      'Vous avez épuisé vos 180 minutes de notes générées par l\'IA';

  @override
  String get ok => 'OK';

  @override
  String get untitled => 'Sans titre';
}
