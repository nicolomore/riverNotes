import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'dart:async';

class PaymentService {
  final InAppPurchase acquisto = InAppPurchase.instance;
  bool disponibile = false;
  List<ProductDetails> prodotti = [];
  late SharedPreferences preferenze;
  late StreamSubscription<List<PurchaseDetails>> flussoAcquisto;
  bool abbonato = false;
  int minutiMensili = 0;

  Future<void> isAbbonato(DateTime oggi) async {
    final preferenze = await SharedPreferences.getInstance();
    String? purchaseToken = preferenze.getString("purchaseToken");
    String? productId = preferenze.getString("productId");
    final funzioni = FirebaseFunctions.instance;

    if (purchaseToken == null || productId == null) {
      final abbonatoLocale = preferenze.getBool("abbonato") ?? false;
      final dataStr = preferenze.getString("dataScadenza");
      if (abbonatoLocale && dataStr != null) {
        final data = DateTime.parse(dataStr);
        abbonato = data.isAfter(oggi);
      }
      abbonato = false;
    }
    try {
      abbonato = preferenze.getBool("abbonato") ?? false;
      final risultato = await funzioni
          .httpsCallable("verificaAbbonamento")
          .call({"purchaseToken": purchaseToken, "productId": productId});
      final dati = risultato.data as Map<String, dynamic>;
      abbonato = dati["abbonato"] ?? false;
      final bool rinnovato = dati["rinnovato"] ?? false;
      if (rinnovato) {
        resetMinuti();
      }
      final String? dataScadenzaString = dati["dataScadenza"];
      DateTime? dataScadenza = dataScadenzaString != null
          ? DateTime.parse(dataScadenzaString)
          : null;
      await preferenze.setBool("abbonato", abbonato);
      if (dataScadenza != null) {
        preferenze.setString("dataScadenza", dataScadenza.toIso8601String());
      }
      abbonato = abbonato && dataScadenza != null && dataScadenza.isAfter(oggi);
    } catch (e) {
      final abbonatoLocale = preferenze.getBool("abbonato") ?? false;
      final dataStr = preferenze.getString("dataScadenza");
      if (abbonatoLocale && dataStr != null) {
        final data = DateTime.parse(dataStr);
        abbonato = data.isAfter(oggi);
      }
    }
  }

  void resetMinuti() {
    minutiMensili = 0;
    preferenze.setInt("minutiMensili", minutiMensili);
  }

  Future<void> inizializza() async {
    final Stream<List<PurchaseDetails>> aggiornamentiAcquisto =
        acquisto.purchaseStream;
    flussoAcquisto = aggiornamentiAcquisto.listen(
      (purchaseDetailsList) {
        ascoltaAggiornamento(purchaseDetailsList);
      },
      onDone: () {
        flussoAcquisto.cancel();
      },
      onError: null,
    );
    preferenze = await SharedPreferences.getInstance();
    minutiMensili = preferenze.getInt("minutiMensili") ?? 0;
    final possibile = await acquisto.isAvailable();
    disponibile = possibile;

    if (disponibile) {
      const id = {'standard_ai_notes'};
      final risposta = await acquisto.queryProductDetails(id);
      prodotti = risposta.productDetails;
      await acquisto.restorePurchases();
    }
  }

  bool aggiungiMinuti(int minuti) {
    minutiMensili += minuti;
    preferenze.setInt("minutiMensili", minutiMensili);
    if (minutiMensili >= 180) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> ascoltaAggiornamento(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    for (final purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          fornisciProdotto(purchaseDetails);
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await acquisto.completePurchase(purchaseDetails);
        }
      }
    }
  }

  Future<void> fornisciProdotto(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.productID == "standard_ai_notes") {
      await preferenze.setBool("abbonato", true);
      await preferenze.setString(
        "purchaseToken",
        purchaseDetails.verificationData.serverVerificationData,
      );
      await preferenze.setString("productId", purchaseDetails.productID);
    }
  }

  Future<void> compra(ProductDetails prodotto) async {
    final parametriAcquisto = PurchaseParam(productDetails: prodotto);
    acquisto.buyNonConsumable(purchaseParam: parametriAcquisto);
  }
}
