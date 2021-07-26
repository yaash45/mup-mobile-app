const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

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

app.delete("/:deviceName", (req, res, err) => {
  const options = {
    hostname: "octave-api.sierrawireless.io",
    path: `/v5.0/capstone_uop2021/device/${req.params.deviceName}`,
    method: "DELETE",
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

        if (result.head.status === 200) {
          res.status(200).json(result);
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

exports.device = functions.https.onRequest(app);
