var admin = require("firebase-admin");

var serviceAccount = require("C:/Users/nasri/StudioProjects/limitlesspark/serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

var registrationToken = 'd9L0F-icRpiU3DG2BKC2og:APA91bE-xHL6Pn2iWX8T-Y_M1RJbaNI9PE51blMGWvvOoXeb6w14JXGKeFqo7vZ3KpRZMG5KMf4W2YkLRM82czq82fTuG4xMljRvJ9leEms7Wi7kZYGJrOj_hfhqtpf-agR6DObe3LaB';

var message = {
  notification: {
    title: '850',
    body: '2:45'
  },
   //token: registrationToken
};

// Send a message to the device corresponding to the provided
// registration token.
admin.messaging().sendToTopic('345',message)
  .then((response) => {
    // Response is a message ID string.
    console.log('Successfully sent message:', response);
  })
  .catch((error) => {
    console.log('Error sending message:', error);
  });