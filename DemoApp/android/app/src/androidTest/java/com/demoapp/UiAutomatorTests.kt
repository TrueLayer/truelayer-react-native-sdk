package com.demoapp

import android.content.Context
import android.content.Intent
import androidx.test.core.app.ApplicationProvider
import androidx.test.filters.SdkSuppress
import androidx.test.platform.app.InstrumentationRegistry
import androidx.test.uiautomator.By
import androidx.test.uiautomator.UiDevice
import androidx.test.uiautomator.Until
import org.junit.Assert
import org.junit.Before
import org.junit.Test

private const val BASIC_SAMPLE_PACKAGE = "com.demoapp"
private const val LAUNCH_TIMEOUT = 5000

@SdkSuppress(minSdkVersion = 18)
class UiAutomatorTests {

    private lateinit var device: UiDevice

    @Before
    fun startMainActivityFromHomeScreen() {
        // Initialize UiDevice instance
        device = UiDevice.getInstance(InstrumentationRegistry.getInstrumentation())

        // Start from the home screen
        device.pressHome()

        // Wait for launcher
        val launcherPackage = device.launcherPackageName
        Assert.assertNotNull(launcherPackage)
        device.wait(
            Until.hasObject(By.pkg(launcherPackage).depth(0)),
            LAUNCH_TIMEOUT.toLong()
        )

        // Launch the app
        val context = ApplicationProvider.getApplicationContext<Context>()
        val intent = context.packageManager.getLaunchIntentForPackage(BASIC_SAMPLE_PACKAGE)

        // Clear out any previous instances
        intent!!.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK)
        context.startActivity(intent)

        // Wait for the app to appear
        device.wait(
            Until.hasObject(By.pkg(BASIC_SAMPLE_PACKAGE).depth(0)),
            LAUNCH_TIMEOUT.toLong()
        )
    }

    @Test
    fun checkSDKStarts() {
        Assert.assertNotNull(device)

        device.wait(
            Until.hasObject(By.descContains("Start SDK")),
            10000L
        )

        val okButton = device.findObject(
            By.descContains("Start SDK")
        )
        Assert.assertNotNull(okButton)
        okButton.click()

        val processButton = device.findObject(
            By.descContains("Process Single Payment")
        )
        Assert.assertNotNull(processButton)
        processButton.click()

        device.wait(
            Until.hasObject(By.text("Mock UK")),
            10000L
        )

        val bankSelectionHeader = device.findObject(
            By.textContains("Mock UK")
        )

        Assert.assertNotNull(bankSelectionHeader)
    }

}
