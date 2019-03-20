package model;

public class Partida {
    private String id;
    private int semente;
    private int qtdJobComum;
    private int qtdAuctionJob;
    private int qtdMission;

    private Time timeA;
    private Time timeB;

    public Partida(int semente, int qtdJobComum, Time timeA, Time timeB) {
        this.semente = semente;
        this.qtdJobComum = qtdJobComum;
        this.timeA = timeA;
        this.timeB = timeB;
    }

    public Partida() {
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public int getSemente() {
        return semente;
    }

    public void setSemente(int semente) {
        this.semente = semente;
    }

    public int getQtdJobComum() {
        return qtdJobComum;
    }

    public void setQtdJobComum(int qtdJobComum) {
        this.qtdJobComum = qtdJobComum;
    }

    public Time getTimeA() {
        return timeA;
    }

    public void setTimeA(Time timeA) {
        this.timeA = timeA;
    }

    public Time getTimeB() {
        return timeB;
    }

    public void setTimeB(Time timeB) {
        this.timeB = timeB;
    }

    public int getQtdAuctionJob() {
        return qtdAuctionJob;
    }

    public void setQtdAuctionJob(int qtdAuctionJob) {
        this.qtdAuctionJob = qtdAuctionJob;
    }

    public int getQtdMission() {
        return qtdMission;
    }

    public void setQtdMission(int qtdMission) {
        this.qtdMission = qtdMission;
    }

    @Override
    public String toString() {
        return "Partida{" +
                "\n\tid='" + id + '\'' +
                "\n\tsemente=" + semente +
                "\n\tqtdJobComum=" + qtdJobComum +
                "\n\tqtdAuctionJob=" + qtdAuctionJob +
                "\n\tqtdMission=" + qtdMission +
                "\n\ttimeA=" + timeA +
                "\n\ttimeB=" + timeB +
                "\n}";
    }
}
