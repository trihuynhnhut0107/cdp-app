require("dotenv").config();
const { connect } = require("pm2");
const app = require("./src/app");
require("./src/models/index");
const { initSocketIO } = require("./src/utils/socket.io");
const http = require("http");
const { sequelize, connectDB } = require("./src/config/sequelize.config");

const server = http.createServer(app);
initSocketIO(server);

const PORT = process.env.PORT || 8000;

server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
connectDB();

// Graceful shutdown function
function gracefulShutdown() {
  console.log("Received shutdown signal, shutting down gracefully...");
  server.close(() => {
    console.log("Closed out remaining connections");
    process.exit(0); // Exit the process once all connections are closed
  });

  // If connections don't close within 10 seconds, force close
  setTimeout(() => {
    console.error(
      "Could not close connections in time, forcefully shutting down"
    );
    process.exit(1); // Forcefully exit if it takes too long
  }, 10000);
}

// Catch `Ctrl + C` (SIGINT)
process.on("SIGINT", gracefulShutdown);

// Catch SIGTERM (when a termination signal is sent to the process, like when deployed in the cloud)
process.on("SIGTERM", gracefulShutdown);
