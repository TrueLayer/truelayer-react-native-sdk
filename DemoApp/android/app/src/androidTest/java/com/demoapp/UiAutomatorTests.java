package com.demoapp;

import static org.junit.Assert.assertNotNull;

import android.content.Context;
import android.content.Intent;

import androidx.test.core.app.ApplicationProvider;
import androidx.test.filters.SdkSuppress;
import androidx.test.platform.app.InstrumentationRegistry;
import androidx.test.runner.AndroidJUnit4;
import androidx.test.uiautomator.By;
import androidx.test.uiautomator.Condition;
import androidx.test.uiautomator.UiDevice;
import androidx.test.uiautomator.UiObject2;
import androidx.test.uiautomator.Until;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;


@RunWith(AndroidJUnit4.class)
@SdkSuppress(minSdkVersion = 18)
public class UiAutomatorTests {
    private static final String BASIC_SAMPLE_PACKAGE
            = "com.demoapp";
    private static final int LAUNCH_TIMEOUT = 5000;
    private static final String STRING_TO_BE_TYPED = "UiAutomator";
    private UiDevice device;

    @Before
    public void startMainActivityFromHomeScreen() {
        // Initialize UiDevice instance
        device = UiDevice.getInstance(InstrumentationRegistry.getInstrumentation());

        // Start from the home screen
        device.pressHome();

        // Wait for launcher
        final String launcherPackage = device.getLauncherPackageName();
        assertNotNull(launcherPackage);
        device.wait(Until.hasObject(By.pkg(launcherPackage).depth(0)),
                LAUNCH_TIMEOUT);

        // Launch the app
        Context context = ApplicationProvider.getApplicationContext();
        final Intent intent = context.getPackageManager()
                .getLaunchIntentForPackage(BASIC_SAMPLE_PACKAGE);
        // Clear out any previous instances
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
        context.startActivity(intent);

        // Wait for the app to appear
        device.wait(Until.hasObject(By.pkg(BASIC_SAMPLE_PACKAGE).depth(0)),
                LAUNCH_TIMEOUT);
    }

    @Test
    public void checkSDKStarts() {
        assertNotNull(device);

        device.wait(
                Until.hasObject(By.descContains("Start SDK")),
                10_000L
        );

        UiObject2 okButton = device.findObject(
                By.descContains("Start SDK")
        );
        assertNotNull(okButton);
        okButton.click();

        UiObject2 processButton = device.findObject(
                By.descContains("Process Single Payment")
        );
        assertNotNull(processButton);
        processButton.click();

        device.wait(
                Until.hasObject(By.text("Choose your bank")),
                10_000L
        );

        UiObject2 bankSelectionHeader = device.findObject(
                By.text("Choose your bank")
        );

        assertNotNull(bankSelectionHeader);
    }
}
