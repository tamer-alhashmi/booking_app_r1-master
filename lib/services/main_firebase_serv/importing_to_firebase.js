const admin = require("firebase-admin");
const serviceAccount = require("firebase-adminsdk-3vurb@booking-app-2024.iam.gserviceaccount.com");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-3vurb%40booking-app-2024.iam.gserviceaccount.com"
});

const db = admin.firestore();

// Read JSON file
const jsonData = require("https://raw.githubusercontent.com/tamer-alhashmi/booking_app_r1/master/hotels_daa_test.json?token=GHSAT0AAAAAACN6DLMGC2HQD65WPSUJCL46ZPLUNIQ");

// Function to recursively create collections and documents
function createFirestoreData(data, parentRef) {
  for (let key in data) {
    if (typeof data[key] === "object") {
      // Create collection
      const collectionRef = parentRef.collection(key);
      createFirestoreData(data[key], collectionRef); // Recursive call for nested objects
    } else {
      // Create document
      parentRef.doc(key).set(data[key]);
    }
  }
}

// Start creating Firestore data
createFirestoreData(jsonData, db);
