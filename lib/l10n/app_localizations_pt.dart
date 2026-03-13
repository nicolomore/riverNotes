// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'River Notes';

  @override
  String get searchHint => 'Pesquisar...';

  @override
  String get noNotes => 'Nenhuma nota';

  @override
  String get deleteNote => 'Excluir nota';

  @override
  String get deleteConfirmation =>
      'Tem certeza de que deseja excluir esta nota?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Excluir';

  @override
  String get editNote => 'Editar nota';

  @override
  String get titleHint => 'Título';

  @override
  String get contentPlaceholder => 'Escreva aqui...';

  @override
  String get pdfCreation => 'Criando PDF...';

  @override
  String get shareNote => 'Compartilhe sua nota!';

  @override
  String get tagName => 'Nome da etiqueta';

  @override
  String get addTag => 'Adicionar etiqueta';

  @override
  String get addToFavourites => 'Adicionar aos favoritos';

  @override
  String get removeFromFavourites => 'Remover dos favoritos';

  @override
  String get addCover => 'Adicionar capa';

  @override
  String get removeCover => 'Remover capa';

  @override
  String get pinNote => 'Fixar no topo';

  @override
  String get unpinNote => 'Desafixar';

  @override
  String get noCredits => 'Créditos esgotados';

  @override
  String get minutiEsauriti =>
      'Você esgotou seus 180 minutos de notas geradas por IA';

  @override
  String get ok => 'OK';

  @override
  String get untitled => 'Sem título';
}
