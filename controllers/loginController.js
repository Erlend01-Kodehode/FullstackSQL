import { loginUser } from "./loginUser.js";

export const login = async (req, res, next) => {
  const { username, password } = req.body;

  try {
    await loginUser(username, password);
    res.status(200).json({ message: "Logged in successfully" });
  } catch (e) {
    next(new Error(e.message));
  }
};
