public class Entiti {
    private String name;
    private String username;
    private String password;
    private boolean iilang;
    private boolean xml;

    public Entiti(String name, String username, String password, boolean iilang, boolean xml) {
        this.name = name;
        this.username = username;
        this.password = password;
        this.iilang = iilang;
        this.xml = xml;
    }

    public Entiti() {
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public boolean isIilang() {
        return iilang;
    }

    public void setIilang(boolean iilang) {
        this.iilang = iilang;
    }

    public boolean isXml() {
        return xml;
    }

    public void setXml(boolean xml) {
        this.xml = xml;
    }
}
