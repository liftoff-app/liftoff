import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

/// The translations for French (`fr`).
class L10nFr extends L10n {
  L10nFr([String locale = 'fr']) : super(locale);

  @override
  String get settings => 'Paramètres';

  @override
  String get password => 'Mot de passe';

  @override
  String get email_or_username => 'Email ou nom d’utilisateur·rice';

  @override
  String get posts => 'Publications';

  @override
  String get comments => 'Commentaires';

  @override
  String get modlog => 'Historique de modération';

  @override
  String get community => 'Communauté';

  @override
  String get url => 'URL';

  @override
  String get title => 'Titre';

  @override
  String get body => 'Texte';

  @override
  String get nsfw => 'Pas sûr pour le travail (NSFW)';

  @override
  String get post => 'publication';

  @override
  String get save => 'sauvegarder';

  @override
  String get subscribed => 'Abonnés';

  @override
  String get local => 'Local';

  @override
  String get all => 'Tout';

  @override
  String get replies => 'Réponses';

  @override
  String get mentions => 'Mentions';

  @override
  String get from => 'de';

  @override
  String get to => 'dans';

  @override
  String get deleted_by_creator => 'supprimé par le créateur';

  @override
  String get more => 'plus';

  @override
  String get mark_as_read => 'marquer comme lu';

  @override
  String get mark_as_unread => 'marquer comme non-lu';

  @override
  String get reply => 'répondre';

  @override
  String get edit => 'éditer';

  @override
  String get delete => 'supprimer';

  @override
  String get restore => 'restaurer';

  @override
  String get yes => 'oui';

  @override
  String get no => 'non';

  @override
  String get avatar => 'Avatar';

  @override
  String get banner => 'Bannière';

  @override
  String get display_name => 'Nom affiché';

  @override
  String get bio => 'Bio';

  @override
  String get email => 'Email';

  @override
  String get matrix_user => 'Utilisateur Matrix';

  @override
  String get sort_type => 'Trier';

  @override
  String get type => 'Type';

  @override
  String get show_nsfw => 'Afficher le contenu NSFW';

  @override
  String get send_notifications_to_email =>
      'Envoyer des notifications par email';

  @override
  String get delete_account => 'Supprimer le compte';

  @override
  String get saved => 'Sauvegardé';

  @override
  String get communities => 'Communautés';

  @override
  String get users => 'Utilisateurs';

  @override
  String get theme => 'Thème';

  @override
  String get language => 'Langue';

  @override
  String get hot => 'Tendances';

  @override
  String get new_ => 'Nouveaux';

  @override
  String get old => 'Ancien';

  @override
  String get top => 'Top';

  @override
  String get chat => 'Chat';

  @override
  String get admin => 'admin';

  @override
  String get by => 'par';

  @override
  String get not_a_mod_or_admin => 'Pas un modérateur ou un administrateur.';

  @override
  String get not_an_admin => 'Pas administrateur.';

  @override
  String get couldnt_find_post => 'Impossible de trouver la publication.';

  @override
  String get not_logged_in => 'Vous n’êtes pas connecté.';

  @override
  String get site_ban => 'Vous avez été banni du site';

  @override
  String get community_ban => 'Vous avez été banni de cette communauté.';

  @override
  String get downvotes_disabled => 'Votes négatifs désactivés';

  @override
  String get invalid_url => 'URL invalide.';

  @override
  String get locked => 'verrouillé';

  @override
  String get couldnt_create_comment => 'Impossible de publier le commentaire.';

  @override
  String get couldnt_like_comment => 'Impossible d’aimer le commentaire.';

  @override
  String get couldnt_update_comment =>
      'Impossible de mettre à jour le commentaire.';

  @override
  String get no_comment_edit_allowed =>
      'Vous n’êtes pas autorisé à éditer ce commentaire.';

  @override
  String get couldnt_save_comment =>
      'Impossible de sauvegarder le commentaire.';

  @override
  String get couldnt_get_comments => 'Impossible d\'obtenir les commentaires.';

  @override
  String get report_reason_required => 'Raison du signalement requise.';

  @override
  String get report_too_long => 'Rapport trop long.';

  @override
  String get couldnt_create_report => 'Impossible de créer le signalement.';

  @override
  String get couldnt_resolve_report => 'Impossible de résoudre le rapport.';

  @override
  String get invalid_post_title => 'Titre du post invalide';

  @override
  String get couldnt_create_post => 'Impossible de créer la publication.';

  @override
  String get couldnt_like_post => 'Impossible d’aimer la publication.';

  @override
  String get couldnt_find_community =>
      'Impossible de trouver cette communauté.';

  @override
  String get couldnt_get_posts => 'Impossible d’obtenir les publications';

  @override
  String get no_post_edit_allowed =>
      'Vous n’êtes pas autorisé à éditer cette publication.';

  @override
  String get couldnt_save_post => 'Impossible de sauvegarder la publication.';

  @override
  String get site_already_exists => 'Le site existe déjà.';

  @override
  String get couldnt_update_site => 'Impossible de mettre à jour le site.';

  @override
  String get invalid_community_name => 'Nom invalide.';

  @override
  String get community_already_exists => 'Cette communauté existe déjà.';

  @override
  String get community_moderator_already_exists =>
      'Ce membre est déjà modérateur.';

  @override
  String get community_follower_already_exists => 'Ce membre est déjà abonné.';

  @override
  String get not_a_moderator => 'N\'êtes pas un modérateur.';

  @override
  String get couldnt_update_community =>
      'Impossible de mettre à jour cette communauté.';

  @override
  String get no_community_edit_allowed =>
      'Vous n’êtes pas autorisé à éditer cette communauté.';

  @override
  String get system_err_login =>
      'Erreur système. Essayez de vous déconnecter puis de vous reconnecter.';

  @override
  String get community_user_already_banned => 'Ce membre est déjà banni.';

  @override
  String get couldnt_find_that_username_or_email =>
      'Impossible de trouver cet·te utilisateur·rice ou cet email.';

  @override
  String get password_incorrect => 'Mot de passe incorrect.';

  @override
  String get registration_closed => 'Inscriptions fermées';

  @override
  String get invalid_password =>
      'Mot de passe erroné. La longueur du mot de passe doit être <= 60 caractères.';

  @override
  String get passwords_dont_match => 'Les mots de passes ne correspondent pas.';

  @override
  String get captcha_incorrect => 'Captcha erroné.';

  @override
  String get invalid_username => 'Nom d\'utilisateur invalide.';

  @override
  String get bio_length_overflow =>
      'La bio utilisateur ne peut dépasser 300 caractères.';

  @override
  String get couldnt_update_user =>
      'Impossible de mettre à jour l’utilisateur·rice.';

  @override
  String get couldnt_update_private_message =>
      'Impossible de modifier le message privé.';

  @override
  String get couldnt_update_post =>
      'Impossible de mettre à jour la publication';

  @override
  String get couldnt_create_private_message =>
      'Impossible de créer un message privé.';

  @override
  String get no_private_message_edit_allowed =>
      'Pas autorisé à modifier un message privé.';

  @override
  String get post_title_too_long => 'Le titre de la publication est trop long.';

  @override
  String get email_already_exists => 'L’email existe déjà.';

  @override
  String get user_already_exists => 'L’utilisateur·rice existe déjà.';

  @override
  String number_of_users_online(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count Utilisateur en ligne',
      other: '$count Utilisateurs en ligne',
    );
  }

  @override
  String number_of_comments(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$countString Commentaire',
      other: '$countString Commentaires',
    );
  }

  @override
  String number_of_posts(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$countString Publication',
      other: '$countString Publications',
    );
  }

  @override
  String number_of_subscribers(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count Abonné',
      other: '$count Abonnés',
    );
  }

  @override
  String number_of_users(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count Utilisateur',
      other: '$count Utilisateurs',
    );
  }

  @override
  String get unsubscribe => 'Se désabonner';

  @override
  String get subscribe => 'S’abonner';

  @override
  String get messages => 'Messages';

  @override
  String get banned_users => 'Utilisateurs interdits';

  @override
  String get delete_account_confirm =>
      'Avertissement : cette action supprimera toutes vos données de façons permanente ! Saisissez votre mot de passe pour confirmer.';

  @override
  String get new_password => 'Nouveau mot de passe';

  @override
  String get verify_password => 'Vérifiez le mot de passe';

  @override
  String get old_password => 'Ancien mot de passe';

  @override
  String get show_avatars => 'Afficher les avatars';

  @override
  String get search => 'Rechercher';

  @override
  String get send_message => 'Envoyer le message';

  @override
  String get top_day => 'Top du jour';

  @override
  String get top_week => 'Top de la semaine';

  @override
  String get top_month => 'Top du mois';

  @override
  String get top_year => 'Top de l\'année';

  @override
  String get top_all => 'Top';

  @override
  String get most_comments => 'Plus commentés';

  @override
  String get new_comments => 'Nouveaux commentaires';

  @override
  String get active => 'Actif';

  @override
  String get bot_account => 'Bot Account';

  @override
  String get show_bot_accounts => 'Show Bot Accounts';

  @override
  String get show_read_posts => 'Show Read Posts';
}
