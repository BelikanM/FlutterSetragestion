require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const validator = require('validator');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const http = require('http');
const nodemailer = require('nodemailer');

const app = express();
app.use(cors());
app.use(express.json());

// =========================
// MongoDB
// =========================
mongoose.connect(process.env.MONGO_URI, {})
  .then(() => console.log('✅ MongoDB connecté'))
  .catch(err => console.error('❌ Erreur MongoDB:', err));

// =========================
// User Schema avec OTP
// =========================
const userSchema = new mongoose.Schema({
  email: { type: String, required: true, unique: true, trim: true, lowercase: true, validate: [validator.isEmail, 'Email invalide'] },
  password: { type: String, required: true, minlength: 6 },
  isVerified: { type: Boolean, default: false },
  otp: { type: String },
  otpExpires: { type: Date },
  createdAt: { type: Date, default: Date.now },
});

userSchema.pre('save', async function(next) {
  if (this.isModified('password')) this.password = await bcrypt.hash(this.password, 10);
  next();
});

const User = mongoose.model('User', userSchema);

// =========================
// Nodemailer setup
// =========================
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS,
  },
});

// =========================
// Routes Auth
// =========================

// Générer OTP
function generateOTP() {
  return Math.floor(100000 + Math.random() * 900000).toString(); // 6 chiffres
}

// Inscription
app.post('/api/register', async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) return res.status(400).json({ success: false, message: 'Tous les champs sont requis' });

    const existingUser = await User.findOne({ email });
    if (existingUser) return res.status(400).json({ success: false, message: 'Email déjà utilisé' });

    const otp = generateOTP();
    const otpExpires = new Date(Date.now() + 10 * 60 * 1000); // expire dans 10 min

    const user = new User({ email, password, otp, otpExpires });
    await user.save();

    // Envoi email
    await transporter.sendMail({
      from: process.env.EMAIL_USER,
      to: email,
      subject: 'Votre code OTP',
      text: `Votre code de vérification est : ${otp}`,
    });

    res.status(201).json({ success: true, message: 'Inscription réussie. Vérifiez votre email pour l’OTP.' });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Erreur serveur', error: error.message });
  }
});

// Vérification OTP
app.post('/api/verify-otp', async (req, res) => {
  try {
    const { email, otp } = req.body;
    if (!email || !otp) return res.status(400).json({ success: false, message: 'Email et OTP requis' });

    const user = await User.findOne({ email });
    if (!user) return res.status(400).json({ success: false, message: 'Utilisateur non trouvé' });

    if (user.isVerified) return res.status(400).json({ success: false, message: 'Utilisateur déjà vérifié' });
    if (user.otp !== otp) return res.status(400).json({ success: false, message: 'OTP incorrect' });
    if (user.otpExpires < new Date()) return res.status(400).json({ success: false, message: 'OTP expiré' });

    user.isVerified = true;
    user.otp = null;
    user.otpExpires = null;
    await user.save();

    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: '7d' });
    res.status(200).json({ success: true, message: 'Compte vérifié', token });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Erreur serveur', error: error.message });
  }
});

// Login
app.post('/api/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) return res.status(400).json({ success: false, message: 'Tous les champs sont requis' });

    const user = await User.findOne({ email });
    if (!user) return res.status(400).json({ success: false, message: 'Email ou mot de passe incorrect' });
    if (!user.isVerified) return res.status(400).json({ success: false, message: 'Compte non vérifié. Vérifiez votre email.' });

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) return res.status(400).json({ success: false, message: 'Email ou mot de passe incorrect' });

    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, { expiresIn: '7d' });
    res.status(200).json({ success: true, token });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Erreur serveur', error: error.message });
  }
});

// =========================
// Server start
// =========================
const server = http.createServer(app);
const { Server } = require('socket.io');
const io = new Server(server, { cors: { origin: '*', methods: ['GET','POST'] } });

io.on('connection', (socket) => {
  console.log('✅ Client Socket.IO connecté');
  socket.on('message', (msg) => io.emit('message', `Serveur: ${msg}`));
  socket.on('disconnect', () => console.log('❌ Client Socket.IO déconnecté'));
});

const PORT = process.env.PORT || 5000;
server.listen(PORT, () => console.log(`🚀 Serveur lancé sur le port ${PORT}`));
