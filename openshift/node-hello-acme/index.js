const http = require("node:http");

const port = Number(process.env.PORT) || 8080;

const server = http.createServer((request, response) => {
  if (request.url === "/healthz") {
    response.writeHead(200, { "Content-Type": "text/plain" });
    response.end("ok\n");
    return;
  }

  response.writeHead(200, { "Content-Type": "text/html; charset=utf-8" });
  response.end(`<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Hello Acme</title>
  </head>
  <body>
    <main>
      <h1>Hello Acme!</h1>
      <p>Your Node.js application is running on OpenShift.</p>
    </main>
  </body>
</html>
`);
});

server.listen(port, "0.0.0.0", () => {
  console.log(`Server listening on port ${port}`);
});
