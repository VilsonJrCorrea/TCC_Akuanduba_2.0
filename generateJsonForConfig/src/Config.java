public class Config {
    private String scenario;
    private String host;
    private int port;
    private boolean scheduling;
    private int timeout;
    private boolean times;
    private boolean notifications;
    private boolean queued;
    private Entiti []entities;

    public Config(String scenario, String host, int port, boolean scheduling, int timeout, boolean times, boolean notifications, boolean queued, Entiti[] entities) {
        this.scenario = scenario;
        this.host = host;
        this.port = port;
        this.scheduling = scheduling;
        this.timeout = timeout;
        this.times = times;
        this.notifications = notifications;
        this.queued = queued;
        this.entities = entities;
    }
}
