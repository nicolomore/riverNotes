import * as functions from "firebase-functions/v1";
import * as admin from "firebase-admin";
import {google} from "googleapis";

admin.initializeApp();

const playDeveloper = google.androidpublisher("v3");

export const verificaAbbonamento = functions.https.onCall(
  async (data, context) => {
    const token = data.purchaseToken;
    const id = data.productId;
    if (!token || !id) {
      throw new functions.https.HttpsError("invalid-argument", "Dati mancanti");
    }

    const auth = new google.auth.GoogleAuth({
      scopes: ["https://www.googleapis.com/auth/androidpublisher"],
    });
    const authClient = await auth.getClient();
    google.options({auth: authClient as any});

    try {
      const res = await playDeveloper.purchases.subscriptions.get({
        packageName: "com.nicolomore.rivernotes",
        subscriptionId: id,
        token: token,
      });
      const expiry = parseInt(res.data.expiryTimeMillis || "0");
      if (!expiry) {
        throw new Error("expiryTimeMillis mancante nella risposta Google Play");
      }
      const scadenza = new Date(expiry);
      const abbonato = scadenza > new Date();
      const docRef = await admin
        .firestore()
        .collection("abbonamenti")
        .doc(token);
      const docSnap = await docRef.get();

      let rinnovato = false;
      if (docSnap.exists) {
        const precedente = docSnap.data()?.dataScadenza?.toDate?.();
        if (precedente && scadenza.getTime() > precedente.getTime()) {
          rinnovato = true;
        }
      }

      await docRef.set(
        {
          dataScadenza: admin.firestore.Timestamp.fromDate(scadenza),
          abbonato,
          ultimaVerifica: admin.firestore.FieldValue.serverTimestamp(),
          rinnovato,
        },
        {merge: true}
      );

      return {
        abbonato,
        dataScadenza: scadenza.toISOString(),
        rinnovato,
      };
    } catch (e) {
      console.error("Errore verifica abbonamento:", e);
      throw new functions.https.HttpsError(
        "internal",
        "Errore nella verifica con Google Play"
      );
    }
  }
);
