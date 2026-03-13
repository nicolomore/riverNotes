// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'River Notes';

  @override
  String get searchHint => '検索...';

  @override
  String get noNotes => 'ノートがありません';

  @override
  String get deleteNote => 'ノートを削除';

  @override
  String get deleteConfirmation => 'このノートを削除してもよろしいですか?';

  @override
  String get cancel => 'キャンセル';

  @override
  String get delete => '削除';

  @override
  String get editNote => 'ノートを編集';

  @override
  String get titleHint => 'タイトル';

  @override
  String get contentPlaceholder => 'ここに書く...';

  @override
  String get pdfCreation => 'PDF作成中...';

  @override
  String get shareNote => 'ノートを共有しましょう!';

  @override
  String get tagName => 'タグ名';

  @override
  String get addTag => 'タグを追加';

  @override
  String get addToFavourites => 'お気に入りに追加';

  @override
  String get removeFromFavourites => 'お気に入りから削除';

  @override
  String get addCover => 'カバーを追加';

  @override
  String get removeCover => 'カバーを削除';

  @override
  String get pinNote => '上部に固定';

  @override
  String get unpinNote => '固定解除';

  @override
  String get noCredits => 'クレジットがありません';

  @override
  String get minutiEsauriti => 'AI生成ノートの180分を使い切りました';

  @override
  String get ok => 'OK';

  @override
  String get untitled => '無題';
}
