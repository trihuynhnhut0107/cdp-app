// /src/utils/socket.io.js
let ioInstance;

function initSocketIO(server) {
  const { Server } = require("socket.io");
  const io = new Server(server, {
    cors: {
      origin: "*", // or your Flutter client domain
    },
  });

  io.on("connection", (socket) => {
    console.log("Client connected", socket.id);
    const userId = socket.handshake.query.user_id;
    if (userId) {
      socket.join(userId); // So you can send messages to this user
    }

    socket.on("disconnect", () => {
      console.log("Client disconnected", socket.id);
    });
  });

  ioInstance = io;
}

function getSocketIO() {
  if (!ioInstance) {
    throw new Error("Socket.IO not initialized!");
  }
  return ioInstance;
}

module.exports = { initSocketIO, getSocketIO };
