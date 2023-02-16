import { AndroidColors } from "./AndroidColors";
import { AndroidTypography } from "./AndroidTypography";
import { iOSColors } from "./iOSColors";

export type Theme = Partial<{
  android: {
    lightColors: AndroidColors;
    darkColors: AndroidColors;
    typography: AndroidTypography;
  }
  ios: Partial<{
    lightColors: iOSColors;
    darkColors: iOSColors;
  }>
}>;
