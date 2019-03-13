package util;


import model.Time;

public class UpdateTime {
    private static final String typeMission = "Mission";
    private static final String typeJob = "Job";

    public static void changeObj(Time time, String linha) {
        double recompensa = Double.parseDouble(linha.split("reward\\(", 2)[1].split("\\)", 2)[0]);
        String type = linha.split("type\\(", 2)[1].split("\\)", 2)[0];
        int qtd = time.getQtdTotalJobs();
        double rec = time.getSomatorioMassium();
        time.setSomatorioMassium(rec + recompensa);
        time.setQtdTotalJobs(qtd + 1);
        if (typeJob.equals(type)) {
            int qtdJobs = time.getQtdJobComum();
            time.setQtdJobComum(qtdJobs + 1);
        } else {
            int qtdMission = time.getQtdMission();
            time.setQtdMission(qtdMission + 1);
        }
    }

    public static Time setMediaEDp(Time time) {
        double[] re;
        re = Calculos.getMediaComDP(time.getSomatorioMassium(), time.getPartidas());
        time.setMediaMassium(re[0]);
        time.setDpMassium(re[1]);
        re = Calculos.getMediaComDP(time.getQtdJobComum(), time.getPartidas());
        time.setMediaJobComum(re[0]);
        time.setDpJobComum(re[1]);
        re = Calculos.getMediaComDP(time.getQtdMission(), time.getPartidas());
        time.setMediaMission(re[0]);
        time.setDpMission(re[1]);
        return time;
    }
}
