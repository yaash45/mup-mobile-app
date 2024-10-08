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

exports.createAndApplyBlueprint = functions.firestore
  .document("devices/{imei}")
  .onCreate(async (snapshot, context) => {
    var data = snapshot.data();

    try {
      var newBlueprint = await createBlueprint(data["body"]["name"]);
      console.log("newBlueprint :>> ", newBlueprint);
      var applyBlueprintResponse = await applyBlueprint(
        newBlueprint,
        data["body"]["id"]
      );
      console.log(
        "applyBlueprintResponse.head.status :>> ",
        applyBlueprintResponse.head.status
      );

      // promises to create environment sensors cloud connectors
      var cloudConnectorPromises = createEnvironmentCloudConnectorPromises(
        data["body"]["name"],
        context.params.imei
      );

      // add promise to create coordinates cloud connector
      cloudConnectorPromises.push(
        createCoordinatesCloudConnector(
          data["body"]["name"],
          context.params.imei
        )
      );

      // add promise to create vps_shot cloud connector
      cloudConnectorPromises.push(
        createVpsShotCloudConnector(data["body"]["name"], context.params.imei)
      );

      var responses = await Promise.all(cloudConnectorPromises);

      var cloudConnectorIdMap = {};

      for (var i = 0; i < responses.length; ++i) {
        var response = responses[i];
        cloudConnectorIdMap[`${response.displayName}`] = response.id;
      }

      console.log("cloudConnectorIdMap :>> ", cloudConnectorIdMap);

      var writeResult = await db
        .collection("cloudConnectors")
        .doc(`${context.params.imei}`)
        .set(cloudConnectorIdMap);

      console.log("writeResult :>> ", writeResult);
    } catch (e) {
      console.error(e);
    }
  });

function createBlueprint(deviceName) {
  return new Promise((resolve, reject) => {
    const defaultMessagesPerHour = 60;
    const createBlueprintOptions = {
      hostname: "octave-api.sierrawireless.io",
      path: `/v5.0/capstone_uop2021/blueprint/`,
      method: "POST",
      headers: {
        "X-Auth-Token": functions.config().octave.auth_token,
        "X-Auth-User": functions.config().octave.auth_user,
      },
    };

    var period = parseInt(`${3600 / defaultMessagesPerHour}`, 10);
    var body = {
      displayName: deviceName,
      observations: {
        "/environment/value": {
          co2e: {
            period: period,
            select: "co2EquivalentValue",
            function: null,
            destination: "cloudInterface",
            gte: null,
            step: null,
            buffer: null,
            lte: null,
          },
          iaq: {
            period: period,
            select: "iaqValue",
            function: null,
            destination: "cloudInterface",
            gte: null,
            step: null,
            buffer: null,
            lte: null,
          },
          temperature: {
            period: period,
            select: "temperature",
            function: null,
            destination: "cloudInterface",
            gte: null,
            step: null,
            buffer: null,
            lte: null,
          },
          breath_voc: {
            period: period,
            select: "breathVocValue",
            function: null,
            destination: "cloudInterface",
            gte: null,
            step: null,
            buffer: null,
            lte: null,
          },
          humidity: {
            period: period,
            select: "humidity",
            function: null,
            destination: "cloudInterface",
            gte: null,
            step: null,
            buffer: null,
            lte: null,
          },
          pressure: {
            period: period,
            select: "pressure",
            function: null,
            destination: "cloudInterface",
            gte: null,
            step: null,
            buffer: null,
            lte: null,
          },
        },
        "/location/coordinates/value": {
          coordinates: {
            period: period,
            select: null,
            function: null,
            destination: "cloudInterface",
            gte: null,
            step: null,
            buffer: null,
            lte: null,
          },
        },
        "/orp/asset/vps_shot": {
          vps_shot: {
            period: null,
            function: null,
            destination: "cloudInterface",
            gte: null,
            step: 1,
            buffer: null,
            lte: null,
          },
        },
      },
      state: {
        "/imu/temp/enable": true,
        "/location/coordinates/period": 10,
        "/imu/gyro/period": 10,
        "/io/config": {
          devs: [
            {
              conf: [
                {
                  baud: "9600",
                  routing: "IOT0",
                  wire: "2",
                  stop: "1",
                  own: "orp",
                  bits: 8,
                  type: "UART1",
                  pair: "N",
                  flow: "N",
                },
              ],
              type: "serial",
            },
          ],
        },
        "/cloudInterface/developer_mode/close_on_inactivity": false,
        "/imu/accel/enable": true,
        "/imu/temp/period": 10,
        "/imu/gyro/enable": true,
        "/environment/lowPower": false,
        "/environment/enable": true,
        "/location/coordinates/enable": true,
        "/cloudInterface/developer_mode/enable": true,
        "/imu/accel/period": 10,
        "/environment/ambientAirTemp": 25,
      },
    };

    var req = https.request(createBlueprintOptions, (res) => {
      res.setEncoding("utf8");
      var response = "";

      res.on("data", (d) => {
        response += d;
      });

      res.on("end", () => {
        var jsonResponse = JSON.parse(response);

        if (jsonResponse.head.status === 201) {
          var result = {
            id: jsonResponse.body.id,
            displayName: jsonResponse.body.displayName,
            version: jsonResponse.body.version,
          };
          resolve(result);
        } else {
          reject(jsonResponse);
        }
      });
    });

    req.on("error", (err) => {
      reject(err);
    });

    req.write(JSON.stringify(body));
    req.end();
  });
}

function applyBlueprint(newBlueprint, deviceId) {
  return new Promise((resolve, reject) => {
    const applyBlueprintOptions = {
      hostname: "octave-api.sierrawireless.io",
      path: `/v5.0/capstone_uop2021/blueprint/apply`,
      method: "PUT",
      headers: {
        "X-Auth-Token": functions.config().octave.auth_token,
        "X-Auth-User": functions.config().octave.auth_user,
      },
    };

    var body = {
      blueprint: {
        id: newBlueprint["id"],
        version: newBlueprint["version"],
      },
      deviceIds: [deviceId],
    };

    var req = https.request(applyBlueprintOptions, (res) => {
      res.setEncoding("utf8");
      var response = "";

      res.on("data", (d) => {
        response += d;
      });

      res.on("end", () => {
        var jsonResponse = JSON.parse(response);

        if (jsonResponse.head.status === 200) {
          resolve(jsonResponse);
        } else {
          reject(jsonResponse);
        }
      });
    });

    req.on("error", (err) => reject(err));

    req.write(JSON.stringify(body));
    req.end();
  });
}

exports.deleteBlueprint = functions.firestore
  .document("devices/{imei}")
  .onDelete(async (snapshot, context) => {
    var deviceData = snapshot.data();

    try {
      var deleteBlueprintResponse = await deleteBlueprint(
        deviceData["body"]["blueprintId"]["id"]
      );

      console.log(
        "deleteBlueprintResponse.head.status :>> ",
        deleteBlueprintResponse.head.status
      );

      // get all cloud connectors for device
      var cloudConnectorsDocument = await db
        .collection("cloudConnectors")
        .doc(`${context.params.imei}`)
        .get();

      var environmentConnectorsDeletePromises =
        deleteEnvironmentCloudConnectors(cloudConnectorsDocument.data());

      var responses = await Promise.all(environmentConnectorsDeletePromises);
      console.log("responses.length :>> ", responses.length);
      await db
        .collection("cloudConnectors")
        .doc(`${context.params.imei}`)
        .delete();
    } catch (err) {
      console.error(err);
    }
  });

function deleteBlueprint(blueprintId) {
  return new Promise((resolve, reject) => {
    const deleteBlueprintOptions = {
      hostname: "octave-api.sierrawireless.io",
      path: `/v5.0/capstone_uop2021/blueprint/${blueprintId}`,
      method: "DELETE",
      headers: {
        "X-Auth-Token": functions.config().octave.auth_token,
        "X-Auth-User": functions.config().octave.auth_user,
      },
    };

    var req = https.request(deleteBlueprintOptions, (res) => {
      res.setEncoding("utf8");
      var response = "";

      res.on("data", (d) => {
        response += d;
      });

      res.on("end", () => {
        var jsonResult = JSON.parse(response);

        if (jsonResult.head.status === 200) {
          resolve(jsonResult);
        } else {
          reject(jsonResult);
        }
      });
    });

    req.on("error", (err) => reject(err));
    req.end();
  });
}

function createEnvironmentCloudConnectorPromises(deviceName, deviceImei) {
  var environmentResources = {
    temperature: { unit: `°C`, type: `temperature` },
    breathVocValue: { unit: `ug/m3`, type: `breath_voc` },
    iaqValue: { unit: `iaq`, type: `iaq` },
    humidity: { unit: `%`, type: `humidity` },
    pressure: { unit: `pa`, type: `pressure` },
    co2EquivalentValue: { unit: `co2e`, type: `co2e` },
  };

  var cloudCreatorPromises = [];

  for (var resource in environmentResources) {
    var sensor = environmentResources[resource];

    cloudCreatorPromises.push(
      new Promise((resolve, reject) => {
        const createCloudConnectorOptions = {
          hostname: "octave-api.sierrawireless.io",
          path: `/v5.0/capstone_uop2021/connector/`,
          method: "POST",
          headers: {
            "X-Auth-Token": functions.config().octave.auth_token,
            "X-Auth-User": functions.config().octave.auth_user,
          },
        };
        var body = {
          type: "http-connector",
          source: `/capstone_uop2021/devices/${deviceName}/${sensor.type}`,
          disabled: false,
          displayName: `${deviceName}: ${sensor.type}`,
          description: `${deviceName}: ${sensor.type}`,
          js: `function (event) {\n\t\n\tvar timestamp = event.generatedDate;\n  var value = event.elems.environment.${resource};\n\n\tvar body = JSON.stringify({\n    "fields": {\n      "imei": {\n\t\t\t\t"integerValue": ${deviceImei}\n      },\n      "type": {\n        "stringValue": "${sensor.type}"\n      },\n      "timestamp": {\n        "integerValue": timestamp\n      },\n      "value": {\n        "doubleValue": value\n      },\n      "unit": {\n        "stringValue": "${sensor.unit}"\n      },\n      "anomaly": {\n        "booleanValue": false\n      }\n    }\n  });\n  \n\treturn body;\n}`,
          routingScript:
            'function (event) {\n\n\treturn "https://firestore.googleapis.com/v1/projects/capstonemuop/databases/(default)/documents/datapoints"\n\n}',
          headers: {
            "Content-Type": "application/json",
          },
          properties: {
            method: "POST",
            successCodes: [
              200, 201, 202, 203, 204, 205, 206, 207, 226, 400, 401, 402, 403,
              404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416,
              417, 418, 422, 423, 424, 426, 428, 429, 431, 451,
            ],
          },
        };

        var req = https.request(createCloudConnectorOptions, (res) => {
          res.setEncoding("utf8");
          var response = "";

          res.on("data", (d) => {
            response += d;
          });

          res.on("end", () => {
            var jsonResult = JSON.parse(response);
            if (jsonResult.head.status === 201) {
              var displayNameSplit =
                `${jsonResult["body"]["displayName"]}`.split(": ");
              resolve({
                id: jsonResult["body"]["id"],
                displayName:
                  displayNameSplit.length == 2
                    ? displayNameSplit[1]
                    : jsonResult["body"]["displayName"],
              });
            } else {
              reject(jsonResult);
            }
          });
        });

        req.on("error", (err) => reject(err));
        req.write(JSON.stringify(body));
        req.end();
      })
    );
  }

  return cloudCreatorPromises;
}

function createCoordinatesCloudConnector(deviceName, deviceImei) {
  return new Promise((resolve, reject) => {
    const createCloudConnectorOptions = {
      hostname: "octave-api.sierrawireless.io",
      path: `/v5.0/capstone_uop2021/connector/`,
      method: "POST",
      headers: {
        "X-Auth-Token": functions.config().octave.auth_token,
        "X-Auth-User": functions.config().octave.auth_user,
      },
    };

    var sensor = "coordinates";
    var body = {
      type: "http-connector",
      source: `/capstone_uop2021/devices/${deviceName}/${sensor}`,
      disabled: false,
      displayName: `${deviceName}: ${sensor}`,
      description: `${deviceName}: ${sensor}`,
      js: `function (event) {\n\n  var ts = event.elems.location.coordinates.ts;\n  var alt = event.elems.location.coordinates.alt;\n  var vAcc = event.elems.location.coordinates.vAcc;\n  var hAcc = event.elems.location.coordinates.hAcc;\n  var lat = event.elems.location.coordinates.lat;\n  var lon = event.elems.location.coordinates.lon;\n  var fixType = event.elems.location.coordinates.fixType;\n\n\tvar body = JSON.stringify({\n    "fields": {\n      "imei": {\n\t\t\t\t"integerValue": ${deviceImei}\n      },\n      "type": {\n        "stringValue": "location"\n      },\n      "timestamp": {\n        "integerValue": ts\n      },\n      "alt": {\n        "doubleValue": alt\n      },\n      "vAcc": {\n        "integerValue": vAcc\n      },\n      "hAcc": {\n        "integerValue": hAcc\n      },\n      "lat": {\n        "doubleValue": lat\n      },\n      "lon": {\n        "doubleValue": lon\n      },\n      "unit": {\n        "stringValue": fixType\n      }\n    }\n  });\n  \n\treturn body;\n}`,
      routingScript:
        'function (event) {\n\n\treturn "https://firestore.googleapis.com/v1/projects/capstonemuop/databases/(default)/documents/mangoh_resources"\n\n}',
      headers: {
        "Content-Type": "application/json",
      },
      properties: {
        method: "POST",
        successCodes: [
          200, 201, 202, 203, 204, 205, 206, 207, 226, 400, 401, 402, 403, 404,
          405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416, 417, 418,
          422, 423, 424, 426, 428, 429, 431, 451,
        ],
      },
    };

    var req = https.request(createCloudConnectorOptions, (res) => {
      res.setEncoding("utf8");
      var response = "";

      res.on("data", (d) => {
        response += d;
      });

      res.on("end", () => {
        var jsonResult = JSON.parse(response);
        if (jsonResult.head.status === 201) {
          var displayNameSplit = `${jsonResult["body"]["displayName"]}`.split(
            ": "
          );
          resolve({
            id: jsonResult["body"]["id"],
            displayName:
              displayNameSplit.length == 2
                ? displayNameSplit[1]
                : jsonResult["body"]["displayName"],
          });
        } else {
          reject(jsonResult);
        }
      });
    });

    req.on("error", (err) => reject(err));
    req.write(JSON.stringify(body));
    req.end();
  });
}

function createVpsShotCloudConnector(deviceName, deviceImei) {
  return new Promise((resolve, reject) => {
    const createCloudConnectorOptions = {
      hostname: "octave-api.sierrawireless.io",
      path: `/v5.0/capstone_uop2021/connector/`,
      method: "POST",
      headers: {
        "X-Auth-Token": functions.config().octave.auth_token,
        "X-Auth-User": functions.config().octave.auth_user,
      },
    };

    var sensor = "vps_shot";
    var body = {
      type: "http-connector",
      source: `/capstone_uop2021/devices/${deviceName}/${sensor}`,
      disabled: false,
      displayName: `${deviceName}: ${sensor}`,
      description: `${deviceName}: ${sensor}`,
      js: `function (event) {\n\t\n\tvar object = event.elems.orp.asset.vps_shot;\n\n\tvar body = JSON.stringify({\n    "fields": {\n      "base64encode": {\n\t\t\t\t"stringValue": object\n      },\n      "decoded": {\n        "booleanValue": false\n      }\n    }\n  });\n  \n\treturn body\n}`,
      routingScript:
        'function (event) {\n\n\treturn "https://firestore.googleapis.com/v1/projects/capstonemuop/databases/(default)/documents/alerts/detectedimage"\n\n}',
      headers: {
        "Content-Type": "application/json",
      },
      properties: {
        method: "POST",
        successCodes: [
          200, 201, 202, 203, 204, 205, 206, 207, 226, 400, 401, 402, 403, 404,
          405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416, 417, 418,
          422, 423, 424, 426, 428, 429, 431, 451,
        ],
      },
    };

    var req = https.request(createCloudConnectorOptions, (res) => {
      res.setEncoding("utf8");
      var response = "";

      res.on("data", (d) => {
        response += d;
      });

      res.on("end", () => {
        var jsonResult = JSON.parse(response);
        if (jsonResult.head.status === 201) {
          var displayNameSplit = `${jsonResult["body"]["displayName"]}`.split(
            ": "
          );
          resolve({
            id: jsonResult["body"]["id"],
            displayName:
              displayNameSplit.length == 2
                ? displayNameSplit[1]
                : jsonResult["body"]["displayName"],
          });
        } else {
          reject(jsonResult);
        }
      });
    });

    req.on("error", (err) => reject(err));
    req.write(JSON.stringify(body));
    req.end();
  });
}

function deleteEnvironmentCloudConnectors(cloudConnectorData) {
  var deletePromises = [];

  for (var connector in cloudConnectorData) {
    var id = cloudConnectorData[connector];
    deletePromises.push(
      new Promise((resolve, reject) => {
        const deleteCloudConnectorOptions = {
          hostname: "octave-api.sierrawireless.io",
          path: `/v5.0/capstone_uop2021/connector/${id}`,
          method: "DELETE",
          headers: {
            "X-Auth-Token": functions.config().octave.auth_token,
            "X-Auth-User": functions.config().octave.auth_user,
          },
        };

        var req = https.request(deleteCloudConnectorOptions, (res) => {
          res.setEncoding("utf8");
          var response = "";

          res.on("data", (d) => {
            response += d;
          });

          res.on("end", () => {
            var jsonResult = JSON.parse(response);

            if (jsonResult.head.status === 200) {
              resolve(jsonResult);
            } else {
              reject(jsonResult);
            }
          });
        });

        req.on("error", (err) => reject(err));
        req.end();
      })
    );
  }

  return deletePromises;
}

//Frequency profile
exports.frequencyProfile = functions.firestore
  .document("frequencyProfile/{imei}")
  .onUpdate(async (change, context) => {
    var imei = context.params.imei;
    var updatedFrequencyProfile = change.after.data();

    var deviceSnapshot = await db.collection("devices").doc(`${imei}`).get();

    if (!deviceSnapshot.exists) {
      console.log("No such document with imei = ", imei);
    } else {
      var deviceData = deviceSnapshot.data();

      // Update blueprint
      var blueprintId = deviceData["body"]["blueprintId"]["id"];
      var newBlueprint = await updateBlueprint(
        updatedFrequencyProfile["messagesPerHour"],
        blueprintId
      );
      console.log("newBlueprint :>> ", newBlueprint);

      // Apply updated blueprint to device
      var deviceId = deviceData["body"]["id"];
      console.log("deviceId :>> ", deviceId);
      var applyBlueprintResponse = await applyBlueprint(newBlueprint, deviceId);
      console.log(
        "applyBlueprintResponse.head.status :>> ",
        applyBlueprintResponse.head.status
      );

      if (applyBlueprintResponse.head.status === 200) {
        // update firestore with new version of blueprint
        deviceData["body"]["blueprintId"] = {
          id: newBlueprint["id"],
          version: newBlueprint["version"],
        };

        deviceData["body"]["localVersions"]["blueprintId"] = newBlueprint["id"];
        deviceData["body"]["localVersions"]["blueprintVersion"] =
          newBlueprint["version"];

        await db.collection("devices").doc(`${imei}`).update(deviceData);
      }
    }
  });

function updateBlueprint(messagesPerHour, blueprintId) {
  var period = parseInt(`${3600 / messagesPerHour}`, 10);
  console.log("period :>> ", period);

  return new Promise((resolve, reject) => {
    const updateBlueprintOptions = {
      hostname: "octave-api.sierrawireless.io",
      path: `/v5.0/capstone_uop2021/blueprint/${blueprintId}`,
      method: "PUT",
      headers: {
        "X-Auth-Token": functions.config().octave.auth_token,
        "X-Auth-User": functions.config().octave.auth_user,
      },
    };

    var body = {
      observations: {
        "/environment/value": {
          co2e: {
            period: period,
            select: "co2EquivalentValue",
            function: null,
            destination: "cloudInterface",
            gte: null,
            step: null,
            buffer: null,
            lte: null,
          },
          iaq: {
            period: period,
            select: "iaqValue",
            function: null,
            destination: "cloudInterface",
            gte: null,
            step: null,
            buffer: null,
            lte: null,
          },
          temperature: {
            period: period,
            select: "temperature",
            function: null,
            destination: "cloudInterface",
            gte: null,
            step: null,
            buffer: null,
            lte: null,
          },
          breath_voc: {
            period: period,
            select: "breathVocValue",
            function: null,
            destination: "cloudInterface",
            gte: null,
            step: null,
            buffer: null,
            lte: null,
          },
          humidity: {
            period: period,
            select: "humidity",
            function: null,
            destination: "cloudInterface",
            gte: null,
            step: null,
            buffer: null,
            lte: null,
          },
          pressure: {
            period: period,
            select: "pressure",
            function: null,
            destination: "cloudInterface",
            gte: null,
            step: null,
            buffer: null,
            lte: null,
          },
        },
        "/location/coordinates/value": {
          coordinates: {
            period: period,
            select: null,
            function: null,
            destination: "cloudInterface",
            gte: null,
            step: null,
            buffer: null,
            lte: null,
          },
        },
        "/orp/asset/vps_shot": {
          vps_shot: {
            period: null,
            function: null,
            destination: "cloudInterface",
            gte: null,
            step: 1,
            buffer: null,
            lte: null,
          },
        },
      },
      state: {
        "/imu/temp/enable": true,
        "/location/coordinates/period": 10,
        "/imu/gyro/period": 10,
        "/io/config": {
          devs: [
            {
              conf: [
                {
                  baud: "9600",
                  routing: "IOT0",
                  wire: "2",
                  stop: "1",
                  own: "orp",
                  bits: 8,
                  type: "UART1",
                  pair: "N",
                  flow: "N",
                },
              ],
              type: "serial",
            },
          ],
        },
        "/cloudInterface/developer_mode/close_on_inactivity": false,
        "/imu/accel/enable": true,
        "/imu/temp/period": 10,
        "/imu/gyro/enable": true,
        "/environment/lowPower": false,
        "/environment/enable": true,
        "/location/coordinates/enable": true,
        "/cloudInterface/developer_mode/enable": true,
        "/imu/accel/period": 10,
        "/environment/ambientAirTemp": 25,
      },
    };

    var req = https.request(updateBlueprintOptions, (res) => {
      res.setEncoding("utf8");
      var response = "";

      res.on("data", (d) => {
        response += d;
      });

      res.on("end", () => {
        var jsonResponse = JSON.parse(response);

        if (jsonResponse.head.status === 200) {
          var result = {
            id: jsonResponse.body.id,
            displayName: jsonResponse.body.displayName,
            version: jsonResponse.body.version,
          };
          resolve(result);
        } else {
          reject(jsonResponse);
        }
      });
    });

    req.on("error", (err) => reject(err));
    req.write(JSON.stringify(body));
    req.end();
  });
}
