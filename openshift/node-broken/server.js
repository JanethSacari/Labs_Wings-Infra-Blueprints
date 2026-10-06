const http = require("node:http");

const port = Number(process.env.PORT) || 8080;

const server = http.createServer((request, response) => {
  if (request.url === "/healthz") {
    response.writeHead(200, { "Content-Type": "text/plain" });
    response.end("ok\n");
    return;
  }

  response.writeHead(200, { "Content-Type": "application/json" });
  response.end(
    JSON.stringify({
      app: "node-broken",
      message: "Node.js application is running",
    }) + "\n",
  );
});

// Intentional failure: the process listens only on the container loopback.
server.listen(port, "127.0.0.1", () => {
  console.log(`Server listening at http://127.0.0.1:${port}`);
});
