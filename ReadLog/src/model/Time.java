package model;

public class Time {
    private String nome;
    private double somatorioMassiumJob;
    private double somatorioMassiunMission;
    private double somatioMassiumAuctionJob;
    private double somatorioMassium;
    private int qtdJobComumAtendido;
    private int qtdMissionAtendido;
    private int qtdAuctionJobAtendido;
    private double proporcaoJob;
    private double proporcaoMission;

    public Time(String nome, double somatorioMassiumJob, double somatorioMassiunMission, double somatioMassiumAuctionJob, double somatorioMassium, int qtdJobComumAtendido, int qtdMissionAtendido, int qtdAuctionJobAtendido, double proporcaoJob, double proporcaoMission) {
        this.nome = nome;
        this.somatorioMassiumJob = somatorioMassiumJob;
        this.somatorioMassiunMission = somatorioMassiunMission;
        this.somatioMassiumAuctionJob = somatioMassiumAuctionJob;
        this.somatorioMassium = somatorioMassium;
        this.qtdJobComumAtendido = qtdJobComumAtendido;
        this.qtdMissionAtendido = qtdMissionAtendido;
        this.qtdAuctionJobAtendido = qtdAuctionJobAtendido;
        this.proporcaoJob = proporcaoJob;
        this.proporcaoMission = proporcaoMission;
    }

    public Time() {
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public double getSomatorioMassium() {
        return somatorioMassium;
    }

    public void setSomatorioMassium(double somatorioMassium) {
        this.somatorioMassium = somatorioMassium;
    }

    public int getQtdJobComumAtendido() {
        return qtdJobComumAtendido;
    }

    public void setQtdJobComumAtendido(int qtdJobComumAtendido) {
        this.qtdJobComumAtendido = qtdJobComumAtendido;
    }

    public int getQtdAuctionJobAtendido() {
        return qtdAuctionJobAtendido;
    }

    public void setQtdAuctionJobAtendido(int qtdAuctionJobAtendido) {
        this.qtdAuctionJobAtendido = qtdAuctionJobAtendido;
    }

    public int getQtdMissionAtendido() {
        return qtdMissionAtendido;
    }

    public void setQtdMissionAtendido(int qtdMissionAtendido) {
        this.qtdMissionAtendido = qtdMissionAtendido;
    }

    public double getProporcaoJob() {
        return proporcaoJob;
    }

    public void setProporcaoJob(double proporcaoJob) {
        this.proporcaoJob = proporcaoJob;
    }

    public double getProporcaoMission() {
        return proporcaoMission;
    }

    public void setProporcaoMission(double proporcaoMission) {
        this.proporcaoMission = proporcaoMission;
    }

    public double getSomatorioMassiumJob() {
        return somatorioMassiumJob;
    }

    public void setSomatorioMassiumJob(double somatorioMassiumJob) {
        this.somatorioMassiumJob = somatorioMassiumJob;
    }

    public double getSomatorioMassiunMission() {
        return somatorioMassiunMission;
    }

    public void setSomatorioMassiunMission(double somatorioMassiunMission) {
        this.somatorioMassiunMission = somatorioMassiunMission;
    }

    public double getSomatioMassiumAuctionJob() {
        return somatioMassiumAuctionJob;
    }

    public void setSomatioMassiumAuctionJob(double somatioMassiumAuctionJob) {
        this.somatioMassiumAuctionJob = somatioMassiumAuctionJob;
    }

    @Override
    public String toString() {
        return "Time{" +
                "nome='" + nome + '\'' +
                ", somatorioMassiumJob=" + somatorioMassiumJob +
                ", somatorioMassiunMission=" + somatorioMassiunMission +
                ", somatioMassiumAuctionJob=" + somatioMassiumAuctionJob +
                ", somatorioMassium=" + somatorioMassium +
                ", qtdJobComumAtendido=" + qtdJobComumAtendido +
                ", qtdMissionAtendido=" + qtdMissionAtendido +
                ", qtdAuctionJobAtendido=" + qtdAuctionJobAtendido +
                ", proporcaoJob=" + proporcaoJob +
                ", proporcaoMission=" + proporcaoMission +
                '}';
    }
}

