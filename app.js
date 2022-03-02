const { getRandomName } = require("./fn/randomName");
const host = "0.0.0.0";
const port = 3000;

require("http")
  .createServer((req, res) => {
    res.setHeader("Content-Type", "text/html");
    res.setHeader("Env", `node-${process.env.NODE_VERSION}`);
    res.writeHead(200);
    if (req.url == "/version") res.end(process.env.COMMIT);
    else res.end(getRandomName());
  })
  .listen(port, host, () => {
    console.log(`Server is running on http://${host}:${port}`);
  });
