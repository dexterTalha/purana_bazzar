const functions = require('firebase-functions');
const admin = require('firebase-admin');
const fetch = require("node-fetch");
admin.initializeApp();

const db = admin.firestore();
exports.sendNotification = functions.firestore.document('Chats/{uniqueId}').onCreate((snap, context) => {
    var value = snap.data();
    var sender = value.sender;
    var receiver = value.receiver;
    var message = value.message;
    db.collection("Users").where('uid', '==', receiver).get().then((v) => {
        v.forEach(d => {
            if(d.data().token && d.data().chattingWith !== sender){
                db.collection("Users").where("uid", '==', sender).get().then(v => {
                    v.forEach(dd=>{
                        const payload = {
                            notification: {
                                title: dd.data().name,
                                body: message,
                                badge: '1',
                                sound: 'default',
                            }
                        };
                        admin
                            .messaging()
                            .sendToDevice(d.data().token, payload)
                            .then(response => {
                                console.log('Successfully sent message:', response);
                            })
                            .catch(error => {
                                console.log('Error sending message:', error);
                            });
                    });
                });
            }
        });
    });
    return null;
});

exports.insertNewUser = functions.firestore.document("Users/{uid}").onCreate(async (snap, context) => {
    var uid1 = context.params.uid;
    var value = snap.data();

    var name1 = value.name;
    var mobile1 = value.mobile;
    var image1 = value.image;
    var address1 = value.address;
    var email1 = value.email;
    var bio1 = value.bio;
    var zipcode = String(String(address1).split(",")[3]).trim();
    const response = await fetch('http://pb.loftyinterior.com/new_api/insert_user.php', {
        method: 'POST',
        body: JSON.stringify({
            uid: uid1,
            name: name1,
            mobile: mobile1,
            email: email1,
            profile: image1,
            address: address1,
            bio: bio1,
            zip_code: zipcode
        }), // string or object
        headers: {
            'Content-Type': 'application/json'
        }

    });
    const myJson = await response.json();
    console.log(myJson);

});
