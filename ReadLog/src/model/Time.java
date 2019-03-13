package model;

public class Time {

    private String nome;
    private int partidas;
    private double somatorioMassium;
    private int qtdJobComum;
    private int qtdMission;
    private int qtdTotalJobs;
    private double mediaMassium;
    private double dpMassium;
    private double mediaJobComum;
    private double dpJobComum;
    private double mediaMission;
    private double dpMission;


    public Time(String nome, int partidas, double somatorioMassium, int qtdTotalJobs) {
        this.nome = nome;
        this.partidas = partidas;
        this.somatorioMassium = somatorioMassium;
        this.qtdTotalJobs = qtdTotalJobs;
    }

    public Time(String nome, int partidas) {
        this.nome = nome;
        this.partidas = partidas;
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

    public int getQtdTotalJobs() {
        return qtdTotalJobs;
    }

    public void setQtdTotalJobs(int qtdTotalJobs) {
        this.qtdTotalJobs = qtdTotalJobs;
    }

    public int getPartidas() {
        return partidas;
    }

    public void setPartidas(int partidas) {
        this.partidas = partidas;
    }

    public int getQtdJobComum() {
        return qtdJobComum;
    }

    public void setQtdJobComum(int qtdJobComum) {
        this.qtdJobComum = qtdJobComum;
    }

    public int getQtdMission() {
        return qtdMission;
    }

    public void setQtdMission(int qtdMission) {
        this.qtdMission = qtdMission;
    }

    public double getMediaMassium() {
        return mediaMassium;
    }

    public void setMediaMassium(double mediaMassium) {
        this.mediaMassium = mediaMassium;
    }

    public double getDpMassium() {
        return dpMassium;
    }

    public void setDpMassium(double dpMassium) {
        this.dpMassium = dpMassium;
    }

    public double getMediaJobComum() {
        return mediaJobComum;
    }

    public void setMediaJobComum(double mediaJobComum) {
        this.mediaJobComum = mediaJobComum;
    }

    public double getDpJobComum() {
        return dpJobComum;
    }

    public void setDpJobComum(double dpJobComum) {
        this.dpJobComum = dpJobComum;
    }

    public double getMediaMission() {
        return mediaMission;
    }

    public void setMediaMission(double mediaMission) {
        this.mediaMission = mediaMission;
    }

    public double getDpMission() {
        return dpMission;
    }

    public void setDpMission(double dpMission) {
        this.dpMission = dpMission;
    }

    @Override
    public String toString() {
        return "Time{" +
                "\n\tNome='" + nome + '\'' +
                "\n\tPartidas=" + partidas +
                "\n\tQtdTotalJobs=" + qtdTotalJobs +
                "\n\tSomatorioMassium=" + somatorioMassium +
                "\n\tMediaMassium=" + mediaMassium +
                "\n\tDesvio Padrão Massium=" + dpMassium +
                "\n\tQtdJobComum=" + qtdJobComum +
                "\n\tMediaJobComum=" + mediaJobComum +
                "\n\tDesvio Padrão JobComum=" + dpJobComum +
                "\n\tQtdMission=" + qtdMission +
                "\n\tMediaMission=" + mediaMission +
                "\n\tDesvio Padrão Mission=" + dpMission +
                "\n}";
    }
}
