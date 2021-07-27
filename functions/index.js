const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const db = admin.firestore();

const express = require("express");
const cors = require("cors");
var bodyParser = require("body-parser");

const app = express();
app.use(bodyParser.json()); // to support JSON-encoded bodies
app.use(
  bodyParser.urlencoded({
    // to support URL-encoded bodies
    extended: true,
  })
);

const https = require("https");

// Automatically allow cross-origin requests
app.use(cors({ origin: true }));

app.post("/provision", (req, res, err) => {
  //send initial request to octave to add device
  var imei = req.body.imei;
  var fsn = req.body.fsn;
  var name = req.body.name;

  var options = {
    hostname: "octave-api.sierrawireless.io",
    path: "/v5.0/capstone_uop2021/device/provision",
    method: "POST",
    headers: {
      "X-Auth-Token": functions.config().octave.auth_token,
      "X-Auth-User": functions.config().octave.auth_user,
    },
  };

  var body = JSON.stringify({
    name: name,
    imei: imei,
    fsn: fsn,
  });

  console.log("options :>> ", options);

  var request = https.request(options, (response) => {
    response.setEncoding("utf8");
    var body = "";

    response.on("data", (chunk) => {
      body += chunk;
    });

    response.on("end", () => {
      var result = JSON.parse(body);

      if (result.head.status === 201) {
        res.status(201).json(result);
      } else {
        res
          .status(response.statusCode)
          .send(
            "Unsuccessful provisioning. Result = " + JSON.stringify(result)
          );
      }
    });

    response.on("error", (err) => {
      console.log(err);
      res.status(500).send(err);
    });
  });

  request.write(body);
  request.end();
});

app.get("/:deviceName", (req, res, err) => {
  const options = {
    hostname: "octave-api.sierrawireless.io",
    path: `/v5.0/capstone_uop2021/device/${req.params.deviceName}`,
    method: "GET",
    headers: {
      "X-Auth-Token": functions.config().octave.auth_token,
      "X-Auth-User": functions.config().octave.auth_user,
    },
  };
  https
    .request(options, (response) => {
      response.setEncoding("utf8");
      var body = "";

      response.on("data", (chunk) => {
        body += chunk;
      });

      response.on("end", () => {
        var result = JSON.parse(body);

        if (
          result.head.status === 200 &&
          result.body["provisioningStatus"] === "OPERATIONAL"
        ) {
          res.status(200).json(result);
        } else {
          res
            .status(response.statusCode)
            .send(
              "Unsuccessful device fetch. Result = " + JSON.stringify(result)
            );
        }
      });

      response.on("error", (err) => {
        console.log(err);
        res.status(500).send(err);
      });
    })
    .end();

  req.on("error", (err) => {
    res.status(500).send(err);
  });
});

app.delete("/:deviceName&:imei&:userName", (req, res, err) => {
  const options = {
    hostname: "octave-api.sierrawireless.io",
    path: `/v5.0/capstone_uop2021/device/${req.params.deviceName}`,
    method: "DELETE",
    headers: {
      "X-Auth-Token": functions.config().octave.auth_token,
      "X-Auth-User": functions.config().octave.auth_user,
    },
  };

  console.log("req.params :>> ", req.params);
  https
    .request(options, (response) => {
      response.setEncoding("utf8");
      var body = "";

      response.on("data", (chunk) => {
        body += chunk;
      });

      response.on("end", async () => {
        var result = JSON.parse(body);

        if (result.head.status === 200) {
          deleteDeviceFromFirestore(req.params.imei, req.params.userName)
            .then(() => {
              res.status(200).json(result);
            })
            .catch((err) => {
              console.log("err :>> ", err);
            });
        } else {
          res
            .status(response.statusCode)
            .send(
              "Unsuccessful device delete. Result = " + JSON.stringify(result)
            );
        }
      });

      response.on("error", (err) => {
        console.log(err);
        res.status(500).send(err);
      });
    })
    .end();

  req.on("error", (err) => {
    res.status(500).send(err);
  });
});

const FieldValue = admin.firestore.FieldValue;

async function deleteDeviceFromFirestore(imei, userEmail) {
  let deviceRef = db.collection("devices").doc(imei);

  console.log("In Delete");

  try {
    let userSnapshot = await db
      .collection("users")
      .where("email", "==", userEmail)
      .get();
    if (userSnapshot.empty) {
      console.log("Device collection is empty");
    } else {
      userSnapshot.forEach(async (doc) => {
        var docId = doc.id;
        await db
          .collection("users")
          .doc(docId)
          .update({
            Devices: FieldValue.arrayRemove(deviceRef),
          })
          .then((res) => {
            console.log("device reference delete result :>> ", res);
          })
          .then(() => {
            deviceRef.delete().then((result) => {
              console.log("device delete result :>> ", result);
            });
          })
          .catch((err) => {
            console.log("err :>> ", err);
          });
      });
    }
  } catch (e) {
    console.log("e :>> ", e);
  }
}

exports.device = functions.https.onRequest(app);
