const express = require("express");
const { getRandomName } = require("./fn/randomName");
const app = express();
const port = 3000;

app.get("/", (req, res) => {
  res.send({
    commitHash: process.env.COMMIT_SHORT_HASH,
    randomName: getRandomName(),
  });
});

app.listen(port, () => {
  console.log(`Listening on port ${port}`);
});
