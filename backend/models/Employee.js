const mongoose = require('mongoose');
const validator = require('validator');

const certificateSchema = new mongoose.Schema({
  name: {
    type: String,
    required: [true, 'Le nom du certificat est requis'],
    trim: true,
  },
  startDate: {
    type: Date,
    required: [true, 'La date de début du certificat est requise'],
  },
  endDate: {
    type: Date,
    required: [true, 'La date de fin du certificat est requise'],
    validate: {
      validator: function (value) {
        return value > this.startDate;
      },
      message: 'La date de fin doit être postérieure à la date de début',
    },
  },
  chronoTime: {
    type: Number,
    required: [true, 'La durée du certificat est requise'],
    min: [0, 'La durée ne peut pas être négative'],
  },
});

const identificationSchema = new mongoose.Schema({
  type: {
    type: String,
    enum: ['Carte d\'identité', 'NIP', 'Passeport'],
    required: [true, 'Le type de document est requis'],
  },
  number: {
    type: String,
    required: [true, 'Le numéro du document est requis'],
    unique: true,
    trim: true,
  },
});

const employeeSchema = new mongoose.Schema({
  firstName: {
    type: String,
    required: [true, 'Le prénom est requis'],
    trim: true,
    minlength: [2, 'Le prénom doit contenir au moins 2 caractères'],
  },
  lastName: {
    type: String,
    required: [true, 'Le nom est requis'],
    trim: true,
    minlength: [2, 'Le nom doit contenir au moins 2 caractères'],
  },
  email: {
    type: String,
    required: [true, 'L\'email est requis'],
    unique: true,
    trim: true,
    lowercase: true,
    validate: {
      validator: validator.isEmail,
      message: 'L\'email n\'est pas valide',
    },
  },
  position: {
    type: String,
    required: [true, 'Le poste est requis'],
    trim: true,
  },
  salary: {
    type: Number,
    required: [true, 'Le salaire est requis'],
    min: [0, 'Le salaire ne peut pas être négatif'],
  },
  certificates: [certificateSchema],
  identification: identificationSchema,
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model('Employee', employeeSchema);
