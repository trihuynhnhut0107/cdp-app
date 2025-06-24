const express = require("express");
const compression = require("compression");
const { default: helmet } = require("helmet");
const morgan = require("morgan");

const app = express();

app.use(morgan("dev"));
app.use(helmet());
app.use(compression());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use("/", require("./routes"));

app.use((err, req, res, next) => {
  console.error(err); // Log the error for debugging

  res.status(err.status || 500).json({
    success: false,
    error: err.message || "Internal Server Error",
  });
});

module.exports = app;
