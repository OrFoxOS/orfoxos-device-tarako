package com.spreadtrum.android.eng;

import android.content.SharedPreferences;
import android.content.SharedPreferences.OnSharedPreferenceChangeListener;
import android.os.Bundle;
import android.os.SystemProperties;
import android.preference.CheckBoxPreference;
import android.preference.ListPreference;
import android.preference.Preference;
import android.preference.PreferenceActivity;
import android.preference.PreferenceManager;
import android.preference.PreferenceScreen;
import android.preference.Preference.OnPreferenceChangeListener;
import android.util.Log;
import android.widget.Toast;

import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.IOException;


public class LogSetting extends PreferenceActivity implements OnSharedPreferenceChangeListener {

    private static final String LOG_TAG = "LogSetting";

    private static final int LOG_APP   = 0;
    private static final int LOG_MODEM = 1;
    private static final int LOG_DSP   = 2;
    private static final int LOG_MODEM_ARM = 3;
    private static final int LOG_ANDROID = 4;
    /*Add 20130306 Spreadst of 121958  Add slog item start*/
    private static final int LOG_MODEM_SLOG = 5;
    /*Add 20130306 Spreadst of 121958  Add slog item end*/

    private static final String PROPERTY_LOGCAT = "persist.sys.logstate";
    private static final String KEY_ANDROID_LOG = "android_log_enable";
    private static final String KEY_DSP_LOG = "dsplog_enable";

    private CheckBoxPreference androidLogPrefs;
    private ListPreference DspPrefs;

    private int mSocketID = 0;
    private engfetch mEf;
    private String   mATline;
    private String   mATResponse;
    private ByteArrayOutputStream outputBuffer;
    private DataOutputStream outputBufferStream;

    private int oldDSPValue = 0;

	/** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        addPreferencesFromResource(R.layout.logsetting);

        Log.d(LOG_TAG, "logsetting activity onCreate.");
        androidLogPrefs = (CheckBoxPreference)findPreference(KEY_ANDROID_LOG);
        DspPrefs = (ListPreference)findPreference(KEY_DSP_LOG);
	/* initilize modem communication */
    	mEf = new engfetch();
    	mSocketID = mEf.engopen();

	mATline = new String();

	//register preference change listener
	SharedPreferences defaultPrefs = PreferenceManager.getDefaultSharedPreferences(this);
	defaultPrefs.registerOnSharedPreferenceChangeListener(this);
    }

    @Override
    protected void onStart() {
    Log.d(LOG_TAG, "logsetting activity onStart.");
        int androidLogState = LogSettingGetLogState(LOG_ANDROID);
        androidLogPrefs.setChecked(androidLogState == 1);
        oldDSPValue = LogSettingGetLogState(LOG_DSP);
        updataDSPOption(oldDSPValue);
        super.onStart();
    }

    private void updataDSPOption(int selectedId) {
        // TODO Auto-generated method stub
        Log.d(LOG_TAG, "updataDSPOption selectedId=["+selectedId+"]");
        DspPrefs.setValueIndex(selectedId);
        DspPrefs.setSummary(DspPrefs.getEntry());
    }

	/**  Activity stop */
    	@Override
	protected void onDestroy() {
		mEf.engclose(mSocketID);
		super.onDestroy();
		Log.d(LOG_TAG, "logsetting activity onDestroy.");
	}

    public boolean onPreferenceTreeClick(PreferenceScreen preferenceScreen, Preference preference) {
        String key = preference.getKey();
	Log.d(LOG_TAG, "[TreeCllik]onPreferenceTreeClick  key="+key);
        int logType = 0;

        if (key == null) {
            return false;
        }

        int newstate = 0;
        if(preference instanceof CheckBoxPreference){
            CheckBoxPreference CheckBox = (CheckBoxPreference) preference;
            newstate = CheckBox.isChecked() ? 1 : 0;
        }else if(preference instanceof ListPreference){
            return false;
        }

        if (key.equals("applog_enable")) {
            logType = LOG_APP;
        } else if (key.equals("modemlog_enable")) {
            logType = LOG_MODEM;
        } else if("modem_arm_log".equals(key)){
            logType = LOG_MODEM_ARM;
        } else if("android_log_enable".equals(key)){
            logType = LOG_ANDROID;
        /*Add 20130306 Spreadst of 121958  Add slog item start*/
        } else if("modem_slog_enable".equals(key)){
            logType = LOG_MODEM_SLOG;
        /*Add 20130306 Spreadst of 121958  Add slog item end */
        } else {
            Log.e(LOG_TAG, "Unknown type!");
            return false;
        }

        int oldstate = LogSettingGetLogState(logType);
        if (oldstate < 0) {
            Log.d(LOG_TAG, "Invalid log state.");
            return false;
        }

        if (oldstate == newstate) {
            Toast.makeText(getApplicationContext(), "Replicated setting!", Toast.LENGTH_SHORT).show();
        } else {
            LogSettingSaveLogState(logType, newstate);

            String msg ;
            msg = String.format("Log state changed, new state:%d, old state:%d", newstate, oldstate);
            Log.d(LOG_TAG, msg);
        }

        return false;
    }

    private int LogSettingGetLogState(int logType) {
        int state = 1; // log enable default.

        switch (logType) {

            case LOG_APP:
                String property = new String();
                //property = System.getProperty(PROPERTY_LOGCAT);
                property = SystemProperties.get(PROPERTY_LOGCAT, "CCC");
                if (property != "CCC") {
                state = property.compareTo("disable");
                }
                else {
                Log.d(LOG_TAG, "logcat property no exist.");
                }
            break;

            case LOG_MODEM:
                {
                    outputBuffer = new ByteArrayOutputStream();
                    outputBufferStream = new DataOutputStream(outputBuffer);

                    try {

                    Log.e(LOG_TAG, "Engmode socket open, id:" + mSocketID);
                    mATline =String.format("%d,%d", engconstents.ENG_AT_GETARMLOG, 0);

                    outputBufferStream.writeBytes(mATline);
                    } catch (IOException e) {
                    Log.e(LOG_TAG, "writeBytes() error!");
                    return -1;
                    } catch (java.lang.NumberFormatException nfe) {
                    Log.e(LOG_TAG, "at command return error");
                    return -1;
                    }
                    mEf.engwrite(mSocketID,outputBuffer.toByteArray(),outputBuffer.toByteArray().length);

                    int dataSize = 128;
                    byte[] inputBytes = new byte[dataSize];

                    int showlen= mEf.engread(mSocketID, inputBytes, dataSize);
                    mATResponse =  new String(inputBytes, 0, showlen);
					try {
						state = Integer.parseInt(mATResponse);
					} catch (Exception e) {
						Log.e(LOG_TAG, "NumberFormatException! : mATResponse = "
								+ mATResponse);
						return -1;
					}
                    if (state > 1) state = -1;
                }
            break;

            case LOG_DSP:
                {
                    outputBuffer = new ByteArrayOutputStream();
                    outputBufferStream = new DataOutputStream(outputBuffer);

                    Log.e(LOG_TAG, "Engmode socket open, id:" + mSocketID);
                    mATline =String.format("%d,%d", engconstents.ENG_AT_GETDSPLOG, 0);

                    try {
                        outputBufferStream.writeBytes(mATline);
                    } catch (IOException e) {
                        Log.e(LOG_TAG, "writeBytes() error!");
                        return -1;
                    }
                    mEf.engwrite(mSocketID,outputBuffer.toByteArray(),outputBuffer.toByteArray().length);

                    int dataSize = 128;
                    byte[] inputBytes = new byte[dataSize];

                    int showlen= mEf.engread(mSocketID, inputBytes, dataSize);
                    mATResponse =  new String(inputBytes, 0, showlen);

                    state = Integer.parseInt(mATResponse);
                    if (state > 2 || state< 0)
		        state = 0;
                }
        break;

        case LOG_MODEM_ARM:
	{
            String re = SystemProperties.get("persist.sys.cardlog", "0");
            try {
                state = Integer.parseInt(re);
            } catch (Exception e) {
                state = 0;
            }
        }
        break;

        case LOG_ANDROID:
	{
            String re = SystemProperties.get("init.svc.logs4android","");
            state = "running".equals(re)?1:0;
        }
        break;
        /*Add 20130306 Spreadst of 121958  Add slog item start*/
        case LOG_MODEM_SLOG: {
            String re = SystemProperties.get("persist.sys.modem_slog", "0");
            try {
                state = Integer.parseInt(re);
            }catch(Exception e){
                state =0;
            }
            break ;
        }
        /*Add 20130306 Spreadst of 121958  Add slog item end*/
        default:
            break;
        }

		return state;
	}

    private void LogSettingSaveLogState(int logType, int state) {
        switch (logType) {

            case LOG_APP:
            String property = (state == 1 ? "enable":"disable");

            SystemProperties.set(PROPERTY_LOGCAT, property);
            Log.d(LOG_TAG, "Set logcat property:" + property);
            break;

            case LOG_MODEM:
            {
                outputBuffer = new ByteArrayOutputStream();
                outputBufferStream = new DataOutputStream(outputBuffer);

                Log.e(LOG_TAG, "Engmode socket open, id:" + mSocketID);
                mATline =String.format("%d,%d,%d", engconstents.ENG_AT_SETARMLOG,1, state);

                try {
                    outputBufferStream.writeBytes(mATline);
                } catch (IOException e) {
                    Log.e(LOG_TAG, "writeBytes() error!");
                    return;
                }
                mEf.engwrite(mSocketID,outputBuffer.toByteArray(),outputBuffer.toByteArray().length);

                int dataSize = 128;
                byte[] inputBytes = new byte[dataSize];

                int showlen= mEf.engread(mSocketID, inputBytes, dataSize);
                mATResponse =  new String(inputBytes, 0, showlen);
                Log.d(LOG_TAG, "AT response:" + mATResponse);
                if (mATResponse.equals("OK"))
                    Toast.makeText(getApplicationContext(), "Success!",  Toast.LENGTH_SHORT).show();
                else
                    Toast.makeText(getApplicationContext(), "Fail!",  Toast.LENGTH_SHORT).show();
            }
            break;

            case LOG_DSP:
            {
                outputBuffer = new ByteArrayOutputStream();
                outputBufferStream = new DataOutputStream(outputBuffer);

                Log.e(LOG_TAG, "Engmode socket open, id:" + mSocketID);
                mATline =String.format("%d,%d,%d", engconstents.ENG_AT_SETDSPLOG,1, state);

                try {
                    outputBufferStream.writeBytes(mATline);
                } catch (IOException e) {
                    Log.e(LOG_TAG, "writeBytes() error!");
                    return;
                }
                mEf.engwrite(mSocketID,outputBuffer.toByteArray(),outputBuffer.toByteArray().length);

                int dataSize = 128;
                byte[] inputBytes = new byte[dataSize];

                int showlen= mEf.engread(mSocketID, inputBytes, dataSize);
                mATResponse =  new String(inputBytes, 0, showlen);
                Log.d(LOG_TAG, "AT response:" + mATResponse);

                if (mATResponse.equals("OK")){
                    Toast.makeText(getApplicationContext(), "Success!",  Toast.LENGTH_SHORT).show();
                    updataDSPOption(state);
                    oldDSPValue = state;
                }else{
                    Toast.makeText(getApplicationContext(), "Fail!",  Toast.LENGTH_SHORT).show();
                    updataDSPOption(oldDSPValue);
                }
            }
            break;

            case LOG_MODEM_ARM:
                SystemProperties.set("persist.sys.cardlog", state == 1 ? "1" : "0");
            break;

            case LOG_ANDROID:
                if(state == 1){
                    SystemProperties.set("ctl.start", "logs4android");
                }else {
                    SystemProperties.set("ctl.stop", "logs4android");
                }
            break;
            /*Add 20130306 Spreadst of 121958  Add slog item start*/
            case LOG_MODEM_SLOG: {
                SystemProperties.set("persist.sys.modem_slog",String.valueOf(state));
                outputBuffer = new ByteArrayOutputStream();
                outputBufferStream = new DataOutputStream(outputBuffer);
                Log.e(LOG_TAG, "Engmode socket open, id:" + mSocketID);

                if (state == 1) {
                    mATline = String.format("%d,%d,%s",engconstents.ENG_AT_NOHANDLE_CMD, 1, "AT+SLOG=2");
                }else {
                    mATline = String.format("%d,%d,%s",engconstents.ENG_AT_NOHANDLE_CMD, 1, "AT+SLOG=3");
                }
                Log.e(LOG_TAG, "cmd" + mATline);
                try{
                    outputBufferStream.writeBytes(mATline);
                }catch (IOException e) {
                    Log.e(LOG_TAG, "writeBytes() error!");
                    return ;
                }
                mEf.engwrite(mSocketID, outputBuffer.toByteArray(),
                        outputBuffer.toByteArray().length);

                int dataSize = 128;
                byte[] inputBytes = new byte[dataSize];
                int showlen = mEf.engread(mSocketID, inputBytes, dataSize);
                mATResponse = new String(inputBytes, 0, showlen);
                Log.d(LOG_TAG, "AT response:" + mATResponse);
                if (mATResponse.contains("OK")) {
                    Toast.makeText(getApplicationContext(), "Success!",
                            Toast.LENGTH_SHORT).show();
                }else {
                    Toast.makeText(getApplicationContext(), "Fail!",
                            Toast.LENGTH_SHORT).show();
                }
                break;
            }

            default:
            break;
        }
    }
    /*Add 20130306 Spreadst of 121958  Add slog item end*/
    @Override
    public void onSharedPreferenceChanged(SharedPreferences sharedPreferences, String key) {
        if(key.equals("modem_arm_log")){
            String re = sharedPreferences.getString(key, "");
            Log.d(LOG_TAG, "onSharedPreferenceChanged key="+key+" value="+re);
            LogSettingSaveLogState(LOG_MODEM_ARM,Integer.parseInt(re));
        }else if(key.equals(KEY_DSP_LOG)){
            String re = sharedPreferences.getString(key, "");
            Log.d(LOG_TAG, "onSharedPreferenceChanged key="+key+" value="+re);
            if(Integer.parseInt(re) != oldDSPValue)
            LogSettingSaveLogState(LOG_DSP,Integer.parseInt(re));
        }

    }

}
