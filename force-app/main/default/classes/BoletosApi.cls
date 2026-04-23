public with sharing class BoletosApi {
    
    private static final String AUTH_ENDPOINT = 'callout:TokenBoletos';
    private static final String BOLETOS_ENDPOINT = 'callout:Boletos';
    private static final String CACHE_KEY = 'local.AuxiliadoraCache.token';
    private static final Integer CACHE_TTL = 86400;
    
    public static String obterToken() {
        String cachedToken = getCachedToken();
        if (String.isNotBlank(cachedToken)) {
            return cachedToken;
        }
        
        return autenticarECachearToken();
    }
    
    private static String getCachedToken() {
        if (Cache.Org.contains(CACHE_KEY)) {
            return (String) Cache.Org.get(CACHE_KEY);
        }
        return null;
    }
    
    private static String autenticarECachearToken() {
        CA_ParametrosIntegracao__mdt parametros = getParametrosIntegracao();
        
        if (parametros == null) {
            return null;
        }
        
        BoletosDTO.AuthRequest authRequest = new BoletosDTO.AuthRequest();
        authRequest.client_id = parametros.CA_ClientId__c;
        authRequest.client_secret = parametros.CA_ClientSecret__c;
        authRequest.username = parametros.CA_Username__c;
        authRequest.password = parametros.CA_Password__c;
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(AUTH_ENDPOINT);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON.serialize(authRequest));
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            BoletosDTO.AuthResponse authResponse = BoletosDTO.parseAuthResponse(res.getBody());
            if (authResponse != null && String.isNotBlank(authResponse.access_token)) {
                Cache.Org.put(CACHE_KEY, authResponse.access_token, CACHE_TTL);
                return authResponse.access_token;
            }
        }
        
        return null;
    }
    
    private static CA_ParametrosIntegracao__mdt getParametrosIntegracao() {
        List<CA_ParametrosIntegracao__mdt> parametros = [
            SELECT CA_ClientId__c, CA_ClientSecret__c, CA_Username__c, CA_Password__c
            FROM CA_ParametrosIntegracao__mdt
            LIMIT 1
        ];
        
        return parametros.isEmpty() ? null : parametros[0];
    }
    
    public static BoletosDTO.ApiResponse consultarBoletos(String cpfCnpj) {
        String token = obterToken();
        
        if (String.isBlank(token)) {
            return null;
        }
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(BOLETOS_ENDPOINT + '/' + cpfCnpj);
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + token);
        req.setHeader('Content-Type', 'application/json');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            return BoletosDTO.parseBoletosResponse(res.getBody());
        }
        
        return null;
    }
}