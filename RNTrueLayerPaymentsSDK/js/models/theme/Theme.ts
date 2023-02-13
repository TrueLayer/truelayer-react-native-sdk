import { AndroidColors } from "./AndroidColors";
import { AndroidTypography } from "./AndroidTypography";
import { iOSColors } from "./iOSColors";

export type Theme = {
  android?: {
    lightColors?: AndroidColors;
    darkColors?: AndroidColors;
    typography?: AndroidTypography;
  }
  ios?: {
    lightColors?: iOSColors;
    darkColors?: iOSColors;
  }
};
