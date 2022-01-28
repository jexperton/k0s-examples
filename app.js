const express = require("express");
const app = express();
const port = 3000;

app.get("/", (req, res) => {
  res.send({ COMMIT_SHORT_HASH: process.env.COMMIT_SHORT_HASH });
});

app.listen(port, () => {
  console.log(`Listening on port ${port}`);
});
