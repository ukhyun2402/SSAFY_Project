package com.ssafy.smartstore.activity

import android.Manifest
import android.app.*
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.location.Address
import android.location.Geocoder
import android.location.Location
import android.location.LocationManager
import android.nfc.NdefMessage
import android.nfc.NfcAdapter
import android.os.Build
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.os.RemoteException
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.widget.*
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import androidx.cardview.widget.CardView
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.bumptech.glide.Glide
import com.google.android.gms.tasks.OnCompleteListener
import com.google.android.material.bottomnavigation.BottomNavigationView
import com.google.firebase.messaging.FirebaseMessaging
import com.ssafy.smartstore.*
import com.ssafy.smartstore.R
import com.ssafy.smartstore.config.ApplicationClass
import com.ssafy.smartstore.dto.OrderDetail
import com.ssafy.smartstore.dto.ShoppingCart
import com.ssafy.smartstore.fragment.*
import com.ssafy.smartstore.response.LatestOrderResponse
import com.ssafy.smartstore.service.OrderService
import org.altbeacon.beacon.*
import retrofit2.Call
import retrofit2.Response
import java.io.IOException
import java.util.*
import kotlin.math.asin
import kotlin.math.cos
import kotlin.math.pow
import kotlin.math.sin

private const val TAG = "MainActivity_싸피"
class MainActivity : AppCompatActivity(), BeaconConsumer {
    private lateinit var bottomNavigation : BottomNavigationView

    // NFC
    var nfcAdapter: NfcAdapter? = null
    var pIntent: PendingIntent? = null
    lateinit var filters: Array<IntentFilter>
//    lateinit var orderTable : String
    var orderTable : String? = "x"

    // Beacon
    //beacon
    private lateinit var beaconManager: BeaconManager
    private val BEACON_UUID = "fda50693-a4e2-4fb1-afcf-c6eb07647825"
    private val BEACON_MAJOR = "10004"
    private val BEACON_MINOR = "54480"

    private val STORE_DISTANCE = 1
    //    private val region = Region("altbeacon",
//        Identifier.parse(BEACON_UUID),
//        Identifier.parse(BEACON_MAJOR),
//        Identifier.parse(BEACON_MINOR))
    private val region = Region("altbeacon", null, null, null)

    private lateinit var bluetoothManager: BluetoothManager
    private var bluetoothAdapter: BluetoothAdapter? = null
    private var needBLERequest = true

    private val PERMISSIONS_CODE = 100
    private var isDialogCalled = false


    // lastorder
    private var lastOrder : LatestOrderResponse? = null
    private var isLastOrderLoaded = false

    // dialog
    private lateinit var dialog : Dialog

    // 모든 퍼미션 관련 배열
    private val requiredPermissions = arrayOf(
        Manifest.permission.ACCESS_FINE_LOCATION,
    )

    val shoppingList = mutableListOf<ShoppingCart>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        dialog = Dialog(this)

        setNdef()

        setBeacon()

        checkPermissions()

        createNotificationChannel("ssafy_channel", "ssafy")
        orderTable?.let { ApplicationClass.sharedPreferencesUtil.addOrderTable(it) }
//        startScan()

        // 가장 첫 화면은 홈 화면의 Fragment로 지정
        supportFragmentManager.beginTransaction()
            .replace(R.id.frame_layout_main, HomeFragment())
            .commit()

        bottomNavigation = findViewById(R.id.tab_layout_bottom_navigation)
        bottomNavigation.setOnNavigationItemSelectedListener { item ->
            when(item.itemId){
                R.id.navigation_page_1 -> {
                    supportFragmentManager.beginTransaction()
                        .replace(R.id.frame_layout_main, HomeFragment())
                        .commit()
                    true
                }
                R.id.navigation_page_2 -> {
                    supportFragmentManager.beginTransaction()
                        .replace(R.id.frame_layout_main, OrderFragment())
                        .commit()
                    true
                }
                R.id.navigation_page_3 -> {
                    supportFragmentManager.beginTransaction()
                        .replace(R.id.frame_layout_main, MypageFragment())
                        .commit()
                    true
                }
                else -> false
            }
        }

        bottomNavigation.setOnNavigationItemReselectedListener { item ->
            // 재선택시 다시 랜더링 하지 않기 위해 수정
            if(bottomNavigation.selectedItemId != item.itemId){
                bottomNavigation.selectedItemId = item.itemId
            }
        }
        getLastOrder()
    }

    fun openFragment(index:Int, key:String, value:Int){
        moveFragment(index, key, value)
    }

    fun openFragment(index: Int) {
        moveFragment(index, "", 0)
    }

    private fun moveFragment(index:Int, key:String, value:Int){
        val transaction = supportFragmentManager.beginTransaction()
        when(index){
            //장바구니
            1 -> transaction.replace(R.id.frame_layout_main, ShoppingListFragment(shoppingList))
                .addToBackStack(null)
            //주문 상세 보기
            2 -> transaction.replace(R.id.frame_layout_main, OrderDetailFragment.newInstance(key, value))
                .addToBackStack(null)
            //메뉴 상세 보기
            3 -> transaction.replace(R.id.frame_layout_main, MenuDetailFragment.newInstance(key, value))
                .addToBackStack(null)
            //map으로 가기
            4 -> transaction.replace(R.id.frame_layout_main, MapFragment())
                .addToBackStack(null)
            //logout
            5 -> {
                logout()
            }
        }
        transaction.commit()
    }

    fun logout(){
        //preference 지우기
        ApplicationClass.sharedPreferencesUtil.deleteUser()

        //화면이동
        val intent = Intent(this, LoginActivity::class.java)
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);

        startActivity(intent)
    }

    fun hideBottomNav(state : Boolean){
        if(state) bottomNavigation.visibility =  View.GONE
        else bottomNavigation.visibility = View.VISIBLE
    }

    private fun setNdef(){

        nfcAdapter = NfcAdapter.getDefaultAdapter(this)

        // 포그라운드 기능 설정을 위한 코드
        val i = Intent(this, MainActivity::class.java)  // mainActivity 자기 자신이 처리하기 때문에 파라미타로 mainA 부여
        i.flags = Intent.FLAG_ACTIVITY_SINGLE_TOP
        pIntent = PendingIntent.getActivity(this, 0, i, 0) // 위임을 해주는데 나를 넘겨주겠다

        val ndf_filter = IntentFilter(NfcAdapter.ACTION_NDEF_DISCOVERED)
        ndf_filter.addDataType("text/plain")

        filters = arrayOf(ndf_filter)

    }

    override fun onNewIntent(intent: Intent?) {
        super.onNewIntent(intent)
        if (intent!!.action.equals(NfcAdapter.ACTION_NDEF_DISCOVERED)) {
            Log.d(TAG, "onNewIntent: ")
            getNFCData(intent = intent)
        }
    }


    // Tag Data 추출하는 함수
    private fun getNFCData(intent: Intent) {
        // Tag가 태깅되었을 때 데이터 추출
        if(intent.action.equals(NfcAdapter.ACTION_NDEF_DISCOVERED)) {
            val rawMsgs = intent.getParcelableArrayExtra(NfcAdapter.EXTRA_NDEF_MESSAGES)

            if(rawMsgs != null) {
                val message = arrayOfNulls<NdefMessage>(rawMsgs.size)
                for(i in rawMsgs.indices) {
                    message[i] = rawMsgs[i] as NdefMessage
                }
                // 실제 저장되어 있는 데이터를 추출
                val record_data = message[0]!!.records[0]
                val record_type = record_data.type
                val type = String(record_type)
                if(type.equals("T")) {
                    val data = message[0]!!.records[0].payload
                    orderTable = String(data, 3, data.size - 3)
                    ApplicationClass.sharedPreferencesUtil.addOrderTable(orderTable!!)
                    Log.d(TAG, "getNFCData: $orderTable")
                }
            }
        }
    }


    private fun setBeacon(){
        beaconManager = BeaconManager.getInstanceForApplication(this)
        beaconManager.beaconParsers.add(BeaconParser().setBeaconLayout("m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24"))
        bluetoothManager = getSystemService(BLUETOOTH_SERVICE) as BluetoothManager
        bluetoothAdapter = bluetoothManager.adapter
    }

    // NotificationChannel 설정
    private fun createNotificationChannel(id: String, name: String) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val importance = NotificationManager.IMPORTANCE_DEFAULT
            val channel = NotificationChannel(id, name, importance)

            val notificationManager: NotificationManager
                    = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun checkPermissions(){
        if(ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
            != PackageManager.PERMISSION_GRANTED){
            ActivityCompat.requestPermissions(
                this,
                requiredPermissions,
                PERMISSIONS_CODE
            )
        }
    }

    //----------------------------------------------------------------------------------------------
    // beacon 관련 함수
    // 매장 내에 비콘이 설치되어 있다 가정하고 비콘과 사용자 거리가 1M 이내이면 dialog

    // 블루투스 켰는지 확인
    private fun isEnableBLEService(): Boolean{
        if(!bluetoothAdapter!!.isEnabled){
            Log.d(TAG, "isEnableBLEService: false ")
            return false
        }
        Log.d(TAG, "isEnableBLEService: true")
        return true
    }

    // Beacon Scan 시작
    private fun startScan() {
        // 블루투스 Enable 확인
        if(!isEnableBLEService()){
            requestEnableBLE()
            Log.d(TAG, "startScan: 블루투스가 켜지지 않았습니다.")
            return
        }

        // 위치 정보 권한 허용 및 GPS Enable 여부 확인
        if(ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
            != PackageManager.PERMISSION_GRANTED){
            ActivityCompat.requestPermissions(
                this,
                requiredPermissions,
                PERMISSIONS_CODE
            )
        }
        Log.d(TAG, "startScan: beacon Scan start")

        // Beacon Service bind
        beaconManager.bind(this)
    }

    // 블루투스 ON/OFF 여부 확인 및 키도록 하는 함수
    private fun requestEnableBLE(){
        val callBLEEnableIntent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
        requestBLEActivity.launch(callBLEEnableIntent)
        Log.d(TAG, "requestEnableBLE: ")
    }

    private val requestBLEActivity: ActivityResultLauncher<Intent> = registerForActivityResult(
        ActivityResultContracts.StartActivityForResult()
    ){
        // 사용자의 블루투스 사용이 가능한지 확인
        if (isEnableBLEService()) {
            needBLERequest = false
            startScan()
        }
    }

    // 위치 정보 권한 요청 결과 콜백 함수
    // ActivityCompat.requestPermissions 실행 이후 실행
    override fun onRequestPermissionsResult(requestCode: Int,
                                            permissions: Array<String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        when (requestCode) {
            PERMISSIONS_CODE -> {
                if(grantResults.isNotEmpty()) {
                    for((i, permission) in permissions.withIndex()) {
                        if(grantResults[i] != PackageManager.PERMISSION_GRANTED) {
                            //권한 획득 실패
                            Log.i(TAG, "$permission 권한 획득에 실패하였습니다.")
                            finish()
                        }
                    }
                }
            }
        }
    }

    override fun onBeaconServiceConnect() {
        beaconManager.addMonitorNotifier(object : MonitorNotifier {
            override fun didEnterRegion(region: Region?) {
                try {
                    Log.d(TAG, "비콘을 발견하였습니다.------------${region.toString()}")
                    beaconManager.startRangingBeaconsInRegion(region!!)
                } catch (e: RemoteException) {
                    e.printStackTrace()
                }

            }
            override fun didExitRegion(region: Region?) {
                try {
                    Log.d(TAG, "비콘을 찾을 수 없습니다.")
                    beaconManager.stopRangingBeaconsInRegion(region!!)
                } catch (e: RemoteException) {
                    e.printStackTrace()
                }
            }
            override fun didDetermineStateForRegion(i: Int, region: Region?) {}
        })
        try {
            beaconManager.startMonitoringBeaconsInRegion(region)
            Log.d(TAG, "onBeaconServiceConnect: ${region.id1}")

        } catch (e: RemoteException){
            e.printStackTrace()
        }
        beaconManager.addRangeNotifier { beacons, region ->
            for (beacon in beacons) {
                // Major, Minor로 Beacon 구별, 1미터 이내에 들어오면 메세지 출력

                if(isYourBeacon(beacon)){
                    if(isDialogCalled == false && isLastOrderLoaded == true) {
//                        showDialog()
                        runOnUiThread{
                            showDialog()
                        }
                    }
                }
            }

            if(beacons.isEmpty()){
                Log.d(TAG, "onBeaconServiceConnect: isEMpty")
            }
        }
    }

    // 찾고자 하는 Beacon이 맞는지, 정해둔 거리 내부인지 확인
    private fun isYourBeacon(beacon: Beacon): Boolean {
//        return (beacon.id2.toString() == BEACON_MAJOR &&
//                beacon.id3.toString() == BEACON_MINOR &&
//                beacon.distance <= STORE_DISTANCE
//                )
        //1M안 비콘들을 모두 찾으시오.
        Log.d(TAG, "isYourBeacon: ")
        return (beacon.distance <= STORE_DISTANCE)
    }

    // 꼭 Destroy를 시켜서 beacon scan을 중지 시켜야 한다.
    // beacon scan을 중지 하지 않으면 일정 시간 이후 다시 scan이 가능하다.
//    override fun onDestroy() {
//
//        super.onDestroy()
//        beaconManager.stopMonitoringBeaconsInRegion(region)
//        beaconManager.stopRangingBeaconsInRegion(region)
//        beaconManager.unbind(this)
//    }

    override fun onResume() {
        super.onResume()
        startScan()
    }

    override fun onPause() {
        beaconManager.stopMonitoringBeaconsInRegion(region)
        beaconManager.stopRangingBeaconsInRegion(region)
        beaconManager.unbind(this)
        super.onPause()
    }

//    override fun onStop() {
//        beaconManager.stopMonitoringBeaconsInRegion(region)
//        beaconManager.stopRangingBeaconsInRegion(region)
//        beaconManager.unbind(this)
//        super.onStop()
//    }

    private fun showDialog() {
        isDialogCalled = true

        dialog.setContentView(R.layout.dialog_notice_info)

        var menuImg = dialog.findViewById<ImageView>(R.id.dialog_menuImg)
        var menuName = dialog.findViewById<TextView>(R.id.dialog_menuName)
        var menuPrice = dialog.findViewById<TextView>(R.id.dialog_menuPrice)
        var confirm = dialog.findViewById<TextView>(R.id.dialog_confirm)

//        dialog.findViewById<LinearLayout>(R.id.dialog_lastOrder).visibility = View.VISIBLE

        if(lastOrder != null) {
            dialog.findViewById<LinearLayout>(R.id.dialog_lastOrder).visibility = View.VISIBLE
            Glide.with(this@MainActivity).load("${ApplicationClass.MENU_IMGS_URL}${lastOrder!!.img}").into(menuImg)
            menuName.text = lastOrder!!.productName
            menuPrice.text = "${lastOrder!!.orderCnt}잔"
        } else {
            dialog.findViewById<LinearLayout>(R.id.dialog_lastOrder).visibility = View.GONE
            dialog.findViewById<TextView>(R.id.dialog_tmp).visibility = View.VISIBLE
        }

        confirm.setOnClickListener {
            dialog.dismiss()
        }

        dialog.show()
    }


    fun getLastOrder() {
        val live = OrderService().getLastMonthOrder(ApplicationClass.sharedPreferencesUtil.getUser().id)
        Log.d(TAG, "getLastOrder: ${live.value.toString()}")
          live.observe(this) {
            if(it != null && it.isNotEmpty()) lastOrder = it[0]
              Log.d(TAG, "getLastOrder: ${it[0]}")
            isLastOrderLoaded = true
        }
    }
}

