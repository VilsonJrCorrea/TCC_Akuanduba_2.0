import model.Partida;
import model.Time;
import util.File;
import util.SaveInExcel;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class Main {

    private static final String timeA = "A";
    private static final String timeB = "B";
    private static final String newId = " Configuring simulation id: ";
    private static final String jobCompleted = "Job completed by ";
    private static final String configuringSeed = " Configuring random seed: ";
    private static final String newJob = "New Job:";
    private static final String job = "Job";
    private static final String mission = "Mission";
    private static final String actionJob = "AuctionJob";

    private static final String newMission = "New Mission";
    private static final String newAuctionJob = "New AuctionJob: ";

    public static void main(String[] args) {
        List<String> conteudo = File.getDadosPartidas();
        List<Partida> partidas = new ArrayList<>();
        Time objTimeA = null;
        Time objTimeB = null;
        Partida partida = null;
        int i;

        for (String linha : conteudo) {
            if (linha.contains(configuringSeed)) {
                i = Integer.parseInt(linha.split(": ", 0)[1]);
                objTimeA = new Time(timeA, 0, 0, 0, 0, 0, 0, 0, 0, 0);
                objTimeB = new Time(timeB, 0, 0, 0, 0, 0, 0, 0, 0, 0);
                partida = new Partida(i, 0, objTimeA, objTimeB);
                partidas.add(partida);
            } else if (linha.contains(newId)) {
                String s = linha.split(newId, 0)[1];
                partida.setId(s);
            } else if (linha.contains(newJob)) {
                i = partida.getQtdJobComum();
                partida.setQtdJobComum(i + 1);
            } else if (linha.contains(newMission)) {
                i = partida.getQtdMission();
                partida.setQtdMission(i + 1);
            } else if (linha.contains(newAuctionJob)) {
                i = partida.getQtdAuctionJob();
                partida.setQtdAuctionJob(i + 1);
            } else if (linha.contains(jobCompleted)) {
                String s = linha.split("type\\(", 0)[1].split("\\)")[0];
                double r = Double.parseDouble(linha.split("reward\\(", 0)[1].split("\\)")[0]);
                if (linha.contains(jobCompleted + timeA)) {
                    if (s.equals(job)) {
                        interateJobComumAtendido(partida.getTimeA());
                        interateMassium(partida.getTimeA(), r);
                    } else if (s.equals(mission)) {
                        interateMissionAtendida(partida.getTimeA());
                        interateMassiumMission(partida.getTimeA(), r);
                    } else if (s.equals(actionJob)) {
                        interateAuctionJobAtendida(partida.getTimeA());
                        interateMassiumAuction(partida.getTimeA(), r);
                    }
                } else if (linha.contains(jobCompleted + timeB)) {
                    if (s.equals(job)) {
                        interateJobComumAtendido(partida.getTimeB());
                        interateMassium(partida.getTimeB(), r);
                    } else if (s.equals(mission)) {
                        interateMissionAtendida(partida.getTimeB());
                        interateMassiumMission(partida.getTimeB(), r);
                    } else if (s.equals(actionJob)) {
                        interateAuctionJobAtendida(partida.getTimeB());
                        interateMassiumAuction(partida.getTimeB(), r);
                    }
                }
            }
        }

        for (Partida p : partidas) {
            //comum
            double qtdJob = p.getQtdJobComum();
            double qtdMission = p.getQtdMission();
            //A
            calcularSomatorio(p.getTimeA());
            calcularProporcaoJob(qtdJob, p.getTimeA());
            calcularProporcaoMission(qtdMission, p.getTimeA());

            //B
            calcularSomatorio(p.getTimeB());
            calcularProporcaoJob(qtdJob, p.getTimeB());
            calcularProporcaoMission(qtdMission, p.getTimeB());
        }
        try {
            SaveInExcel.save(partidas);
        } catch (IOException e) {
            e.printStackTrace();
        }
        System.out.println(partidas.toString());
    }

    private static void interateMassiumAuction(Time time, double r) {
        double somatorio = time.getSomatioMassiumAuctionJob();
        time.setSomatioMassiumAuctionJob(somatorio + r);
    }

    private static void interateAuctionJobAtendida(Time time) {
        int i = time.getQtdAuctionJobAtendido();
        time.setQtdAuctionJobAtendido(i + 1);
    }

    private static void interateMassiumMission(Time time, double r) {
        double somatorio = time.getSomatorioMassiunMission();
        time.setSomatorioMassiunMission(somatorio + r);
    }

    private static void interateMissionAtendida(Time time) {
        int i = time.getQtdMissionAtendido();
        time.setQtdMissionAtendido(i + 1);
    }

    private static void interateMassium(Time time, double r) {
        double somatorio = time.getSomatorioMassiumJob();
        time.setSomatorioMassiumJob(somatorio + r);
    }

    private static void interateJobComumAtendido(Time time) {
        int i = time.getQtdJobComumAtendido();
        time.setQtdJobComumAtendido(i + 1);
    }

    private static void calcularProporcaoMission(double qtdMission, Time time) {
        double missionAtendido = time.getQtdMissionAtendido();
        time.setProporcaoMission(missionAtendido / qtdMission);
    }

    private static void calcularProporcaoJob(double qtdJob, Time time) {
        double jobAtendido = time.getQtdJobComumAtendido();
        time.setProporcaoJob(jobAtendido / qtdJob);
    }


    private static void calcularSomatorio(Time time) {
        time.setSomatorioMassium(time.getSomatioMassiumAuctionJob() +
                time.getSomatorioMassiumJob() +
                time.getSomatorioMassiunMission());
    }


}
