const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.send('🚀 Hello from Node.js app deployed on EKS via Jenkins!');
});

app.listen(PORT, () => {
  console.log(`✅ App running on port ${PORT}`);
});

