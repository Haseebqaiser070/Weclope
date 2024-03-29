////const functions = require("firebase-functions");
//
// const functions = require('firebase-functions');
//   const admin = require('firebase-admin');
//   admin.initializeApp();
//
//   exports.sendNotification =
//   functions.https.onCall(async (data, context) => {
//     const targetFcmToken = data.targetFcmToken;
//     const message = data.message;
//
//     const payload = {
//       notification: {
//         title: 'New Message',
//         body: message,
//       },
//     };
//
//     try {
//       const response = await admin.messaging().sendToDevice(targetFcmToken, payload);
//       console.log('Notification sent successfully:', response);
//       return { success: true };
//     } catch (error) {
//       console.error('Error sending notification:', error);
//       return { success: false, error: error.message };
//     }
//   });
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotification = functions.https.onCall(async (data, context) => {
  const { token, title, body } = data;

  const message = {
    notification: {
      title,
      body,
    },
    token,
  };

  try {
    const response = await admin.messaging().send(message);
    console.log('Successfully sent message:', response);
    return { success: true };
  } catch (error) {
    console.error('Error sending message:', error);
    return { error: error.message };
  }
});