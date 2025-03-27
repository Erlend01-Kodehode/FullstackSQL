import { editUser } from "./editUser.js";

export const edit = async (req, res, next) => {
  const { username, email, password, newPassword } = req.body;

  try {
    await editUser(username, email, password, newPassword);
    res.status(200).json({ message: "Edited User successfully" });
  } catch (e) {
    next(new Error(e.message));
  }
};
