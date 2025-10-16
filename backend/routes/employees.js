const express = require('express');
const router = express.Router();
const Employee = require('../models/Employee');

// =========================
// GET: Récupérer tous les employés
// =========================
router.get('/', async (req, res) => {
  try {
    const employees = await Employee.find().sort({ createdAt: -1 });
    res.status(200).json(employees);
  } catch (error) {
    console.error('Erreur récupération employés :', error);
    res.status(500).json({ message: 'Erreur serveur lors de la récupération des employés', error: error.message });
  }
});

// =========================
// GET: Récupérer un employé par ID
// =========================
router.get('/:id', async (req, res) => {
  try {
    const employee = await Employee.findById(req.params.id);
    if (!employee) return res.status(404).json({ message: 'Employé non trouvé' });
    res.status(200).json(employee);
  } catch (error) {
    console.error('Erreur récupération employé :', error);
    res.status(500).json({ message: 'Erreur serveur lors de la récupération de l\'employé', error: error.message });
  }
});

// =========================
// POST: Ajouter un nouvel employé
// =========================
router.post('/', async (req, res) => {
  try {
    const { firstName, lastName, email, position, salary, certificates, identification } = req.body;

    // Validation manuelle des champs requis
    if (!firstName || !lastName || !email || !position || !salary || !identification) {
      return res.status(400).json({ message: 'Tous les champs requis doivent être remplis' });
    }

    const employee = new Employee({
      firstName,
      lastName,
      email,
      position,
      salary,
      certificates,
      identification,
    });

    const savedEmployee = await employee.save();
    res.status(201).json(savedEmployee);
  } catch (error) {
    console.error('Erreur ajout employé :', error);
    if (error.code === 11000) {
      // Erreur de duplication (email ou numéro unique)
      return res.status(400).json({ message: 'Email ou numéro de document déjà utilisé' });
    }
    res.status(500).json({ message: 'Erreur serveur lors de l\'ajout de l\'employé', error: error.message });
  }
});

// =========================
// PUT: Modifier un employé
// =========================
router.put('/:id', async (req, res) => {
  try {
    const updatedEmployee = await Employee.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    });
    if (!updatedEmployee) return res.status(404).json({ message: 'Employé non trouvé' });
    res.status(200).json(updatedEmployee);
  } catch (error) {
    console.error('Erreur mise à jour employé :', error);
    res.status(500).json({ message: 'Erreur serveur lors de la mise à jour de l\'employé', error: error.message });
  }
});

// =========================
// DELETE: Supprimer un employé
// =========================
router.delete('/:id', async (req, res) => {
  try {
    const deletedEmployee = await Employee.findByIdAndDelete(req.params.id);
    if (!deletedEmployee) return res.status(404).json({ message: 'Employé non trouvé' });
    res.status(200).json({ message: 'Employé supprimé avec succès' });
  } catch (error) {
    console.error('Erreur suppression employé :', error);
    res.status(500).json({ message: 'Erreur serveur lors de la suppression de l\'employé', error: error.message });
  }
});

module.exports = router;
