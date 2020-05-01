public class ApexUtil {
    public static Boolean isAdvancedMDAccountTriggerInvoked = false;
    public static Boolean isContactTriggerInvoked = false;
    public static Boolean isOpportunityTriggerInvoked = false;
    public static Boolean isAppointmentTriggerInvoked = false;
    public static Boolean isTaskTriggerInvoked = false;
    public static Boolean isAuthorizeAccountTriggerInvoked = false;
    public static Boolean isAuthorizePaymentMethodTriggerInvoked = false;
    public static Boolean isAccountTriggerInvoked = false; //variable llamada en batch pero no existía
    public static Map<String, String> templatesNameRMMC = new Map<String, String>{'100000053'=>'Dose Adjust Note', '100000055'=>'Lab/Shot Note', '100000058'=>'Blood Draw', '100000061'=>'Coordinator / Follow up Note', '100000062'=>'Quick Note', '100000065'=>'TRT Boost', '100000067'=>'Lab Review Note', '100000069'=>'Meds Picked Up', '100000072'=>'Current Dose Note', '100000073'=>'Medication Request/Prepare', '100000074'=>'Quick Drop-In', '100000078'=>'NewIntake Note', '100000079'=>'RETEST', '100000083'=>'Plan Tracking Note', '100000085'=>'IIEF/SHIM and ADAMs', '100000092'=>'ESWT Procedure Note', '100000097'=>'After Hours Note'};
    public static Map<String, String> templatesNameBRMC = new Map<String, String>{'100000591'=>'Dose Adjust Note', '100000341'=>'Lab/Shot Note', '100000608'=>'Blood Draw', '100000593'=>'Coordinator / Follow up Note', '100000606'=>'Quick Note', '100000605'=>'TRT Boost', '100000344'=>'Lab Review Note', '100000342'=>'Meds Picked Up', '100000596'=>'Current Dose Note', '100000602'=>'Medication Request/Prepare', '100000607'=>'Quick Drop-In', '100000343'=>'NewIntake Note', '100000595'=>'RETEST', '100000594'=>'Plan Tracking Note', '100000604'=>'IIEF/SHIM and ADAMs', '100000601'=>'ESWT Procedure Note', '100000345'=>'After Hours Note'};
    public static Map<String, String> templatesNameNMC = new Map<String, String>{'100000177'=>'Dose Adjust Note', '100000178'=>'Lab/Shot Note', '100000180'=>'Meds Picked Up', '100000179'=>'Current Dose Note', '100000176'=>'NewIntake Note', '100000185'=>'IIEF/SHIM and ADAMs', '100000184'=>'ESWT Procedure Note'};
    public static Map<String, String> templatesNameCMC = new Map<String, String>{'100000702'=>'Dose Adjust Note', '100000708'=>'Lab/Shot Note', '100000716'=>'Blood Draw', '100000700'=>'Coordinator / Follow up Note', '100000714'=>'Quick Note', '100000719'=>'TRT Boost', '100000707'=>'Lab Review Note', '100000711'=>'Meds Picked Up', '100000701'=>'Current Dose Note', '100000709'=>'Medication Request/Prepare', '100000718'=>'Quick Drop-In', '100000712'=>'NewIntake Note', '100000715'=>'RETEST', '100000713'=>'Plan Tracking Note', '100000706'=>'IIEF/SHIM and ADAMs', '100000704'=>'ESWT Procedure Note', '100000699'=>'After Hours Note'};
    public static Map<String, String> templatesNameAMC = new Map<String, String>{'100000300'=>'Dose Adjust Note', '100000306'=>'Lab/Shot Note', '100000314'=>'Blood Draw', '100000298'=>'Coordinator / Follow up Note', '100000312'=>'Quick Note', '100000317'=>'TRT Boost', '100000305'=>'Lab Review Note', '100000309'=>'Meds Picked Up', '100000299'=>'Current Dose Note', '100000307'=>'Medication Request/Prepare', '100000316'=>'Quick Drop-In', '100000310'=>'NewIntake Note', '100000313'=>'RETEST', '100000311'=>'Plan Tracking Note', '100000304'=>'IIEF/SHIM and ADAMs', '100000302'=>'ESWT Procedure Note', '100000297'=>'After Hours Note'};    
    public static Map<String, String> templatesNameTMC = new Map<String, String>{'100000772'=>'Dose Adjust Note', '100000777'=>'Lab/Shot Note', '100000786'=>'Blood Draw', '100000770'=>'Coordinator / Follow up Note', '100000783'=>'Quick Note', '100000789'=>'TRT Boost', '100000776'=>'Lab Review Note', '100000780'=>'Meds Picked Up', '100000771'=>'Current Dose Note', '100000778'=>'Medication Request/Prepare', '100000788'=>'Quick Drop-In', '100000781'=>'NewIntake Note', '100000784'=>'RETEST', '100000782'=>'Plan Tracking Note', '100000775'=>'IIEF/SHIM and ADAMs', '100000773'=>'ESWT Procedure Note', '100000769'=>'After Hours Note'};    
    public static Map<String, String> sourcesNMC = new Map<String, String>{'32'=>'BOSTON GLOBE', '33'=>'BOSTON HERALD', '33'=>'BOSTON HERALD', '34'=>'DIRECT MAIL', '37'=>'DR. LASPINA', '35'=>'FORMER MENS CLINIC P', '36'=>'FRIEND REFERRAL',
        																	'1'=>'PATIENT', '2'=>'REFERRING PROVIDER', '38'=>'UNKNOWN', '39'=>'WAAF 107.3 FM', '40'=>'WALK IN', '41'=>'WEBSITE', '42'=>'WEEI 850AM',
        																	'43'=>'WEEI 93.7 FM (SPORTS)', '44'=>'WMUR CHAN #9', '41'=>'WZLX 100.7'};
  	public static Map<String, String> sourcesBRMC = new Map<String, String>{'106'=>'A* 1150 WJBO NEWS', '33'=>'BOSTON HERALD', '123'=>'A* 94.1 WEMX (R&B)', '120'=>'A*101.5 WYNK (COUNTR', '121'=>'A*102.5 WFMF (TALK)', '122'=>'A*103.3 WRQQ (CLASSI', '103'=>'A*104.5 ESPN WNXX',
        																	'105'=>'A*106.5 KQXL (R&B)', '104'=>'A*107.3 WBRP (TALK)', '113'=>'B - REFERRAL', '114'=>'B - UNKNOWN/OTHER', '115'=>'B - WEBSITE', '116'=>'C - 98.1 WDGL (EAGLE', '108'=>'C - ADVOCATE NEWSPAP',
        																	'112'=>'C - TV -  (WAFB CBS', '107'=>'C - TV - CNBC', '109'=>'C - TV - ESPN', '111'=>'C - TV - GOLF', '110'=>'C- TV - FOX NEWS'};
    public static Map<String, String> sourcesRMMC = new Map<String, String>{'32'=>'BOSTON GLOBE', '33'=>'BOSTON HERALD', '33'=>'BOSTON HERALD', '34'=>'DIRECT MAIL', '37'=>'DR. LASPINA', '35'=>'FORMER MENS CLINIC P', '36'=>'FRIEND REFERRAL',
        																	'1'=>'PATIENT', '2'=>'REFERRING PROVIDER', '38'=>'UNKNOWN', '39'=>'WAAF 107.3 FM', '40'=>'WALK IN', '41'=>'WEBSITE', '42'=>'WEEI 850AM',
        																	'43'=>'WEEI 93.7 FM (SPORTS)', '44'=>'WMUR CHAN #9', '41'=>'WZLX 100.7'};
	public static Map<String, String> sourcesCMC = new Map<String, String>{'32'=>'BOSTON GLOBE', '33'=>'BOSTON HERALD', '33'=>'BOSTON HERALD', '34'=>'DIRECT MAIL', '37'=>'DR. LASPINA', '35'=>'FORMER MENS CLINIC P', '36'=>'FRIEND REFERRAL',
        																	'1'=>'PATIENT', '2'=>'REFERRING PROVIDER', '38'=>'UNKNOWN', '39'=>'WAAF 107.3 FM', '40'=>'WALK IN', '41'=>'WEBSITE', '42'=>'WEEI 850AM',
        																	'43'=>'WEEI 93.7 FM (SPORTS)', '44'=>'WMUR CHAN #9', '41'=>'WZLX 100.7'};
	public static Map<String, String> sourcesAMC = new Map<String, String>{'32'=>'BOSTON GLOBE', '33'=>'BOSTON HERALD', '33'=>'BOSTON HERALD', '34'=>'DIRECT MAIL', '37'=>'DR. LASPINA', '35'=>'FORMER MENS CLINIC P', '36'=>'FRIEND REFERRAL',
        																	'1'=>'PATIENT', '2'=>'REFERRING PROVIDER', '38'=>'UNKNOWN', '39'=>'WAAF 107.3 FM', '40'=>'WALK IN', '41'=>'WEBSITE', '42'=>'WEEI 850AM',
        																	'43'=>'WEEI 93.7 FM (SPORTS)', '44'=>'WMUR CHAN #9', '41'=>'WZLX 100.7'};
	public static Map<String, String> sourcesTMC = new Map<String, String>{'32'=>'BOSTON GLOBE', '33'=>'BOSTON HERALD', '33'=>'BOSTON HERALD', '34'=>'DIRECT MAIL', '37'=>'DR. LASPINA', '35'=>'FORMER MENS CLINIC P', '36'=>'FRIEND REFERRAL',
        																	'1'=>'PATIENT', '2'=>'REFERRING PROVIDER', '38'=>'UNKNOWN', '39'=>'WAAF 107.3 FM', '40'=>'WALK IN', '41'=>'WEBSITE', '42'=>'WEEI 850AM',
        																	'43'=>'WEEI 93.7 FM (SPORTS)', '44'=>'WMUR CHAN #9', '41'=>'WZLX 100.7'};
        public static String getAMDID(String idS, String org){
            return idS.contains(org) ? idS.substring(org.length()+1, idS.length()) : ids;
        }
}