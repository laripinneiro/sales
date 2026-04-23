public class BoletosDTO {
    
    public class AuthRequest {
        public String client_id;
        public String client_secret;
        public String username;
        public String password;
    }
    
    public class AuthResponse {
        public String access_token;
        public Integer expires_in;
        public String token_type;
    }
    
    public class ApiResponse {
        public Cobranca Cobranca;
        public List<BoletoData> Boletos;
    }
    
    public class Cobranca {
        public Boolean Aluguel;
        public Boolean Condominio;
    }
    
    public class BoletoData {
        public String descricao;
        public String vencimento;
        public String url;
        public String LinhaDigitavel;
    }
    
    public static Date parseVencimento(String vencimentoStr) {
        if (String.isBlank(vencimentoStr)) {
            return null;
        }
        
        List<String> parts = vencimentoStr.split('/');
        if (parts.size() != 3) {
            return null;
        }
        
        Integer day = Integer.valueOf(parts[0]);
        Integer month = Integer.valueOf(parts[1]);
        Integer year = Integer.valueOf(parts[2]);
        return Date.newInstance(year, month, day);

    }
    
    public static ApiResponse parseBoletosResponse(String responseBody) {
        return (ApiResponse) JSON.deserialize(responseBody, ApiResponse.class);
    }
    
    public static AuthResponse parseAuthResponse(String responseBody) {
        return (AuthResponse) JSON.deserialize(responseBody, AuthResponse.class);
    }
    
    public static Date getVencimentoAsDate(String vencimentoStr) {
        return parseVencimento(vencimentoStr);
    }
    
    public static String serializeBoletos(List<BoletoData> boletos) {
        return JSON.serialize(boletos);
    }
}