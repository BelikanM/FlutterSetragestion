import os

backend_path = "backend"

backend_structure = {
    "server.js": """require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

// Routes
const employeeRoutes = require('./routes/employees');
const authRoutes = require('./routes/auth');
app.use('/employees', employeeRoutes);
app.use('/auth', authRoutes);

// Connect MongoDB
mongoose.connect(process.env.MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true })
.then(() => console.log('✅ MongoDB connecté'))
.catch(err => console.error('❌ Erreur MongoDB:', err));

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`🚀 Serveur lancé sur le port ${PORT}`));
""",
    ".env": """PORT=5000
MONGO_USER=SETRAF
MONGO_PASSWORD=Dieu19961991??!??!
MONGO_CLUSTER=cluster0.5tjz9v0.mongodb.net
MONGO_DB_NAME=myDatabase3
MONGO_URI=mongodb+srv://SETRAF:Dieu19961991%3F%3F%21%3F%3F%21@cluster0.5tjz9v0.mongodb.net/myDatabase3?retryWrites=true&w=majority&appName=Cluster0
JWT_SECRET=Dieu19961991??!??!
JWT_REFRESH_SECRET=Dieu19961991??!??!_refresh
EMAIL_USER=nyundumathryme@gmail.com
EMAIL_PASS=zsrrymlixizhiybl
PUBLIC_KEY=qazghazz
PRIVATE_KEY=264419a2-cd4e-471a-81b3-04c522669052
""",
    "models": {
        "Employee.js": """const mongoose = require('mongoose');

const employeeSchema = new mongoose.Schema({
    name: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    position: { type: String, required: true },
    createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Employee', employeeSchema);
""",
        "User.js": """const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    role: { type: String, default: 'user' },
    createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('User', userSchema);
"""
    },
    "routes": {
        "employees.js": """const express = require('express');
const router = express.Router();
const Employee = require('../models/Employee');

// GET all employees
router.get('/', async (req, res) => {
    try {
        const employees = await Employee.find();
        res.json(employees);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

// GET one employee
router.get('/:id', async (req, res) => {
    try {
        const employee = await Employee.findById(req.params.id);
        if (!employee) return res.status(404).json({ message: 'Not found' });
        res.json(employee);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

// POST create employee
router.post('/', async (req, res) => {
    const { name, email, position } = req.body;
    const employee = new Employee({ name, email, position });
    try {
        const newEmployee = await employee.save();
        res.status(201).json(newEmployee);
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
});

// PUT update employee
router.put('/:id', async (req, res) => {
    try {
        const employee = await Employee.findById(req.params.id);
        if (!employee) return res.status(404).json({ message: 'Not found' });

        employee.name = req.body.name || employee.name;
        employee.email = req.body.email || employee.email;
        employee.position = req.body.position || employee.position;

        const updated = await employee.save();
        res.json(updated);
    } catch (err) {
        res.status(400).json({ message: err.message });
    }
});

// DELETE employee
router.delete('/:id', async (req, res) => {
    try {
        const employee = await Employee.findById(req.params.id);
        if (!employee) return res.status(404).json({ message: 'Not found' });
        await employee.remove();
        res.json({ message: 'Deleted' });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
});

module.exports = router;
""",
        "auth.js": """const express = require('express');
const router = express.Router();
const jwt = require('jsonwebtoken');

// TODO: remplacer par logique réelle et bcrypt pour le mot de passe
router.post('/login', (req, res) => {
    const { email } = req.body;
    // Création d'un token JWT fictif
    const token = jwt.sign({ email }, process.env.JWT_SECRET, { expiresIn: '1h' });
    res.json({ token });
});

module.exports = router;
"""
    },
    "controllers": {}
}

def create_structure(base_path, struct):
    os.makedirs(base_path, exist_ok=True)
    for name, content in struct.items():
        path = os.path.join(base_path, name)
        if isinstance(content, dict):
            os.makedirs(path, exist_ok=True)
            create_structure(path, content)
        else:
            if not os.path.exists(path):
                with open(path, 'w', encoding='utf-8') as f:
                    f.write(content)
                print(f"Fichier créé : {path}")
            else:
                print(f"Fichier déjà existant : {path}")

# Exécution
create_structure(backend_path, backend_structure)
print("\n✅ Backend Node.js complet créé avec succès !")
