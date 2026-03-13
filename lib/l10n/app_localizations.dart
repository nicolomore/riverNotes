import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('fr'),
    Locale('it'),
    Locale('ja'),
    Locale('pt'),
    Locale('ru'),
    Locale('zh'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'River Notes'**
  String get appTitle;

  /// Placeholder text for search bar
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get searchHint;

  /// Message when there are no notes
  ///
  /// In en, this message translates to:
  /// **'No notes'**
  String get noNotes;

  /// Delete confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete note'**
  String get deleteNote;

  /// Note deletion confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this note?'**
  String get deleteConfirmation;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Edit note screen title
  ///
  /// In en, this message translates to:
  /// **'Edit note'**
  String get editNote;

  /// Placeholder for title field
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleHint;

  /// Placeholder for note content
  ///
  /// In en, this message translates to:
  /// **'Write here...'**
  String get contentPlaceholder;

  /// Text for PDF creation
  ///
  /// In en, this message translates to:
  /// **'Creating PDF...'**
  String get pdfCreation;

  /// Placeholder for sharing note
  ///
  /// In en, this message translates to:
  /// **'Share your note!'**
  String get shareNote;

  /// Placeholder for tag creation
  ///
  /// In en, this message translates to:
  /// **'Tag name'**
  String get tagName;

  /// Button to add a tag
  ///
  /// In en, this message translates to:
  /// **'Add tag'**
  String get addTag;

  /// Button to add to favorites
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get addToFavourites;

  /// Button to remove from favorites
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get removeFromFavourites;

  /// Button to add a cover
  ///
  /// In en, this message translates to:
  /// **'Add cover'**
  String get addCover;

  /// Button to remove cover
  ///
  /// In en, this message translates to:
  /// **'Remove cover'**
  String get removeCover;

  /// Button to pin note to top
  ///
  /// In en, this message translates to:
  /// **'Pin to top'**
  String get pinNote;

  /// Button to remove note pinning
  ///
  /// In en, this message translates to:
  /// **'Unpin'**
  String get unpinNote;

  /// Alert title to notify that credits are exhausted
  ///
  /// In en, this message translates to:
  /// **'Credits exhausted'**
  String get noCredits;

  /// Alert content notifying minutes exhaustion
  ///
  /// In en, this message translates to:
  /// **'You have used up your 180 minutes of AI-generated notes'**
  String get minutiEsauriti;

  /// Confirmation button
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Default title for notes without a title
  ///
  /// In en, this message translates to:
  /// **'Untitled'**
  String get untitled;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'fr',
    'it',
    'ja',
    'pt',
    'ru',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
