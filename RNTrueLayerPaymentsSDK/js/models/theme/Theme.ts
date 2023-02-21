import { AndroidColors } from "./AndroidColors";
import { AndroidTypography } from "./AndroidTypography";

export type Theme = {
  android?: {
    lightColors?: AndroidColors;
    darkColors?: AndroidColors;
    typography?: AndroidTypography;
  }
};
