const functions = require("firebase-functions");
const axios = require("axios");
const admin = require("firebase-admin");

admin.initializeApp();

exports.yourFunction = functions.https.onRequest(
    async (req, res) => {
      const {headers} = req;

      try {
        const result = await axios.post(
            "https://your-api-endpoint",
            {data: req.body},
            {headers: {Authorization: headers.authorization}},
        );

        res.send(result.data);
      } catch (error) {
        res.status(500).send(error.message);
      }
    },
);
