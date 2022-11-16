import type { TurboModule } from 'react-native/Libraries/TurboModule/RCTExport';
import { TurboModuleRegistry } from 'react-native';

export interface Spec extends TurboModule {
  configureSDK(): string;
}

export default TurboModuleRegistry.get<Spec>(
  'RTNTrueLayerPaymentsSDK'
) as Spec | null;