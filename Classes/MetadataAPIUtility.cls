public class MetadataAPIUtility{
    public static boolean createRemoteSiteSettings(String newURLRemoteSite){
        boolean isSucessfull=false;
        Map<string,string> RemoteSiteMap = new Map<string,string>();
        RemoteSiteMap.put('AdvancedMD_'+String.valueOf(system.today().format()).replace('/','_'),newURLRemoteSite);
        List<MetadataService.Metadata> allMetadataList = new List<MetadataService.Metadata>();
        for(string ss: RemoteSiteMap.keyset()){
            MetadataService.RemoteSiteSetting remoteSiteDetails = new MetadataService.RemoteSiteSetting();
            remoteSiteDetails.fullName = ss;
            remoteSiteDetails.description = ss+'-created through apex';
            remoteSiteDetails.disableProtocolSecurity  = false;
            remoteSiteDetails.isActive  = true;
            remoteSiteDetails.url=RemoteSiteMap.get(ss);
            allMetadataList.add(remoteSiteDetails);
        }        
        if(allMetadataList.size()>0){
            system.debug('****RemoteSiteSettings allMetadataList:'+allMetadataList);
            MetadataService.MetadataPort service = createService();
            List<MetadataService.UpsertResult> results = service.upsertMetadata(allMetadataList);
            for(MetadataService.UpsertResult result: results){
                if(result.success){
                    system.debug('added remote site setting success='+result);
                    isSucessfull=true;
                }else{
                    system.debug('****error while adding remote site settings:'+result.errors[0].message);
                }
                
            }
            
        }
        return isSucessfull;
    }  
  
    private static MetadataService.MetadataPort createService(){ 
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;     
    }
}