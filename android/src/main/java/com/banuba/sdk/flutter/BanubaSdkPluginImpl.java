package com.banuba.sdk.flutter;

import static java.util.Objects.requireNonNull;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;
import android.util.Log;
import android.view.SurfaceView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;

import com.banuba.android.sdk.ext.agora.BanubaExtensionManager;
import com.banuba.sdk.effect_player.Effect;
import com.banuba.sdk.manager.BanubaSdkManager;
import com.banuba.sdk.manager.BanubaSdkTouchListener;

import java.util.List;

import io.agora.rtc2.RtcEngine;
import io.flutter.plugin.common.PluginRegistry.RequestPermissionsResultListener;

public class BanubaSdkPluginImpl {
    private static final String TAG = "BanubaSdkPlugin";

    public static class BanubaSdkManagerIml implements BanubaSdkPluginGen.BanubaSdkManager, RequestPermissionsResultListener {
        private static final int REQUEST_CODE_PERMISSION = 20001;
        private final Context mContext;
        private @Nullable Activity mActivity;
        private BanubaSdkManager mSdkManager;

        public BanubaSdkManagerIml(@NonNull Context context) {
            mContext = context;
        }

        public void setActivity(Activity activity) {
            mActivity = activity;
        }

        @Override
        public void initialize(@NonNull List<String> resourcePath, @NonNull String clientTokenString, @NonNull BanubaSdkPluginGen.SeverityLevel logLevel) {
            BanubaSdkManager.initialize(
                mContext.getApplicationContext(),
                clientTokenString,
                resourcePath.toArray(new String[] {})
            );
        }

        @Override
        public void initializeExtension(
                @NonNull io.agora.rtc2.RtcEngine resourcePath,
                @NonNull String clientTokenString,
                @NonNull BanubaSdkPluginGen.SeverityLevel logLevel
        ) {
            BanubaExtensionManager.INSTANCE.
        initialize(
                     mContext.getApplicationContext(),
                     clientTokenString,
                    resourcePath
            );

            Log.e(TAG, "BanubaExtensionManager  initialized");

        }


        @Override
        public void deinitialize() {
            BanubaSdkManager.deinitialize();
        }

        @SuppressLint("ClickableViewAccessibility")
        @Override
        public void attachWidget(@NonNull Long banubaId) {
            SurfaceView effectPlayerView = EffectPlayerView.NativeViewFactory.getEffectPlayerView(banubaId.intValue());
            effectPlayerView.setOnTouchListener(
                new BanubaSdkTouchListener(
                    mContext.getApplicationContext(),
                    getSdkManager().getEffectPlayer()
                )
            );
            getSdkManager().attachSurface(effectPlayerView);

            getSdkManager().onSurfaceCreated();
            getSdkManager().onSurfaceChanged(0, effectPlayerView.getWidth(), effectPlayerView.getHeight());
        }

        @Override
        public void openCamera() {
            if (!isCameraPermissionGranted()) {
                requestPermission();
            } else {
                getSdkManager().openCamera();
            }
        }

        @Override
        public void startPlayer() {
            BanubaExtensionManager.INSTANCE.resume();
            getSdkManager().effectPlayerPlay();
        }

        @Override
        public void stopPlayer() {

            BanubaExtensionManager.INSTANCE.pause();
            getSdkManager().effectPlayerPause();
        }

        @Override
        public void loadEffect(@NonNull String path) {

            BanubaExtensionManager.INSTANCE.loadEffectFromAssets(path);

            getSdkManager().loadEffect(path, true);
        }

        @Override
        public void evalJs(@NonNull String script) {
            Effect current = getSdkManager().getEffectManager().current();
            if (current != null) {
                current.evalJs(script, null);
            }
        }

        private BanubaSdkManager getSdkManager() {
            if (mSdkManager == null) {
                mSdkManager = new BanubaSdkManager(mContext.getApplicationContext());
            }
            return mSdkManager;
        }

        private void requestPermission() {
            if (!isCameraPermissionGranted()) {
                String[] permissionsList = new String[] {Manifest.permission.CAMERA};

                ActivityCompat.requestPermissions(
                    requireNonNull(mActivity), permissionsList, REQUEST_CODE_PERMISSION
                );
            }
        }

        private boolean isCameraPermissionGranted() {
            if (Build.VERSION.SDK_INT >= 23) {
                return mContext.checkSelfPermission(Manifest.permission.CAMERA)
                    == PackageManager.PERMISSION_GRANTED;
            } else {
                return true;
            }
        }

        @Override
        public boolean onRequestPermissionsResult(
            int requestCode,
            @NonNull String[] permissions,
            @NonNull int[] grantResults
        ) {
            if (requestCode == REQUEST_CODE_PERMISSION) {
                if (isCameraPermissionGranted()) {
                    mSdkManager.openCamera();
                } else {
                    Log.e(TAG, "App has no camera permissions");
                }
                return true;
            }
            return false;
        }
    }
}
