import { signupUser } from "./signupUser.js";

export const register = async (req, res, next) => {
  const { username, email, password } = req.body;

  try {
    await signupUser(username, email, password);
    res.status(201).json({ message: "User Created Successfully" });
  } catch (e) {
    next(new Error(e.message));
  }
};
