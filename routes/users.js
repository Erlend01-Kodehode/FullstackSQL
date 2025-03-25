import express from "express";
import { register } from "../controllers/registerController.js";
import { login } from "../controllers/loginController.js";
var router = express.Router();

/* GET users listing. */
router.post("/create/", register);
router.post("/login/", login);

export default router;
