// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'River Notes';

  @override
  String get searchHint => '搜索...';

  @override
  String get noNotes => '没有笔记';

  @override
  String get deleteNote => '删除笔记';

  @override
  String get deleteConfirmation => '您确定要删除此笔记吗?';

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get editNote => '编辑笔记';

  @override
  String get titleHint => '标题';

  @override
  String get contentPlaceholder => '在此书写...';

  @override
  String get pdfCreation => '正在创建PDF...';

  @override
  String get shareNote => '分享您的笔记!';

  @override
  String get tagName => '标签名称';

  @override
  String get addTag => '添加标签';

  @override
  String get addToFavourites => '添加到收藏';

  @override
  String get removeFromFavourites => '从收藏中移除';

  @override
  String get addCover => '添加封面';

  @override
  String get removeCover => '移除封面';

  @override
  String get pinNote => '置顶';

  @override
  String get unpinNote => '取消置顶';

  @override
  String get noCredits => '点数已用完';

  @override
  String get minutiEsauriti => '您已用完180分钟的AI生成笔记时长';

  @override
  String get ok => '确定';

  @override
  String get untitled => '无标题';
}
