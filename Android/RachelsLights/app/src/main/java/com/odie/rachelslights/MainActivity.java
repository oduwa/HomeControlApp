package com.odie.rachelslights;

import android.Manifest;
import android.annotation.TargetApi;
import android.app.Activity;
import android.app.ProgressDialog;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothGatt;
import android.bluetooth.BluetoothGattCallback;
import android.bluetooth.BluetoothGattCharacteristic;
import android.bluetooth.BluetoothGattService;
import android.bluetooth.BluetoothManager;
import android.bluetooth.BluetoothProfile;
import android.bluetooth.le.BluetoothLeScanner;
import android.bluetooth.le.ScanCallback;
import android.bluetooth.le.ScanFilter;
import android.bluetooth.le.ScanResult;
import android.bluetooth.le.ScanSettings;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v4.app.ActivityCompat;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.View;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.AdapterView;
import android.widget.GridView;

import com.odie.rachelslights.colorbox.ColorBox;

import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;
import java.util.UUID;

public class MainActivity extends AppCompatActivity {

    public static final String TAG = MainActivity.class.getSimpleName();
    public static final ArrayList<BluetoothGattService> discovered_services = new ArrayList<>();

    private final String LIGHT_SERVICE_UUID = "ff51b30e-d7e2-4d93-8842-a7c4a57dfb07";
    private final String ADDRESS_CHARACTERISTIC_UUID = "ff51b30e-d7e2-4d93-8842-a7c4a57dfb09";
    private final String LIGHT_COMMAND_CHARACTERISTIC_UUID = "ff51b30e-d7e2-4d93-8842-a7c4a57dfb10";

    private BluetoothAdapter mBluetoothAdapter;
    private ArrayList<BluetoothDevice> mDevices;
    private boolean mScanning;
    private boolean mIsChoosingColor;
    private Handler mHandler;
    private BluetoothLeScanner mLEScanner;
    private ScanSettings settings;
    private List<ScanFilter> filters;
    private BluetoothGatt mGatt;

    private GridView mGridView;

    // Stops scanning after 10 seconds.
    private static final long SCAN_PERIOD = 10000;

    // Device scan callback.
    private BluetoothAdapter.LeScanCallback mLeScanCallback =
            new BluetoothAdapter.LeScanCallback() {
                @Override
                public void onLeScan(final BluetoothDevice device, int rssi,
                                     byte[] scanRecord) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            mDevices.add(device);
                        }
                    });
                }
            };

    private ScanCallback mScanCallback = new ScanCallback() {

        @Override
        public void onScanResult(int callbackType, ScanResult result) {
            Log.d("callbackType", String.valueOf(callbackType));
            Log.d("result", result.toString());
            BluetoothDevice btDevice = result.getDevice();
            if(result.getScanRecord().getDeviceName() != null && result.getScanRecord().getDeviceName().contains("HomeControl_Light")) {
                if(mDevices != null && !mDevices.contains(btDevice)){
                    mDevices.add(btDevice);
                }
            }
        }

        @Override
        public void onBatchScanResults(List<ScanResult> results) {
            for (ScanResult sr : results) {
                Log.d("ScanResult - Results", sr.toString());
            }
        }

        @Override
        public void onScanFailed(int errorCode) {
            Log.e("Scan Failed", "Error Code: " + errorCode);
        }
    };

    private final BluetoothGattCallback gattCallback = new BluetoothGattCallback() {
        @Override
        public void onConnectionStateChange(BluetoothGatt gatt, int status, int newState) {
            Log.i("onConnectionStateChange", "Status: " + status);
            switch (newState) {
                case BluetoothProfile.STATE_CONNECTED:
                    Log.i("gattCallback", "STATE_CONNECTED");
                    discovered_services.clear();
                    gatt.discoverServices();
                    break;
                case BluetoothProfile.STATE_DISCONNECTED:
                    discovered_services.clear();
                    Log.e("gattCallback", "STATE_DISCONNECTED");
                    break;
                default:
                    Log.e("gattCallback", "STATE_OTHER");
            }

        }

        @Override
        public void onServicesDiscovered(BluetoothGatt gatt, int status) {
            List<BluetoothGattService> services = gatt.getServices();
            discovered_services.addAll(services);
            Log.i("onServicesDiscovered", services.toString());
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        ActivityCompat.requestPermissions(this,
                new String[]{Manifest.permission.ACCESS_COARSE_LOCATION},
                1);

        mGridView = (GridView) findViewById(R.id.gridview);
        final Activity context = this;
        mGridView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                if(discovered_services.size() > 0){
                    ColorBox.showColorBox(TAG, context);
                    mIsChoosingColor = true;
                }
                else{
                    AlertDialog.Builder builder = new AlertDialog.Builder(context);
                    builder.setMessage("Hold up snugglepuss, your phone's not connected to the light yet. Maybe give it a couple more seconds.")
                            .setPositiveButton("OK", new DialogInterface.OnClickListener() {
                                public void onClick(DialogInterface dialog, int id) {
                                    // FIRE ZE MISSILES!
                                }
                            });
                    // Create the AlertDialog object and return it
                    builder.create().show();
                }
            }
        });

        /* FOR TEST PURPOSES ONLY */
        /*
        ArrayList x = new ArrayList();
        x.add("Test");
        mGridView.setAdapter(new DeviceListAdapter(this, x));
        */


        mHandler = new Handler();
        mDevices = new ArrayList<>();

        // Initializes Bluetooth adapter.
        final BluetoothManager bluetoothManager =
                (BluetoothManager) getSystemService(Context.BLUETOOTH_SERVICE);
        mBluetoothAdapter = bluetoothManager.getAdapter();

        // Check Bluetooth availabilty
        if (mBluetoothAdapter == null || !mBluetoothAdapter.isEnabled()) {
            // Show message
            Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
            startActivityForResult(enableBtIntent, 1);
        }
        else{
            mLEScanner = mBluetoothAdapter.getBluetoothLeScanner();
            settings = new ScanSettings.Builder()
                    .setScanMode(ScanSettings.SCAN_MODE_LOW_LATENCY)
                    .build();
            filters = new ArrayList<ScanFilter>();

            searchBLE();
        }

        FloatingActionButton myFab = (FloatingActionButton)  findViewById(R.id.fab);
        myFab.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                Intent emailIntent = new Intent(android.content.Intent.ACTION_SEND);
                emailIntent.setType("plain/text");
                String recepients[] = {"garyedoosagie@yahoo.com"};

                emailIntent.putExtra(android.content.Intent.EXTRA_EMAIL, recepients);
                emailIntent.putExtra(android.content.Intent.EXTRA_SUBJECT, "Something to say to Odie");
                startActivity(Intent.createChooser(emailIntent, "Send your email in:"));
            }
        });

    }

    @Override
    protected void onResume() {
        super.onResume();

        if(mIsChoosingColor) {
            int color = ColorBox.getColor(TAG, this);
            Log.d(TAG, "xxx." + colourEncodingForBTDevice(color));
            writeCharacteristic(colourEncodingForBTDevice(color));
            mIsChoosingColor = false;
        }

    }

    public String colourEncodingForBTDevice(int color){
        int A = (color >> 24) & 0xff;
        int R = (color >> 16) & 0xff;
        int G = (color >>  8) & 0xff;
        int B = (color      ) & 0xff;
        A = (int) ((A/255.0)*10);

        return String.format("%1$04d|%2$04d|%3$04d|%4$04d", R, G, B, A);
    }

    public void searchBLE(){
        final Context context = this;

        final ProgressDialog mDialog = new ProgressDialog(context);
        mDialog.setMessage("Looking for your light now snugglepuss :3...");
        mDialog.setCancelable(false);
        mDialog.show();

        if(mGatt != null){
            mGatt.disconnect();
        }

        // Handler to stop scanning after set period
        mHandler.postDelayed(new Runnable() {
            @Override
            public void run() {
                mScanning = false;
                mLEScanner.stopScan(mScanCallback);
                //mBluetoothAdapter.stopLeScan(mLeScanCallback);

                Log.d("MainActivity", mDevices.toString());

                mGridView.setAdapter(new DeviceListAdapter(context, getAdapterSourceFromDevices()));
                mDialog.dismiss();

                // Show message if no devices found
                if(mDevices.size() < 1){
                    AlertDialog.Builder builder = new AlertDialog.Builder(context);
                    builder.setMessage("Sorry bubs, no devices found. Maybe try turning the light on and waiting for like a minute")
                            .setPositiveButton("OK", new DialogInterface.OnClickListener() {
                                public void onClick(DialogInterface dialog, int id) {
                                    // FIRE ZE MISSILES!
                                }
                            });
                    // Create the AlertDialog object and return it
                    builder.create().show();
                }
                else{
                    // Connect to first discovered device
                    mGatt = mDevices.get(0).connectGatt(context, false, gattCallback);
                }
            }
        }, SCAN_PERIOD);

        mScanning = true;
        UUID[] uuidFilter = {UUID.fromString("ff51b30e-d7e2-4d93-8842-a7c4a57dfb07")};
        //mBluetoothAdapter.startLeScan(uuidFilter, mLeScanCallback);
        mLEScanner.startScan(mScanCallback);
    }

    public ArrayList<String> getAdapterSourceFromDevices(){
        ArrayList<String> result = new ArrayList<>();

        for(BluetoothDevice device : mDevices){
            result.add(device.getName());
        }

        return result;
    }

    public boolean writeCharacteristic(String msg){
        //check mBluetoothGatt is available
        if (mGatt == null) {
            Log.e(TAG, "Not connected to device");
            return false;
        }

        BluetoothGattService lightService = mGatt.getService(UUID.fromString(LIGHT_SERVICE_UUID));

        if (lightService == null) {
            Log.e(TAG, "Light service not found!");
            return false;
        }

        BluetoothGattCharacteristic characteristic = lightService.getCharacteristic(UUID.fromString(LIGHT_COMMAND_CHARACTERISTIC_UUID));
        if (characteristic == null) {
            Log.e(TAG, "Write characteristic not found!");
            return false;
        }

        byte[] bMsg = msg.getBytes(Charset.forName("UTF-8"));
        characteristic.setValue(bMsg);
        mGatt.writeCharacteristic(characteristic);

        return true;
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_scan) {
            if(!mScanning){
                searchBLE();
            }
            return true;
        }

        return super.onOptionsItemSelected(item);
    }
}
